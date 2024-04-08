"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I display the implementations of a Molecule Type. I'm accessed by right-clicking a Molecule Type -> See Component Implementations.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	componentBuilder:		<Object>
	componentBuilderPresenter:		<Object>
	selectedType:		<Object>


    Implementation Points
"
Class {
	#name : #MolImplementationsPresenter,
	#superclass : #MolOptionsPresenter,
	#instVars : [
		'selectedType',
		'componentBuilder',
		'componentBuilderPresenter'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
MolImplementationsPresenter >> buttonBrowseAction [
	"an implementation needs to be selected in order to browse it"

	| item |
	item := implementationList selectedItem.

	item ifNotNil: [
		buttonBrowse enable.
		item browse ]
]

{ #category : #initialization }
MolImplementationsPresenter >> connectPresenters [
	"enables the Browse button if an implementation is selected, also shows a diagram of the selected component"

	| shape |
	implementationList whenSelectionChangedDo: [
		implementationList selectedItem ifNotNil: [
			buttonBrowse enable.

			componentBuilder := MolComponentBuilder new.
			componentBuilder implementation: implementationList selectedItem.
			"adds the component visualization and zooms on it"
			componentBuilderPresenter script: [ :view |
				shape := (componentBuilder showComponent: nil) asShape.

				view addShape: shape.
				view zoomToFit ].
			
				componentBuilderPresenter canvas @ RSCanvasController.

			"used to zoom on the component visualization when the window is resized"
			componentBuilderPresenter canvas
				when: RSExtentChangedEvent
				do: [ :evt | componentBuilderPresenter canvas zoomToFit ] ] ]
]

{ #category : #initialization }
MolImplementationsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: implementationList height: implementationList items size * 20;
		  add: componentBuilderPresenter;
		  addLast: actionBar;
		  yourself
]

{ #category : #initialization }
MolImplementationsPresenter >> initializePresenters [

	super initializePresenters.

	implementationList := MolSpFilteringListDoubleClickPresenter new.
	implementationList displayIcon: [ :elem |
		self iconNamed: elem systemIconName ].

	componentBuilderPresenter := SpRoassalPresenter new.
]

{ #category : #initialization }
MolImplementationsPresenter >> title [

	^ selectedType asString , ' Implementations'
]

{ #category : #initialization }
MolImplementationsPresenter >> type: aType [
	"when the Type Trait is given, loads the list"

	"only one Type can be selected in the System Browser at a time"

	selectedType := aType.
	implementationList items: (self listImplementations: selectedType)
]
