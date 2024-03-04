Class {
	#name : #MolImplementations,
	#superclass : #MolOptions,
	#instVars : [
		'selectedType',
		'componentBuilder',
		'canvas'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
MolImplementations >> buttonBrowseAction [
	"an implementation needs to be selected in order to browse it"

	| item |
	item := implementationList selectedItem.

	item ifNotNil: [
		buttonBrowse enable.
		item browse ]
]

{ #category : #initialization }
MolImplementations >> connectPresenters [
	"enables the Browse button if an implementation is selected, also shows a diagram of the selected component"

	implementationList whenSelectionChangedDo: [
		implementationList selectedItem ifNotNil: [ buttonBrowse enable.
			
			canvas := RSCanvas new.

		componentBuilder := ComponentBuilder new.
		componentBuilder implementation: implementationList selectedItem.
		componentBuilder canvas: canvas.
		componentBuilder showComponent open ] ]
]

{ #category : #initialization }
MolImplementations >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: implementationList;
		  addLast: actionBar;
		  yourself
]

{ #category : #initialization }
MolImplementations >> initializePresenters [

	super initializePresenters.

	implementationList := SpFilteringListDoubleClickPresenter new.
	implementationList displayIcon: [ :elem |
		self iconNamed: elem systemIconName ]
]

{ #category : #initialization }
MolImplementations >> title [

	^ selectedType asString , ' Implementations'
]

{ #category : #initialization }
MolImplementations >> type: aType [
	"when the Type Trait is given, loads the list"

	"only one Type can be selected in the System Browser at a time"

	selectedType := aType.
	implementationList items: (self listImplementations: selectedType)
]
