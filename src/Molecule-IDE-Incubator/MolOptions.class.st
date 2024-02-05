Class {
	#name : #MolOptions,
	#superclass : #SpPresenter,
	#instVars : [
		'implementationList',
		'actionBar',
		'buttonBrowse',
		'buttonClose'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #tests }
MolOptions >> buttonBrowseAction [ 
]

{ #category : #tests }
MolOptions >> initializePresenters [
	"buttons"

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
		
"action bar"
	actionBar := self newActionBar
		             addLast: buttonBrowse;
		             addLast: buttonClose;
		             yourself
]

{ #category : #tests }
MolOptions >> listImplementations: selectedClass [
	"necessary to use a Collection or one of its subclasses (Array in this case) to retrieve implementations of the selected Type Trait"

	(selectedClass = '' or: selectedClass = OrderedCollection new)
		ifFalse: [
			^ selectedClass users asArray ]
]