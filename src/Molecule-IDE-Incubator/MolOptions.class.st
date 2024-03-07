"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I'm just used to keep track of the action bar (the bar at the bottom containing the Browse and Close buttons) between different options,  as well as a list.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	actionBar:		<Object>
	buttonBrowse:		<Object>
	buttonClose:		<Object>
	implementationList:		<Object>


    Implementation Points
"
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
MolOptions >> buttonBrowse [
	"used for test purposes"

	^ buttonBrowse
]

{ #category : #tests }
MolOptions >> buttonBrowseAction [ 
]

{ #category : #tests }
MolOptions >> implementationList [
	"used for test purposes"

	^ implementationList
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
