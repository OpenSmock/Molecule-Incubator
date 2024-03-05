Class {
	#name : #MolImplementations,
	#superclass : #MolOptions,
	#instVars : [
		'selectedType',
		'componentBuilder',
		'canvas',
		'componentBuilderPresenter'
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

	self flag: 'componentBuilder'.

	implementationList whenSelectionChangedDo: [
		implementationList selectedItem ifNotNil: [
			buttonBrowse enable.

			canvas := RSCanvas new.
			"canvas := componentBuilderPresenter canvas."
			canvas @ RSCanvasController.
			componentBuilder := MolComponentBuilder new.
			componentBuilder implementation: implementationList selectedItem.
			componentBuilder canvas: canvas.
			componentBuilderPresenter canvas: componentBuilder showComponent.
			componentBuilderPresenter refresh ] ]
]

{ #category : #initialization }
MolImplementations >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: implementationList;
		  add: componentBuilderPresenter;
		  addLast: actionBar;
		  yourself
]

{ #category : #initialization }
MolImplementations >> initializePresenters [

	super initializePresenters.

	implementationList := SpFilteringListDoubleClickPresenter new.
	implementationList displayIcon: [ :elem |
		self iconNamed: elem systemIconName ].

	componentBuilderPresenter := SpRoassalPresenter new
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
