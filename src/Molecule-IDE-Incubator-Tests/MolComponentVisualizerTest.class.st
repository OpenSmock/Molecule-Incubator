Class {
	#name : #MolComponentVisualizerTest,
	#superclass : #TestCase,
	#instVars : [
		'newComponent',
		'componentVisualizer',
		'canvas',
		'numberOfComponents'
	],
	#category : #'Molecule-IDE-Incubator-Tests-ComponentIDE'
}

{ #category : #running }
MolComponentVisualizerTest >> setUp [
	"launch the tests without having any component launched, will trigger an error otherwise"

	super setUp.

	"Put here a common initialization logic for tests"
	numberOfComponents := 0.

	componentVisualizer := MolComponentVisualizer new.
	canvas := componentVisualizer canvas.

	self startComponent: MolMyClockComponentImpl.
	self startComponent: MolMyAlarmComponentImpl.
	self startComponent: MolMyUserFacadeComponentImpl
]

{ #category : #running }
MolComponentVisualizerTest >> startComponent: component [
	"starts a component and increments a counter"
	component start.
	numberOfComponents := numberOfComponents + 1.

]

{ #category : #running }
MolComponentVisualizerTest >> tearDown [

	numberOfComponents := 0.

	MolMyClockComponentImpl stop.
	MolMyAlarmComponentImpl stop.
	MolMyUserFacadeComponentImpl stop
]

{ #category : #running }
MolComponentVisualizerTest >> testLineNumber [
	"tests that only one connection exist between the three started components"

	| numberOfLines |
	numberOfLines := componentVisualizer removeShapesForIteration size.

	self assert: numberOfLines equals: 1
]

{ #category : #running }
MolComponentVisualizerTest >> testNumberOfLabels [
	"tests that the right number of labels (name + type + interfaces) exist for a given component"

	| userFacadeLabels userFacadeLabelSize |
	userFacadeLabels := componentVisualizer getLabelsForIteration: 2.
	userFacadeLabelSize := userFacadeLabels size.

	self assert: userFacadeLabelSize equals: 8
]

{ #category : #running }
MolComponentVisualizerTest >> testShapeNumber [
	"tests that the number of RSComposite shapes (representing the components) are equal to the number of started components"

	| numberOfShapes |
	numberOfShapes := componentVisualizer removeLinesForIteration size.
	
	self assert: numberOfShapes equals: numberOfComponents
]
