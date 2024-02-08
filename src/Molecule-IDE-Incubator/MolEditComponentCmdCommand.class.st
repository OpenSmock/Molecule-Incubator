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
	"self halt."
	newComponent open
]

{ #category : #accessing }
MolEditComponentCmdCommand >> prepareFullExecutionInContext: aBrowserContext [
	"sets the selected packages and class here"

	super prepareFullExecutionInContext: aBrowserContext.

	package := aBrowserContext lastSelectedPackage.
	class := aBrowserContext lastSelectedClass asString
]
