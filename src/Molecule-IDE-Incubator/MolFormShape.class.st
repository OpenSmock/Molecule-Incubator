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
MolFormShape >> canvasIndex [

	^ canvasIndex
]

{ #category : #accessing }
MolFormShape >> canvasIndex: index [

	canvasIndex := index
]

{ #category : #accessing }
MolFormShape >> componentNumber [

	^ componentNumber
]

{ #category : #accessing }
MolFormShape >> componentNumber: numberedComponent [

	componentNumber := numberedComponent
]
