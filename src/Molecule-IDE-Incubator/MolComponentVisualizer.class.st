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
		component children do: [ :child |
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
MolComponentVisualizer >> initialize [
	"gets the running Components as a dictionary and then builds the components"

	super initialize.
	canvas := RSCanvas new.
	"The canvas can be zoomed in / out using I and O keys and can also be navigated using scrollbars"
	canvas @ RSCanvasController.
	runningComponents := MolComponentManager default homeServices
		                     deployedComponents.

	self buildComponents.
	self createLinksBetweenInterfaces
]
