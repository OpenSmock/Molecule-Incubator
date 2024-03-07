"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I'm used to know if the selected class in the System Browser is a Molecule interface, which is used to display the ""See component users"" option in the Molecule sub-menu while right-clicking it.

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
	#name : #MolInterfaceCmdCommand,
	#superclass : #MolCmdCommand,
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #testing }
MolInterfaceCmdCommand class >> canBeExecutedInContext: aToolContext [

	| list selectedItem selected |
	(super canBeExecutedInContext: aToolContext) ifFalse: [ ^ false ].
	aToolContext selectedItems ifEmpty: [ ^ false ].

	selectedItem := aToolContext selectedItems at: 1.
	selected := selectedItem browserItem actualObject name.

	"find all interfaces"
	list := SystemNavigation default allClasses select: [ :c |
		        c isTrait and: [
			        c isComponentEvents or:
				        (c isComponentParameters or: c isComponentServices) ] ].

	"return if selected object is in list of component"
	^ list includes: (self class environment at: selected asSymbol)
]

{ #category : #'api - accessing' }
MolInterfaceCmdCommand >> selectedClass [

	^ (selectedItems collect: [ :p | p browserItem actualObject ])
]

{ #category : #'as yet unclassified' }
MolInterfaceCmdCommand >> selectedInterfaceClass [
	"this method returns the class in the System Browser that is an interface (Events/Parameters/Services)"

	^ self selectedClass select: [ :c |
		  c isComponentEvents or:
			  (c isComponentParameters or: c isComponentServices) ]
]
