Class {
	#name : #MolNewComponentTest,
	#superclass : #TestCase,
	#instVars : [
		'geoPosImplementations',
		'newComponent'
	],
	#category : #'Molecule-IDE-Incubator-Tests-ComponentIDE'
}

{ #category : #running }
MolNewComponentTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	newComponent := MolNewComponentLibrary new
]

{ #category : #running }
MolNewComponentTest >> testFilter [

	self flag: 'fails'.
	newComponent packageList selectItem: BaselineOfAIGraphAlgorithms.
	self assert: [ newComponent tagList size = 1 ]
]

{ #category : #running }
MolNewComponentTest >> testPackageSelected [

	self flag: 'fails'.
	newComponent packageList selectItem: BaselineOfAIGraphAlgorithms.
	self assert: [ newComponent buttonBrowse state ]
]

{ #category : #running }
MolNewComponentTest >> testTagList [

	self flag: 'fails'.
	newComponent packageList selectItem: BaselineOfAIGraphAlgorithms.
	self assert: [ newComponent tagList size = 1 ]
]
