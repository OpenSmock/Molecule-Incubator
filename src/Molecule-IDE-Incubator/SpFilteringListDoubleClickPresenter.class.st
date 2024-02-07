Class {
	#name : #SpFilteringListDoubleClickPresenter,
	#superclass : #SpFilteringListPresenter,
	#instVars : [
		'activateOnSingleClick',
		'activationBlock',
		'implementationList',
		'filter'
	],
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
		size := package classTags size.
		item class = RPackageTag
			ifTrue: [ "needs to be redirected to a package when only one Tag exists"
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
