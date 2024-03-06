Class {
	#name : #MolComponentVisualizer,
	#superclass : #Object,
	#instVars : [
		'runningComponents',
		'canvas'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
MolComponentVisualizer >> buildComponent: aComponent [
	"builds a component visualization, similar to how the build method of ClyComponentBuilder works but for multiple components to be shown on the same canvas"

	| componentBuilder |
	componentBuilder := MolComponentBuilder new.
	componentBuilder implementation: aComponent.

	"showComponent returns a RSCanvas, adds every part of a component to the canvas"
	^ componentBuilder showComponent
]

{ #category : #initialization }
MolComponentVisualizer >> buildComponents [
	"builds every component visualization, the x value being used to position the components"

	| xValue yValue canvasShape |
	self flag:
		'faire en sort que composant relié à autre soit placé à gauche?'.
	xValue := -400.
	yValue := -200.

	runningComponents keysDo: [ :component | "each component is its own shape of type RSComposite"
		canvasShape := (self buildComponent: component) canvas asShape.

		"having RSComposite shapes makes it possible to move every element of a component at the same time"
		canvasShape translateTo: xValue @ yValue.
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
MolComponentVisualizer >> createLinksBetweenInterfaces [
	"if an interface declared in the offered contract part of component A is also used in the required part of component B of the same type (Event, Parameter or Service), creates a link between the shapes symbolizing the interfaces"

	| line offeredShape requiredShape lineArray canvasCopy canvasIndex canvasCopyIndex lineCounter componentIndex componentCopyIndex |
	
	lineArray := OrderedCollection new.
	canvasCopy := canvas.
	"component indexes are used to know which component is being selected"
	componentIndex := 0.
	componentCopyIndex := 0.

	"canvas indexes are used to know the position of labels in components shape list"
	canvasIndex := 0.
	canvasCopyIndex := 0.

	lineCounter := 0.

	"iterates on two components at the same time in order to not make compararison between elements of a same component (incoherent with Molecule architecture)"
	canvas shapes do: [ :component | "adds the line after in order to not update the canvas while it's being iterated on"
		componentIndex := canvasIndex + 1.
		component children do: [ :child | "(child class inheritsFrom: RSShape) ifTrue: [ self halt.
				child @ RSHighlightable ]."
			canvasCopy shapes do: [ :component2 |
				componentCopyIndex := componentCopyIndex + 1.
				component2 children do: [ :child2 |
					(child class = RSLabel and: child2 class = RSLabel) ifTrue: [ "verify that Roassal elements of type RSLabel aren't the same element"
						child == child2 ifFalse: [ "but have the same text"
							child text = child2 text ifTrue: [ "that isn't an empty string"
								child text = '' ifFalse: [ "should only create one line, two are not needed to symbolize the link"
									lineCounter % 2 = 0 ifTrue: [
										requiredShape := self
											                 determineComponentShape: componentIndex
											                 canvasIndex: canvasIndex.
										offeredShape := self
											                determineComponentShape: componentCopyIndex
											                canvasIndex: canvasCopyIndex.

										line := RSLine new
											        from: offeredShape;
											        to: requiredShape;
											        yourself.
										line attachPoint: RSBorderAttachPoint new.
										"hides the line so that it can be shown when hovering on an interface shape"
										line strokeColor: Color white.
										line update.
										lineArray add: line.

										lineCounter := lineCounter + 1 ] ] ] ] ].
					canvasCopyIndex := canvasCopyIndex + 1 ].
				canvasCopyIndex := 0 ].
			componentCopyIndex := 0.
			canvasIndex := canvasIndex + 1 ].
		canvasIndex := 0 ].

	lineArray do: [ :l | canvas add: l ]
]

{ #category : #initialization }
MolComponentVisualizer >> determineComponentShape: componentIndex canvasIndex: canvasIndex [
	"used to determine which shape of which component is the starting and end point of a line"

	| shape component |
	"the shape is added after the label for each part of a component's contract in ComponentBuilder"
	component := canvas shapes at: componentIndex.
	"the corresponding RSShape is placed two items after the RSLabel"
	shape := component children at: canvasIndex + 2.

	^ shape
]

{ #category : #initialization }
MolComponentVisualizer >> highlightShapes [
	"hovering over an interface shape creates a red link to the associated interface of another component if it exists. For example, putting the cursor on a consumedEvents interface creates a link to a producedEvents interface if it exists"

	| shapeExtent componentIndex nextElement secondNextElement highlightableLine highlightableShape |
	self flag: 'fonctionne pas pour partie used sauf usedservice qui bug'.
	self flag: 'voir page 163/4 agile visualization'.
	shapeExtent := 30 @ 30.
	componentIndex := 0.

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

	canvas shapes do: [ :component |
		component children do: [ :child | "provided shape part"
			componentIndex := componentIndex + 1.
			componentIndex < (component children size - 2) ifTrue: [
				nextElement := component children at: componentIndex + 1.
				secondNextElement := component children at: componentIndex + 2 ].
			(child extent = shapeExtent or:
				 (nextElement class = RSLine and: secondNextElement class = RSLine))
				ifTrue: [ "don't highlight the Type dot since it isn't linked to anything"
					child class = RSCircle ifFalse: [ "usedParameter shape is made of 3 lines"
						"child connectedLines size = 0 ifFalse: [" "if the component is connected through another by its hovered on interface shape"
							child @ highlightableLine.
							child @ highlightableShape ] ] ] ] "]"
]

{ #category : #initialization }
MolComponentVisualizer >> highlightShowsLink [
	"hovering over an interface shape shows a line that connects it to another component's interface shape"

	| canvasCompositeShapes lines |
	canvasCompositeShapes := OrderedCollection new.

	"need to filter the lines added from createLinksBetweenInterfaces since only the interface shapes are used here"
	canvas shapes do: [ :shape |
		shape class = RSComposite ifTrue: [
			canvasCompositeShapes add: shape ] ].

	canvasCompositeShapes do: [ :composite |
		composite children do: [ :shape |
			shape when: RSMouseUp do: [ :evt |
				lines := evt shapes connectedLines.
				lines isEmpty ifFalse: [
					lines do: [ :line | line strokeColor: Color red ] ] ] ] ]
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
	
	self highlightShapes.
	self createLinksBetweenInterfaces.
	self highlightShowsLink
]
