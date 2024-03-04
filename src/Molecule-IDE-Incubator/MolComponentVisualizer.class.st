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
MolComponentVisualizer >> buildComponent: aComponent xValue: xValue [
	"builds a component visualization, similar to how the build method of ClyComponentBuilder works but for multiple components to be shown on the same canvas"

	| componentBuilder |
	componentBuilder := ComponentBuilder new.
	componentBuilder implementation: aComponent.
	componentBuilder canvas: canvas.
	componentBuilder xValue: xValue.

	"showComponent returns a RSCanvas, adds every part of a component to the canvas"
	componentBuilder showComponent
]

{ #category : #initialization }
MolComponentVisualizer >> buildComponent: aComponent xValue: xValue yValue: yValue [
	"builds a component visualization, similar to how the build method of ClyComponentBuilder works but for multiple components to be shown on the same canvas"

	| componentBuilder |
	componentBuilder := ComponentBuilder new.
	componentBuilder implementation: aComponent.
	componentBuilder canvas: canvas.
	componentBuilder xValue: xValue.
	componentBuilder yValue: yValue.

	"showComponent returns a RSCanvas, adds every part of a component to the canvas"
	componentBuilder showComponent
]

{ #category : #initialization }
MolComponentVisualizer >> buildComponents [
	"builds every component visualization, the x value being used to position the components"

	| xValue yValue |
	self flag: 'faire liens entre composants'.
	xValue := -400. 
	yValue := -200.

	runningComponents keysDo: [ :component |
		self buildComponent: component xValue: xValue yValue: yValue.
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

	| line offeredShape requiredShape lineArray canvasCopy canvasIndex canvasCopyIndex lineCounter |
	lineArray := OrderedCollection new.
	canvasCopy := canvas.
	"indexes are used to know the position of labels which is used to know the position of their associated shapes"
	canvasIndex := 0.
	canvasCopyIndex := 0.

	lineCounter := 0.

	canvas shapes do: [ :element |
		canvasCopy shapes do: [ :element2 |
			(element class = RSLabel and: element2 class = RSLabel) ifTrue: [ "verify that Roassal elements of type RSLabel aren't the same element"
				element == element2 ifFalse: [ "but have the same text"
					element text = element2 text ifTrue: [ "that isn't an empty string"
						element text = '' ifFalse: [ "should only create one line, two are not needed to symbolize the link"
							lineCounter % 2 = 0 ifTrue: [
								requiredShape := self determineComponentShape: canvasIndex.
								offeredShape := self determineComponentShape: canvasCopyIndex.

								self flag: ''.
								line := RSLine new
									        from: offeredShape;
									        to: requiredShape;
									        yourself.
								line attachPoint: RSBorderAttachPoint new.
								line update.
								lineArray add: line.
								
								lineCounter := lineCounter + 1 ] ] ] ] ].
			canvasCopyIndex := canvasCopyIndex + 1 ].
		canvasCopyIndex := 0.
		canvasIndex := canvasIndex + 1 ].

	"adds the line after in order to not update the canvas while it's being iterated on"
	lineArray do: [ :l | canvas add: l ]
]

{ #category : #initialization }
MolComponentVisualizer >> determineComponentShape: canvasIndex [
	"used to determine which shape of which component is the starting and end point of a line"

	| shape |
	"the shape is added after the label for each part of a component's contract in ComponentBuilder"
	shape := canvas shapes at: canvasIndex + 1.

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
