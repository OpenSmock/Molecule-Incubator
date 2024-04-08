"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I permit the creation of a new Molecule Component, by choosing its location through its package and its (optional) tag. I'm accessed through the Library tab -> Molecule -> Debug and Tools -> New Component.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	buttonOK:		<Object>
	package:		<Object>
	packageList:		<Object>
	selectedList:		<Object>
	tag:		<Object>
	tagList:		<Object>


    Implementation Points
"
Class {
	#name : #MolNewComponentLibraryPresenter,
	#superclass : #MolOptionsPresenter,
	#instVars : [
		'packageList',
		'tagList',
		'buttonOK',
		'package',
		'tag',
		'selectedList'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #tests }
MolNewComponentLibraryPresenter >> browseSelectedPackage: p tag: t [
	"browse the selected Tag, which is a part of a package (that contains classes)"

	| browser |
	self flag:
		'pas d icones pour tag sélectionné quand plusieurs existent'.
	browser := ClyFullBrowserMorph new.
	browser navigationEnvironment: ClyNavigationEnvironment currentImage.
	browser
		spawnBrowser: ClyFullBrowserMorph
		withState: [ :b | "b setUpScopedModeWith: b allNavigationScopes.
		b switchToFullClassHierarchy."
			b selectPackage: p atClassTag: t name ]
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> browseSelectedTag [
	"browse the selected Tag, which is a part of a package (that contains classes)"

	self browseSelectedPackage: package tag: tag
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> buttonBrowseAction [
	"a package or tag needs to be selected in order to browse it. The last selected one (for both lists) being the one browsed"

	| size |
	selectedList = packageList
		ifTrue: [ package browse ]
		ifFalse: [ "needs to be redirected to a package when only one Tag exists"
			size := package classTags size.
			size = 1
				ifTrue: [ package browse ]
				ifFalse: [ self browseSelectedTag ] ]
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> connectPresenters [
	"enables the Browse and OK buttons if a package is selected and updates the tag frame"

	self tagClicked.

	packageList whenSelectionChangedDo: [ self fillTagList ].

	self packageClicked
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> createComponent [

	| newComponent |
	self flag: 'to do'.

	"creates component in package"

	"optional tag"

	"redirects to new Molecule Component window"
	newComponent := MolComponent new.
	newComponent open.

	"closes the window"
	self delete.
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newLeftToRight
				   add: (SpBoxLayout newVertical
						    add: 'Package' expand: false;
						    add: packageList;
						    yourself);
				   add: SpBoxLayout newLeftToRight width: 10 yourself;
				   add: (SpBoxLayout newVertical
						    add: 'Tag' expand: false;
						    add: tagList;
						    yourself);
				   yourself);
		  addLast: actionBar;
		  yourself
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> fillTagList [
	"loads every tag of the selected package in tagList"

	| tags |
	"can't use packageList transmitTo: tagList transform: [ :p | p classTags ], provokes a bug when a character is entered into the filter part of packageList"
	package := packageList selectedItem.
	package ifNotNil: [
		tags := package classTags.
		tagList items: tags ]
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> initializePresenters [

	self initializePresentersMolOptions.

	packageList := MolSpFilteringListDoubleClickPresenter new.
	packageList listPresenter
		display: [ :pack | pack name ];
		displayIcon: [ self iconNamed: #package ];
		sortingBlock: [ :a :b | a name < b name ];
		items: RPackageOrganizer default packages.

	tagList := MolSpFilteringListDoubleClickPresenter new.
	tagList listPresenter
		display: [ :t | t name ];
		displayIcon: [ self iconNamed: #tag ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : #initialization }
MolNewComponentLibraryPresenter >> initializePresentersMolOptions [
	"done this way instead of using super initializePresenters since it's the only way to have the correct positioning for the OK button (left of the others but not by a large margin)"

	buttonBrowse := self newButton
		                label: 'Browse';
		                icon: (self iconNamed: #package);
		                help: 'Browse the selected implementation';
		                action: [ self buttonBrowseAction ];
		                disable;
		                yourself.

	buttonClose := self newButton
		               label: 'Close';
		               icon: (self iconNamed: #smallCancel);
		               help: 'Close the window';
		               action: [ self delete ];
		               yourself.

	"adds the OK button in order to confirm in what package the new component will be created"
	buttonOK := self newButton
		            label: 'OK';
		            help: 'Creates the Molecule Component';
		            action: [ self createComponent ];
		            disable;
		            yourself.

	"action bar"
	actionBar := self newActionBar
		             addLast: buttonOK;
		             addLast: buttonBrowse;
		             addLast: buttonClose;
		             yourself
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> packageClicked [
	"determines what happens once a package is selected, such as activating the Browse and OK buttons"

	packageList whenSelectionChangedDo: [
		package := packageList selectedItem.
		"used to double-click on a Tag"
		packageList package: package.
		selectedList := packageList.

		package ifNotNil: [
			buttonBrowse enable.
			buttonOK enable ] ]
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> packageList [
	"used for test purposes"

	^ packageList
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> tagClicked [
	"determines what happens once a tag is selected"

	tagList whenSelectionChangedDo: [
		selectedList := tagList.
		tag := tagList selectedItem ]
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> tagList [
	"used for test purposes"

	^ tagList
]

{ #category : #tests }
MolNewComponentLibraryPresenter >> title [

	^ 'Molecule Component Package and Tag'
]
