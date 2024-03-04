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
MolComponentVisualizer >> buildComponents [
	"builds every component visualization, the x value being used to position the components"

	| xValue |
	self flag: 'faire liens entre composants'.
	xValue := -400.

	runningComponents keysDo: [ :component |
		self buildComponent: component xValue: xValue.
		xValue := xValue + 600 ]
]

{ #category : #initialization }
MolComponentVisualizer >> canvas [
	"returns the canvas so that it can be opened in MolWorld"

	^ canvas
]

{ #category : #initialization }
MolComponentVisualizer >> initialize [
	"gets the running Components as a dictionary and then builds the components"

	super initialize.
	canvas := RSCanvas new.
	runningComponents := MolComponentManager default homeServices
		                     deployedComponents.

	self buildComponents
]
