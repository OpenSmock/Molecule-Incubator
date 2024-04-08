"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: If the selected class in the System Browser is a Molecule Type, I display the See component implementations option in the Molecule sub-menu while right-clicking.

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
	#name : #MolInspectTypeImplementationsCmdCommand,
	#superclass : #MolTypeCmdCommand,
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #activation }
MolInspectTypeImplementationsCmdCommand class >> browserMenuActivation [
	<classAnnotation>
	^CmdContextMenuActivation byItemOf: MolCmdMenuGroup for: ClyFullBrowserClassContext.
]

{ #category : #accessing }
MolInspectTypeImplementationsCmdCommand >> defaultMenuIconName [

	^ 'glamorousInspect'
]

{ #category : #accessing }
MolInspectTypeImplementationsCmdCommand >> defaultMenuItemName [

	^ 'See Component Implementations'
]

{ #category : #accessing }
MolInspectTypeImplementationsCmdCommand >> description [

	^ 'Shows implementations of this Molecule Type'
]

{ #category : #accessing }
MolInspectTypeImplementationsCmdCommand >> execute [

	| selectedType implem emptyArray |
	selectedType := self selectedTypeClass.

	implem := MolImplementationsPresenter new.
	emptyArray := Array new: 0.

	"condition and ifTrue: are executed only if multiple Traits were/are selected in the System Browser, since this option only supports one Type selected at a time"
	selectedType = emptyArray
		ifFalse: [ selectedType := selectedType at: 1 ]
		ifTrue: [
		selectedType := (selectedItems at: 1) browserItem actualObject ].
	implem type: selectedType.
	implem open
]
