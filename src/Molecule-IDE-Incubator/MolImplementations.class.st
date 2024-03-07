Class {
	#name : #MolImplementations,
	#superclass : #MolOptions,
	#instVars : [
		'selectedType',
		'componentBuilder',
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

	| rs c shape |
	implementationList whenSelectionChangedDo: [
		implementationList selectedItem ifNotNil: [
			buttonBrowse enable.

			componentBuilder := MolComponentBuilder new.
			componentBuilder implementation: implementationList selectedItem.
			"adds the component visualization and zooms on it"
			componentBuilderPresenter script: [ :view |
				shape := componentBuilder showComponent asShape.
				"if the Roassal header and its buttons ever come back in See Component Implementations put this"
				"rs := RSCanvas new.
				rs addShape: shape.
				shape container: rs.
				rs zoomToFit."
				"logic is rs := RSCanvas new.
				rs addShape: componentBuilder asShape.
				componentBuilder container: rs.
				rs zoomToFit."
				view addShape: shape.
				view zoomToFit ].

			"used to zoom on the component visualization when the window is resized"
			componentBuilderPresenter canvas
				when: RSExtentChangedEvent
				do: [ :evt | componentBuilderPresenter canvas zoomToFit ] ] ]
]

{ #category : #initialization }
MolImplementations >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: implementationList height: implementationList items size * 20;
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
