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
		'runningComponents'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
MolComponentVisualizer >> addLineFrom: interfaceLabelOrShape to: otherInterfaceLabelOrShape [
	"used to link an interface label/shape to another interface label/shape (while being invisible by the color of the link being white), used to highlight the corresponding labels when an interface shape is hovered on"

	| line |
	line := RSLine new
		        from: interfaceLabelOrShape;
		        to: otherInterfaceLabelOrShape;
		        color: Color white;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	^ line
]

{ #category : #initialization }
MolComponentVisualizer >> buildComponent: aComponent numberedComponent: numberedComponent [
	"builds a component visualization, similar to how the build method of ClyComponentBuilder works but for multiple components to be shown on the same canvas. numberedComponents is used to stock the number of the component (its index in the canvas) in its main box"

	| componentBuilder |
	componentBuilder := MolComponentBuilder new.
	componentBuilder implementation: aComponent.

	"showComponent returns a RSCanvas, adds every part of a component to the canvas"
	^ componentBuilder showComponent: numberedComponent
]

{ #category : #initialization }
MolComponentVisualizer >> buildComponents [
	"builds every component visualization, the x value being used to position the components"

	| xValue yValue canvasShape numberedComponent |
	self flag:
		'faire en sort que composant relié à autre soit placé à gauche?'.
	xValue := -400.
	yValue := -200.
	numberedComponent := 0.

	runningComponents keysDo: [ :component | "each component is its own shape of type RSComposite"
		numberedComponent := numberedComponent + 1.
		canvasShape := (self
			                buildComponent: component
			                numberedComponent: numberedComponent) canvas
			               asShape.

		"having RSComposite shapes makes it possible to move every element of a component at the same time"
		canvasShape translateTo: xValue @ yValue.
		canvasShape @ RSDraggable.
		canvas add: canvasShape.

		xValue := xValue + 600.
		yValue := yValue + 200 ]
]

{ #category : #initialization }
MolComponentVisualizer >> canvas [
	"returns the canvas so that it can be opened in MolWorld"

	^ canvas
]

{ #category : #initialization }
MolComponentVisualizer >> clickingComponentShowsInspector [
	"clicking on a component shows its detail in the Pharo Inspector"

	| canvasCompositeShapes lines |
	self flag:
		'would be better to navigate through deployedComponents instead of opening inspect on the selected component, don t know how the inspector is coded though'.
	canvasCompositeShapes := self removeLinesForIteration.
	lines := OrderedCollection new.

	canvasCompositeShapes do: [ :composite |
		composite children do: [ :shape | "(shape class = RSBox and: shape extent = (200 @ 200)) ifTrue:""("
			shape when: RSMouseDoubleClick do: [ :evt |
"2nd shape of a RSComposite is always a RSlabel with the name of the component"
						(MolComponentManager default homeServices deployedComponents
							 at: (composite children at: 2) text asClass) inspect ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> createInvisibleLinksBetweenInterfaces [
	"if an interface declared in the offered contract part of component A is also used in the required part of component B of the same type (Event, Parameter or Service), creates a link between the shapes and the interface labels"

	| lineArray canvasCopy componentIndex componentCopyIndex canvasIndex requiredShape canvasCopyIndex offeredShape |
	lineArray := OrderedCollection new.
	"voir https://discord.com/channels/223421264751099906/305208145020715019/954505784467816508"
	"lineArray := IdentitySet new."
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

{ #category : #initialization }
MolComponentVisualizer >> highlightComponent [
	"hovering over a component (its main RSBox) highlights every interface shape and label it has as well as showing every line that connects it to another component's interface shapes and labels"

	| highlightableLabel canvasCompositeShapes highlightableShape highlightableLine c list group lines |
	highlightableLabel := RSHighlightable new.
	highlightableLabel highlightColor: Color red.

	highlightableShape := RSHighlightable new.
	highlightableShape highlightColor: Color red.
	"property used to highlight the other interface shape that the one hovered on is linked to"
	highlightableShape withConnectedShapes.

	highlightableLine := RSHighlightable new.
	highlightableLine highlightColor: Color red.
	"property used to highlight the lines that connect the interface shape to another"
	"highlightableLine withEdges."
	highlightableLine withLines.

	canvasCompositeShapes := self removeLinesForIteration.
	canvasCompositeShapes do: [ :component |
		component children do: [ :child | "component children do: [ :child |
			child class = RSLine ifFalse: [""and:
				 (nextElement class = RSLine or: secondNextElement class = RSLine))""child connectedLines isEmpty ifFalse: [""if the component is connected through another by its hovered on interface shape""child @ highlightableLabel""] ] ]"
			(child class = MolBoxComponent and: child extent = (200 @ 200))
				ifTrue: [
					highlightableLabel highlightShapes: [ :box |
						list := OrderedCollection new.
						group := RSGroup new.

						c := canvas shapes at: box componentNumber.
						c children do: [ :shape | "adds the shapes that need to be highlighted"
							(shape class = RSLine or:
								 (shape class = RSCircle or: shape class = MolCenterLabel))
								ifFalse: [ "adds the lines connecting the components"
									lines := shape connectedLines.
									"only highlights the shapes connected to other components as well as the main box"
									lines isEmpty ifFalse: [ list add: shape. list add: box ].
									list addAll: lines.
									"highlights the shapes and labels from other components connected to the component"
									lines do: [ :line | list add: line to ] ] ].

						group addAll: list.
						group ].

					child @ highlightableLabel ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> highlightShapeShowsLink [
	"hovering over an interface shape shows a line that connects it to another component's interface shape"

	| canvasCompositeShapes lines |
	canvasCompositeShapes := self removeLinesForIteration.

	canvasCompositeShapes do: [ :composite |
		composite children do: [ :shape |
			shape
				when: RSMouseUp
				do: [ :evt |
					(evt class = RSMouseUpRight or: evt class = RSMouseUpLeft)
						ifFalse: [
							lines := evt shapes connectedLines.
							lines do: [ :line | line strokeColor: Color red ] ] ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> highlightShapes [
	"hovering over an interface shape creates a red line to the associated interface shape of another component if it exists. For example, putting the cursor on the consumedEvents interface shape creates a link to the relevant producedEvents interface shape (of another component obviously)"

	"hovering over an interface shape also creates a red line to its associated interface(s) labels as well as the associated interface(s) labels of another component, useful there's multiple interface labels for one part of a component's contract"

	| canvasIndex nextElement secondNextElement highlightableLine highlightableShape canvasCompositeShapes |
	"canvasIndex := 0."
	highlightableLine := RSHighlightable new.
	highlightableLine highlightColor: Color red.
	"property used to highlight the lines that connect the interface shape to another"
	highlightableLine withEdges.
	"highlightable highlightBorder: (RSBorder new
			 width: 30;
			 color: Color black)."
	highlightableShape := RSHighlightable new.
	highlightableShape highlightColor: Color red.
	"property used to highlight the other interface shape that the one hovered on is linked to"
	highlightableShape withConnectedShapes.

	canvasCompositeShapes := self removeLinesForIteration.

	canvasCompositeShapes do: [ :component |
		component children do: [ :child | "canvasIndex := canvasIndex + 1.""componentIndex < (component children size - 2) ifTrue: [
				nextElement := component children at: componentIndex + 1.
				secondNextElement := component children at: componentIndex + 2 ].""usedParameter shape is made of 3 lines""("
			child class = RSLine ifFalse: [ "and:
				 (nextElement class = RSLine or: secondNextElement class = RSLine))"
				child connectedLines isEmpty ifFalse: [ "if the component is connected through another by its hovered on interface shape"
					child @ highlightableLine.
					child @ highlightableShape ] ] ] ]
]

{ #category : #initialization }
MolComponentVisualizer >> initialize [
	"gets the running Components as a dictionary and then builds the components"

	super initialize.
	canvas := RSCanvas new.
	"The canvas can be zoomed in / out using I and O keys and can also be navigated using scrollbars"
	canvas @ RSCanvasController.
	runningComponents := MolComponentManager default homeServices
		                     deployedComponents.

	self buildComponents.

	self createLinksBetweenInterfaces.
	self createInvisibleLinksBetweenInterfaces.
	"links need to be created first in order to know what to highlight next"
	self highlightShapes.

	self highlightShapeShowsLink.
	self highlightComponent.

	self clickingComponentShowsInspector
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
