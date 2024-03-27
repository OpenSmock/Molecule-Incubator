"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I'm a filtering list that can also be double-clicked to browse the selected item.

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
	#name : #SpFilteringListDoubleClickPresenter,
	#superclass : #SpFilteringListPresenter,
	#classVars : [
		'package'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #simulation }
SpFilteringListDoubleClickPresenter >> connectPresenters [

	super connectPresenters.
	self doubleClickActivated
]

{ #category : #simulation }
SpFilteringListDoubleClickPresenter >> doubleClickActivated [
	"activates the Browse functionality by double-clicking an element"

	| item molComponent size |
	listPresenter whenActivatedDo: [
		item := listPresenter selectedItem.
		item class = RPackageTag
			ifTrue: [ "New Component part, needs to be redirected to a package when only one Tag exists"
				size := package classTags size.
				size = 1
					ifTrue: [ package browse ]
					ifFalse: [
						molComponent := MolNewComponentLibrary new.
						molComponent browseSelectedPackage: package tag: item ] ]
			ifFalse: [ item browse ] ]
]

{ #category : #simulation }
SpFilteringListDoubleClickPresenter >> initializePresenters [
	"changes the original 'Filter...' placeholder text to 'Hit return to accept'"

	super initializePresenters.
	filterInputPresenter placeholder: 'Hit return to accept'
]

{ #category : #'as yet unclassified' }
SpFilteringListDoubleClickPresenter >> package: p [
	"stocks the package in order to double-click a Tag"

package := p
]
