"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I'm the visualization option for running components accessible from the Library tab -> Molecule -> Visualize running components.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	canvas:		<Object>
	runningComponents:		<Object>


    Implementation Points
"
Class {
	#name : #MolComponentVisualizer,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'runningComponents',
		'xValue',
		'yValue',
		'numberedComponent',
		'activatedAnnouncer',
		'removedAnnouncer',
		'window'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
MolComponentVisualizer >> addLineFrom: interfaceLabelOrShape to: otherInterfaceLabelOrShape [
	"used to link an interface label/shape to another interface label/shape (while being invisible by the color of the link being transparent), used to highlight the corresponding labels when an interface shape is hovered on"

	| line |
	line := RSLine new
		        from: interfaceLabelOrShape;
		        to: otherInterfaceLabelOrShape;
		        color: Color transparent;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	^ line
]

{ #category : #initialization }
MolComponentVisualizer >> buildComponent: aComponent [
	"builds a component visualization, similar to how the build method of ClyComponentBuilder works but for multiple components to be shown on the same canvas. numberedComponents is used to stock the number of the component (its index in the canvas) in its main box"

	| componentBuilder |
	componentBuilder := MolComponentBuilder new.
	componentBuilder implementation: aComponent.

	"showComponent returns a RSCanvas, adds every part of a component to the canvas"
	^ componentBuilder showComponent: numberedComponent
]

{ #category : #initialization }
MolComponentVisualizer >> buildComponents [
	"builds every component visualization"

	| canvasShape |
	self flag:
		'faire en sort que composant relié à autre soit placé à gauche?'.

	runningComponents keysDo: [ :component | "each component is its own shape of type RSComposite"
		numberedComponent := numberedComponent + 1.
		canvasShape := (self buildComponent: component) canvas asShape.

		self moveAndAddComponent: canvasShape ]
]

{ #category : #initialization }
MolComponentVisualizer >> canvas [
	"returns the canvas so that it can be opened in MolWorld"

	^ canvas
]

{ #category : #initialization }
MolComponentVisualizer >> clickingComponentShowsInspector [
	"double-clicking a component shows its detail in the Pharo Inspector"

	| canvasCompositeShapes lines |
	canvasCompositeShapes := self removeLinesForIteration.
	lines := OrderedCollection new.

	canvasCompositeShapes do: [ :composite |
		composite children do: [ :shape | "shape class = RSBox ifTrue:""("
			shape
				when: RSMouseDoubleClick
				do: [ :evt | "2nd shape of a RSComposite is always a RSLabel with the name of the component"
					(MolComponentManager default homeServices deployedComponents at:
						 (composite children at: 2) text asClass) inspect ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> createInvisibleLinksBetweenInterfaces [
	"if an interface declared in the offered contract part of component A is also used in the required part of component B of the same type (Event, Parameter or Service), creates a link between the shapes and the interface labels"

	| lineArray canvasCopy componentIndex componentCopyIndex canvasIndex requiredShape canvasCopyIndex offeredShape |
	lineArray := OrderedCollection new.
	canvasCopy := canvas.

	"component indexes are used to know which component is being selected"
	componentIndex := 0.
	componentCopyIndex := 0.

	"canvas indexes are used to know the position of labels in components shape list"
	canvasIndex := 0.
	canvasCopyIndex := 0.

	"iterates on two components at the same time in order to not make comparisons between elements of a same component (incoherent with Molecule architecture)"
	canvas shapes do: [ :component | "adds the line after in order to not update the canvas while it's being iterated on"
		componentIndex := componentIndex + 1.
		component class = RSLine ifFalse: [ "executed after createLinksBetweenInterfaces so need to account for that"
			component children do: [ :child |
				canvasIndex := canvasIndex + 1.
				canvasCopy shapes do: [ :component2 |
					componentCopyIndex := componentCopyIndex + 1.
					"safety measure to make sure that the two compared elements aren't from the same component"
					componentIndex = componentCopyIndex ifFalse: [
						component2 class = RSLine ifFalse: [ "same as last ifTrue: of the same nature"
							component2 children do: [ :child2 |
								canvasCopyIndex := canvasCopyIndex + 1.
								(child class = RSLabel and: child2 class = RSLabel) ifTrue: [ "verify that Roassal elements of type RSLabel aren't the same element"
									child == child2 ifFalse: [ "but have the same text"
										child text = child2 text ifTrue: [ "that isn't an empty string"
											child text = '' ifFalse: [
												requiredShape := self
													                 determineComponentShape: componentIndex
													                 canvasIndex: canvasIndex.

												offeredShape := self
													                determineComponentShape:
													                componentCopyIndex
													                canvasIndex: canvasCopyIndex.

												requiredShape class = offeredShape class ifFalse: [
													lineArray add:
														(self addLineFrom: child to: requiredShape).
													lineArray add: (self addLineFrom: child to: offeredShape).
													lineArray add:
														(self addLineFrom: child2 to: requiredShape).
													lineArray add:
														(self addLineFrom: child2 to: offeredShape).

													(child class = RSLabel and: child text = child2 text)
														ifTrue: [
														lineArray add: (self addLineFrom: child to: child2) ] ] ] ] ] ] ].
							canvasCopyIndex := 0 ] ] ].
				componentCopyIndex := 0 ] ].
		canvasIndex := 0 ].

	self removeDuplicateLines: lineArray
]

{ #category : #initialization }
MolComponentVisualizer >> createLinksAndHighlights [
	"regroups every function used to highlight and create links between components"

	self flag: 'highlightShapes: réexécuté fait bugger'.

	"links need to be created first in order to know what to highlight next"
	self createLinksBetweenInterfaces.
	self createInvisibleLinksBetweenInterfaces.

	self highlightShapes.
	self highlightShapeShowsLinkAndForm.
	self highlightComponent.

	self clickingComponentShowsInspector
]

{ #category : #initialization }
MolComponentVisualizer >> createLinksBetweenInterfaces [
	"if an interface declared in the offered contract part of component A is also used in the required part of component B of the same type (Event, Parameter or Service), creates a link between the shapes symbolizing the interfaces"

	| offeredShape requiredShape lineArray canvasCopy canvasIndex canvasCopyIndex componentIndex componentCopyIndex |
	lineArray := OrderedCollection new.
	canvasCopy := canvas.

	"component indexes are used to know which component is being selected"
	componentIndex := 0.
	componentCopyIndex := 0.

	"canvas indexes are used to know the position of labels in components shape list"
	canvasIndex := 0.
	canvasCopyIndex := 0.

	"iterates on two components at the same time in order to not make comparisons between elements of a same component (incoherent with Molecule architecture)"
	canvas shapes do: [ :component | "adds the line after in order to not update the canvas while it's being iterated on"
		componentIndex := componentIndex + 1.
		component children do: [ :child |
			canvasIndex := canvasIndex + 1.
			canvasCopy shapes do: [ :component2 |
				componentCopyIndex := componentCopyIndex + 1.
				"safety measure to make sure that the two compared elements aren't from the same component"
				componentIndex = componentCopyIndex ifFalse: [
					component2 children do: [ :child2 |
						(child class = RSLabel and: child2 class = RSLabel) ifTrue: [ "verify that Roassal elements of type RSLabel aren't the same element"
							child == child2 ifFalse: [ "but have the same text"
								child text = child2 text ifTrue: [ "that isn't an empty string"
									child text = '' ifFalse: [
										requiredShape := self
											                 determineComponentShape: componentIndex
											                 canvasIndex: canvasIndex.
										offeredShape := self
											                determineComponentShape: componentCopyIndex
											                canvasIndex: canvasCopyIndex.

										"used so that two shapes representing the same part of a component's contract from different components cannot be linked"
										requiredShape class = offeredShape class ifFalse: [
											lineArray add:
												(self addLineFrom: requiredShape to: offeredShape) ] ] ] ] ].
						canvasCopyIndex := canvasCopyIndex + 1 ].
					canvasCopyIndex := 0 ] ].
			componentCopyIndex := 0 ].
		canvasIndex := 0 ].

	self removeDuplicateLines: lineArray
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> deleteAndRecreateLinksIfTwoComponentsOrMore [
	"deletes every link before recreating them if there are linked components on the screen"

	| emptyHighlightable |
	"emptyHighlightable := RSHighlightable new."
	self flag: 'nom à changer'.

	canvas shapes do: [ :shape |
		shape class = RSLine ifTrue: [ "deletes every link" "ifFalse: [" "and RSHighlightable associated to interface shapes or labels" "shape children do: [ :s | s @ emptyHighlightable ]" "shape @ emptyHighlightable ]"
			canvas removeShape: shape ] ].

	canvas zoomToFit.

	self flag: 'liens freeze en rouge sur ecran'.
	"recreates links"
	"self hasTwoComponentsOrMore ifTrue: [ self createLinksAndHighlights ]"
	self createLinksAndHighlights
]

{ #category : #initialization }
MolComponentVisualizer >> determineComponentShape: componentIndex canvasIndex: canvasIndex [
	"used to determine which shape of which component is the starting and end point of a line"

	"since we know the position of an interface label of a component that is connected to the same interface in another component's (mirror part of the contract) in the current used canvas, we can then deduce the position of its associated interface shape. To do that, we first need to understand how visualization of components are implemented: a component's part of the contract is visually represented by 0, 1 or more interface labels, an interface shape (if at least 1 interface label exists) and a line between shape and the main RSBox). That means that to get the interface shape associated to the given interface label, we need to search for the next element that isn't a RSLabel nor a RSLine"

	| component labelIndex labelShape index |
	component := canvas shapes at: componentIndex.

	labelShape := component children at: canvasIndex.
	"need to account for the fact that multiple labels are created depending on the number of interfaces on a part of a component's contract"
	labelIndex := 1. "no change detected when starting with 0 so skip this step"

	[ labelShape class = RSLabel or: labelShape class = RSLine ]
		whileTrue: [
			index := canvasIndex + labelIndex.
			labelShape := component children at: index.
			labelIndex := labelIndex + 1 ].

	^ labelShape
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> findComponentThroughLabel: componentClass [
	"returns the RSComposite shape that has a label with the text equals to the component class given"

	canvas shapes do: [ :composite |
		composite class = RSLine ifFalse: [
			composite children do: [ :shape |
				shape class = MolCenterLabel ifTrue: [
					shape text = componentClass name ifTrue: [ ^ composite ] ] ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> findComponentThroughShape: shape [
	"removing a Component means that all Components keep their componentNumber but it doesn't reflect their current position in the canvas"

	| component |
	component := shape componentNumber > canvas shapes size
		     ifTrue: [ canvas shapes last ]
		     ifFalse: [ canvas shapes at: shape componentNumber ].

	[ component class = RSLine ] whileTrue: [
		component := canvas shapes at: shape componentNumber - 1 ].

	^ component
]

{ #category : #initialization }
MolComponentVisualizer >> getLabelsForIteration: componentIndex [
	"used for test purposes, keeps only labels of the interfaces (which are not empty) + name of the component and its Type"

	| componentLabels component |
	component := canvas shapes at: componentIndex.
	componentLabels := OrderedCollection new.

	component children do: [ :child |
		child class = RSLabel ifTrue: [
			child text = '' ifFalse: [ componentLabels add: child ] ] ].

	^ componentLabels
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> hasTwoComponentsOrMore [
	"used to know if the canvas has two or more RSComposite shapes, to create links or not"

	| i |
	i := 0.
	self flag: 'pas utile?'.

	canvas shapes do: [ :shape |
		shape class = RSComposite ifTrue: [ i := i + 1 ] ].

	i >= 2
		ifTrue: [ ^ true ]
		ifFalse: [ ^ false ]
]

{ #category : #initialization }
MolComponentVisualizer >> highlightComponent [
	"hovering over a component (its main RSBox) highlights every interface shape and label it has as well as showing every line that connects it to another component's interface shapes and labels"

	| highlightableLabel canvasCompositeShapes highlightableShape highlightableLine c group lines highlightedShape highlightable |
	highlightableLabel := RSHighlightable new.
	highlightableLabel highlightColor: Color red.

	highlightableShape := RSHighlightable new.
	highlightableShape highlightColor: Color red.
	"property used to highlight the other interface shape that the one hovered on is linked to"
	highlightableShape withConnectedShapes.

	highlightableLine := RSHighlightable new.
	"highlightableLine highlightColor: Color red."
	"property used to highlight the lines that connect the interface shape to another"
	"highlightableLine withEdges."
	highlightableLine withLines.

	canvasCompositeShapes := self removeLinesForIteration.

	"part for real-time visualization (doesn't unhighlight lines after adding/deleting components otherwise)"
	highlightable := RSHighlightable new.
	"highlightable highlightColor: Color red."
	"highlightable unhighlightRecordedShapes: canvas."
	highlightable resetHighlightedShapes: canvas.

	canvasCompositeShapes do: [ :component |
		component children do: [ :child |
			child class = MolBoxComponent ifTrue: [
				"child @ highlightable."
				highlightableLabel highlightShapes: [ :box |
					group := RSGroup new.

					c := self findComponentThroughShape: box.
					c children do: [ :shape | "adds the shapes that need to be highlighted"
						(shape class = RSLine or:
							 (shape class = RSCircle or: shape class = MolCenterLabel))
							ifFalse: [ "adds the lines connecting the components"
								lines := shape connectedLines.

								"only highlights the shapes connected to other components as well as the main box"
								lines isEmpty ifFalse: [
									group add: shape.
									group add: box ].

								"highlights the lines going to other interface shapes"
								group addAll: lines.

								"highlights the shapes and labels from other components connected to the component"
								lines do: [ :line |
									group add: line to.

									"puts the shapes in red by changing their graphic"
									highlightedShape := self highlightedShape: line to.
									(line to isKindOf: MolFormShape) ifTrue: [
										line to form: highlightedShape ] ] ] ].

					group ].

				child @ highlightableLabel ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> highlightShapeShowsLinkAndForm [
	"hovering over an interface shape shows a line that connects it to another component's interface shape. It also highlights the Forms (shapes used for the required part of the interfaces which are not polygons"

	| canvasCompositeShapes lines c list highlightedShape unhighlightedShape |
	canvasCompositeShapes := self removeLinesForIteration.
	list := OrderedCollection new.

	canvasCompositeShapes do: [ :composite |
		composite children do: [ :shape |
			shape class = RSLine ifFalse: [
				shape
					when: RSMouseUp
					do: [ :evt | "putting these lines of code in when RSMouseEnter: make some links stay after hovering on certain interface labels"
						(evt class = RSMouseUpRight or: evt class = RSMouseUpLeft)
							ifFalse: [
								lines := shape connectedLines.
								lines do: [ :line | line strokeColor: Color red ].

								shape class = MolBoxComponent ifTrue: [
									c := self findComponentThroughShape: shape.
									c children do: [ :s | "adds the shapes that need to be highlighted""line to can be used since there's always a line linking a MolFormShape to the main MolBoxComponent (which is the tiny one displayed on screen)"
										(s class = RSLine or:
											 (s class = RSCircle or: s class = MolCenterLabel))
											ifFalse: [ "adds the lines connecting the components"
												lines := s connectedLines.
												"only highlights the shapes connected to other components as well as the main box"
												lines isEmpty ifFalse: [
													list add: s.
													highlightedShape := self highlightedShape: shape.
													shape form: highlightedShape ] ].
										list addAll: lines.

										list do: [ :line | line strokeColor: Color red ].
										"highlights the shapes and labels from other components connected to the component"
										lines do: [ :line | list add: line to ] ] ] ] ].

				shape when: RSMouseEnter do: [ :evt2 |
					lines := shape connectedLines.

					lines do: [ :line | "line to can be used since there's always a line linking a MolFormShape to the main MolBoxComponent (which is the tiny one displayed on screen)"
						(line to class = RSEllipse or:
							 ((line to class = RSLabel or: line to class = RSPolygon) or:
								  line to class = RSBox)) ifFalse: [
							highlightedShape := self highlightedShape: line to.
							line to form: highlightedShape ] ].

					"highlights the form when the cursor is over it"
					(shape isKindOf: MolFormShape) ifTrue: [
						lines isEmpty ifFalse: [
							highlightedShape := self highlightedShape: shape.
							shape form: highlightedShape ] ] ].

				shape when: RSMouseLeave do: [ :evt3 |
					lines := shape connectedLines.

					lines do: [ :line |
						line strokeColor: Color transparent.
						line to class = RSLabel
							ifFalse: [ line to color: Color white ] ].

					"unhighlights the forms whenever the cursor leaves a component (its main RSBox), interface label or an interface shape"
					canvas shapes do: [ :component |
						component class = RSLine ifFalse: [
							component children do: [ :child |
								(child isKindOf: MolFormShape) ifTrue: [
									unhighlightedShape := self unhighlightedShape: child.
									child form: unhighlightedShape ] ] ] ] ] ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> highlightShapes [
	"hovering over an interface shape creates a red line to the associated interface shape of another component if it exists. For example, putting the cursor on the consumedEvents interface shape creates a link to the relevant producedEvents interface shape (of another component obviously)"

	"hovering over an interface shape also creates a red line to its associated interface(s) labels as well as the associated interface(s) labels of another component, useful there's multiple interface labels for one part of a component's contract"

	| highlightableLine highlightableShape canvasCompositeShapes lines highlightedShape group highlightable |
	highlightableLine := RSHighlightable new.
	highlightableLine highlightColor: Color red.
	"property used to highlight the lines that connect the interface shape to another"
	highlightableLine withEdges.
	"highlightableLine withOutgoingLines."
	"highlightable highlightBorder: (RSBorder new
			 width: 30;
			 color: Color black)."
	highlightableShape := RSHighlightable new.
	highlightableShape highlightColor: Color red.
	"property used to highlight the other interface shape that the one hovered on is linked to"
	"highlightableShape resetHighlightedShapes: canvas."
	highlightableShape withConnectedShapes.
	"highlightableShape withOutgoingShapes."

	canvasCompositeShapes := self removeLinesForIteration.

	highlightable := RSHighlightable new.
	"highlightable unhighlightRecordedShapes: canvas."
	highlightable resetHighlightedShapes: canvas.

	self flag: 'unhighlight bug suppression temps réel'.
	"highlightable highlightColor: Color red."

	canvasCompositeShapes do: [ :component |
		component children do: [ :child |
			child class = RSLine ifFalse: [
				child @ highlightable.
				lines := child connectedLines.
				lines isEmpty ifFalse: [ "if the component is connected through another by its hovered on interface shape""highlightable highlightShapes: [ :shape |""highlightable highlightShapes: [ :shape |
						list := OrderedCollection new.
						group := RSGroup new.""lines := shape connectedLines.""highlights the current shape""list add: shape.""as well as the shapes and labels from other components connected to the component""lines do: [ :line |
							highlightedShape := self highlightedShape: line to.
							(line to isKindOf: MolFormShape) ifTrue: [
								line to form: highlightedShape ].
							list add: line to ].

						group addAll: list.
						group ].

					child @ highlightable ""group := RSGroup new.""highlights the hovered on interface shape""group add: child.""highlights the lines going to other interface shapes""group addAll: lines.""highlights the shapes and labels from other components connected to the component""lines do: [ :line |
							group add: line to.""puts the shapes in red by changing the graphic""highlightedShape := self highlightedShape: line to.
							(line to isKindOf: MolFormShape) ifTrue: [
								line to form: highlightedShape ] ].""group"
					child @ highlightableLine.
					child @ highlightableShape ] ] ] ]
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> highlightedShape: shape [
	"returns the highlighted form of a given shape"

	shape class = MolConsumedEventShape ifTrue: [
		^ MolShapeIcon redConsumedEventIcon ].
	shape class = MolUsedParameterShape ifTrue: [
		^ MolShapeIcon redUsedParameterIcon ].
	shape class = MolUsedServiceShape ifTrue: [
		^ MolShapeIcon redUsedServiceIcon ]
]

{ #category : #initialization }
MolComponentVisualizer >> initialize [
	"gets the running Components as a dictionary and then builds the components"

	"values used to position the components so that they don't overlap"

	xValue := -400.
	yValue := -200.

	"used so that every component main box knows which is the index of the RSComposite shape it pertains to in the canvas"
	numberedComponent := 0.

	super initialize.
	canvas := RSCanvas new.
	"The canvas can be zoomed in / out using I and O keys and can also be navigated using scrollbars"
	canvas @ RSCanvasController.
	runningComponents := MolComponentManager default homeServices
		                     deployedComponents.

	self buildComponents.

	self createLinksAndHighlights.

	self realTimeVisualization.
	
	activatedAnnouncer := SystemAnnouncer uniqueInstance subscriptions
		                      subscriptionsHandling:
		                      MolComponentActivated asAnnouncement.
	removedAnnouncer := SystemAnnouncer uniqueInstance subscriptions
		                    subscriptionsHandling:
		                    MolComponentRemoved asAnnouncement
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> moveAndAddComponent: canvasShape [
	"moves a RSComposite shape and adds it to the canvas"

	canvasShape translateTo: xValue @ yValue.
	canvasShape @ RSDraggable.
	canvas add: canvasShape.
				canvas zoomToFit.

	xValue := xValue + 600.
	yValue := yValue + 200
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> realTimeVisualization [
	"when a component is started, adds it to the visualization"

	"when it's removed, removes it from the visualization"

	"functions through announcers"

	| canvasShape componentClass |
	"adds the components (with the name of their instance if they have one)"
	SystemAnnouncer uniqueInstance
		when: MolComponentActivated
		do: [ :announcement |
			componentClass := announcement component class.

			canvasShape := (self buildComponent: componentClass) canvas asShape.

			self moveAndAddComponent: canvasShape.

			self deleteAndRecreateLinksIfTwoComponentsOrMore ].

	"removes the components"
	SystemAnnouncer uniqueInstance
		when: MolComponentRemoved
		do: [ :announcement |
			componentClass := announcement component class.

			canvasShape := self findComponentThroughLabel: componentClass.
			"index := canvas shapes indexOf: canvasShape."
			canvas removeShape: canvasShape.

			self deleteAndRecreateLinksIfTwoComponentsOrMore ]
]

{ #category : #initialization }
MolComponentVisualizer >> release [
	"need to remove the instantiated Announcers since they are kept in SystemAnnouncer otherwise"

	activatedAnnouncer do: [ :e | "e subscriber class = MolComponentVisualizer ifTrue: ["
		SystemAnnouncer uniqueInstance subscriptions remove: e "]" ].

	removedAnnouncer do: [ :e | "e subscriber class = MolComponentVisualizer ifTrue: ["
		SystemAnnouncer uniqueInstance subscriptions remove: e "]" ]
]

{ #category : #initialization }
MolComponentVisualizer >> removeDuplicateLines: lineArray [
	"removes duplicate lines (lines with same start and end)"

	| lineArrayCopy lineArrayFinal |
	"copies the memory reference (and not the values) without the copy message"
	lineArrayCopy := lineArray copy.
	lineArrayFinal := lineArray copy.

	lineArray do: [ :l |
		lineArrayCopy do: [ :l2 |
			(l isNil or: l2 isNil) ifFalse: [
				l = l2 ifFalse: [
					(l from = l2 from and:
						 (l to = l2 to and: (lineArrayFinal includes: l2))) ifTrue: [
						lineArrayFinal remove: l2 ] ] ] ] ].

	lineArrayFinal do: [ :l |
		canvas add: l ]
]

{ #category : #initialization }
MolComponentVisualizer >> removeLinesForIteration [
	"need to filter the lines added from createLinksBetweenInterfaces since only the interface shapes are used while iterating (which come from the RSComposite shapes)"

	| canvasCompositeShapes |
	canvasCompositeShapes := OrderedCollection new.

	canvas shapes do: [ :shape |
		shape class = RSComposite ifTrue: [
			canvasCompositeShapes add: shape ] ].

	^ canvasCompositeShapes
]

{ #category : #initialization }
MolComponentVisualizer >> removeShapesForIteration [
	"used for test purposes, keeps only lines linking the components if they exist"

	| canvasLines |
	canvasLines := OrderedCollection new.

	canvas shapes do: [ :shape |
		shape class = RSComposite ifFalse: [
			canvasLines add: shape ] ].

	^ canvasLines
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> unhighlightedShape: shape [
	"returns the unhighlighted form of a given shape"

	shape class = MolConsumedEventShape ifTrue: [
		^ MolShapeIcon consumedEventIcon ].
	shape class = MolUsedParameterShape ifTrue: [
		^ MolShapeIcon usedParameterIcon ].
	shape class = MolUsedServiceShape ifTrue: [
		^ MolShapeIcon usedServiceIcon ]
]

{ #category : #'as yet unclassified' }
MolComponentVisualizer >> window: aWindow [
	"after the window (which contains the canvas) is open, saves it in order to delete the announcers at the moment of it's closure"

	window := aWindow.
	window announcer when: WindowClosed do: [ self release ]
]
