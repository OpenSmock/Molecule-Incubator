Class {
	#name : #MolNewComponentLibrary,
	#superclass : #MolOptions,
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
MolNewComponentLibrary >> browseSelectedTag [
	"browse the selected Tag, which is a part of a package (that contains classes)"

	| selectedTag packageName taggedClassesQuery |
	self flag: '- ne fonctionne pas'.
	selectedTag := ClyTaggedClassGroup new.
	"receiver of do: is nil"
	taggedClassesQuery := ClyTaggedClassesQuery new.
	"package has a syntax such as Molecule-Core, Core being the tag here"
	packageName := package name , ' ' , tag name.
	taggedClassesQuery tag: tag.
	"packageScope := ClyPackageScope new.
	packageScope basisObjects: package asString.
	taggedClassesQuery scope: packageScope."

	selectedTag classQuery: taggedClassesQuery.
	selectedTag name: packageName.
	selectedTag browse
]

{ #category : #tests }
MolNewComponentLibrary >> buttonBrowseAction [
	"a package or tag needs to be selected in order to browse it. The last selected one (for both lists) being the one browsed"

	| item class |
	self flag:
		'browse pas encore 100 fonctionnel, tag non plus, implementationList'.
	item := selectedList selectedItem.
	self halt.
	item ifNotNil: [ "self halt."
		class := item class.
		"package selected"
		class = RPackage ifTrue: [ "package := item name."
			package name browse ].
		"tag selected"
		class = RPackageTag ifTrue: [ self browseSelectedTag ] ]
]

{ #category : #tests }
MolNewComponentLibrary >> connectPresenters [
	"enables the Browse and OK buttons if a package is selected, also updates the tag frame"

	self packageClicked.
	self tagClicked.

	packageList whenSelectionChangedDo: [ self fillTagList ].
]

{ #category : #tests }
MolNewComponentLibrary >> createComponent [

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
MolNewComponentLibrary >> defaultLayout [

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
MolNewComponentLibrary >> fillTagList [
	"loads every tag of the selected package in its corresponding frame"

	| tags |
	implementationList := packageList.
	
	package := packageList selectedItem.
	tags := package classTags.

	tagList items: tags
]

{ #category : #tests }
MolNewComponentLibrary >> initializePresenters [

	self initializePresentersMolOptions.

	packageList := SpFilteringListDoubleClickPresenter new.
	packageList listPresenter
		display: [ :pack | pack name ];
		displayIcon: [ self iconNamed: #package ];
		sortingBlock: [ :a :b | a name < b name ];
		items: RPackageOrganizer default packages.

	tagList := SpFilteringListDoubleClickPresenter new.
	tagList listPresenter
			display: [ :tag | tag name ];
		displayIcon: [ self iconNamed: #tag ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : #initialization }
MolNewComponentLibrary >> initializePresentersMolOptions [
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
MolNewComponentLibrary >> packageClicked [
	"determines what happens once a package is selected, such as activating the Browse and OK buttons"

	packageList whenSelectionChangedDo: [
		selectedList := packageList.
		package := packageList selectedItem.

		package ifNotNil: [
			buttonBrowse enable.
			buttonOK enable ] ]
]

{ #category : #tests }
MolNewComponentLibrary >> tagClicked [
	"determines what happens once a tag is selected"

	tagList whenSelectionChangedDo: [
		selectedList := tagList.
		tag := tagList selectedItem ]
]

{ #category : #tests }
MolNewComponentLibrary >> title [

	^ 'Molecule Component Package and Tag'
]
