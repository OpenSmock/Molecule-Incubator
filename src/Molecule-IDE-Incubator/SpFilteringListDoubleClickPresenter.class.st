Class {
	#name : #SpFilteringListDoubleClickPresenter,
	#superclass : #SpFilteringListPresenter,
	#instVars : [
		'activateOnSingleClick',
		'activationBlock',
		'implementationList',
		'filter'
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

	| item |
	listPresenter whenActivatedDo: [
		item := listPresenter selectedItem.
		item browse ]
]

{ #category : #simulation }
SpFilteringListDoubleClickPresenter >> initializePresenters [
	"changes the original 'Filter...' placeholder text to 'Hit return to accept'"

	super initializePresenters.
	filterInputPresenter placeholder: 'Hit return to accept'
]
