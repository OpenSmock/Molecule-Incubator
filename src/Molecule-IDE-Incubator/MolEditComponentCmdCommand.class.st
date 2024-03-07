"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: If the selected class in the System Browser is a Molecule Type,  I display the Edit Component Type option in the Molecule sub-menu while right-clicking.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	class:		<Object>
	package:		<Object>


    Implementation Points
"
Class {
	#name : #MolEditComponentCmdCommand,
	#superclass : #MolTypeCmdCommand,
	#instVars : [
		'package',
		'class'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #testing }
MolEditComponentCmdCommand class >> canBeExecutedInContext: aBrowserContext [

	(super canBeExecutedInContext: aBrowserContext) ifFalse: [ ^ false ].

	^ aBrowserContext isPackageSelected
]

{ #category : #testing }
MolEditComponentCmdCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: MolCmdMenuGroup
		  for: ClyFullBrowserClassContext
]

{ #category : #accessing }
MolEditComponentCmdCommand >> defaultMenuItemName [

	^ 'Edit Component Type'
]

{ #category : #accessing }
MolEditComponentCmdCommand >> description [

	^ 'Shows interfaces of this Molecule Type'
]

{ #category : #accessing }
MolEditComponentCmdCommand >> execute [

	| newComponent |
	newComponent := MolComponent new.
	newComponent setTypeName: class package: package.
	newComponent open
]

{ #category : #accessing }
MolEditComponentCmdCommand >> prepareFullExecutionInContext: aBrowserContext [
	"sets the selected packages and class here"

	super prepareFullExecutionInContext: aBrowserContext.

	package := aBrowserContext lastSelectedPackage.
	class := aBrowserContext lastSelectedClass asString
]
