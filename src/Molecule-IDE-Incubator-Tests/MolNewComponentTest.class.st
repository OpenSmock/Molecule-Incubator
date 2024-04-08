Class {
	#name : #MolNewComponentTest,
	#superclass : #TestCase,
	#instVars : [
		'newComponent'
	],
	#category : #'Molecule-IDE-Incubator-Tests-ComponentIDE'
}

{ #category : #running }
MolNewComponentTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	newComponent := MolNewComponentLibraryPresenter new
]

{ #category : #running }
MolNewComponentTest >> testBrowseButtonActivated [

	| enabled |
	newComponent packageList selectItem: 'BaselineOfAIGraphAlgorithms' asPackage.
	enabled := newComponent buttonBrowse isEnabled.
	self assert: [ enabled ]
]

{ #category : #running }
MolNewComponentTest >> testFilterPackageList [
	"10 items in packageList when filtered but only 8 are counted since classes without a supplementary hyphen are not counted"

	"for example, AST-Core-Tests is counted which is not the case for AST-Core"

	| size |
	newComponent packageList filterListItems: 'AST'.
	size := newComponent packageList items size.
	self assert: [ size = 8 ]
]

{ #category : #running }
MolNewComponentTest >> testFilterTagList [

	| size |
	newComponent packageList selectItem: 'STON-Core' asPackage.
	newComponent tagList filterListItems: 'r'.
	size := newComponent tagList items size.
	self assert: [ size = 2 ]
]

{ #category : #running }
MolNewComponentTest >> testSelectedItem [

	| selectedItem package |
	package := 'BaselineOfAIGraphAlgorithms' asPackage.
	newComponent packageList selectItem: package.
	selectedItem := newComponent packageList selectedItem.
	self assert: [
		selectedItem = package ]
]
