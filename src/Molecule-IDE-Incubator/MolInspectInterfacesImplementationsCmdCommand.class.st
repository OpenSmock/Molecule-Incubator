"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I am used to execute the See Component Users option with the right parameter.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MolInspectInterfacesImplementationsCmdCommand,
	#superclass : #MolInterfaceCmdCommand,
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #activation }
MolInspectInterfacesImplementationsCmdCommand class >> browserMenuActivation [
	<classAnnotation>
	^CmdContextMenuActivation byItemOf: MolCmdMenuGroup for: ClyFullBrowserClassContext.
]

{ #category : #accessing }
MolInspectInterfacesImplementationsCmdCommand >> defaultMenuIconName [

	^ 'glamorousInspect'
]

{ #category : #accessing }
MolInspectInterfacesImplementationsCmdCommand >> defaultMenuItemName [

	^ 'See Component users'
]

{ #category : #accessing }
MolInspectInterfacesImplementationsCmdCommand >> description [

	^ 'Shows in a window users of the selected interface (Events, Parameters or Services)'
]

{ #category : #accessing }
MolInspectInterfacesImplementationsCmdCommand >> execute [

	| selectedInterface emptyArray interface |
	selectedInterface := self selectedInterfaceClass.

	interface := MolInterfacesPresenter new.
	emptyArray := Array new: 0.

	"condition and ifTrue: are executed only if multiple Traits were/are selected in the System Browser, since this option only supports one Type selected at a time"
	selectedInterface = emptyArray
		ifFalse: [ selectedInterface := selectedInterface at: 1 ]
		ifTrue: [
		selectedInterface := (selectedItems at: 1) browserItem actualObject ].
	interface interface: selectedInterface.
	interface open
]
