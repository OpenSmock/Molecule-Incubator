Class {
	#name : #MolFormShape,
	#superclass : #RSBitmap,
	#instVars : [
		'componentNumber',
		'canvasIndex'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #accessing }
MolFormShape >> componentNumber [

	^ componentNumber
]

{ #category : #accessing }
MolFormShape >> componentNumber: numberedComponent [

	componentNumber := numberedComponent
]
