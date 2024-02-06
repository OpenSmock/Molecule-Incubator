Class {
	#name : #SpTextInputFieldDoubleClickPresenter,
	#superclass : #SpTextInputFieldPresenter,
	#instVars : [
		'activateOnSingleClick'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
SpTextInputFieldDoubleClickPresenter >> activateOnDoubleClick [
	"Configure the list to trigger activation on double click.
	 An element on a list can be 'activated', meaning it will trigger an event to execute an 
	 action on it. An activation is different than a selection (one can 'select' an element without 
	 activating it).
	 See `SpAbstractListPresenter>>#whenActivatedDo:`"

	activateOnSingleClick := false
]

{ #category : #initialization }
SpTextInputFieldDoubleClickPresenter >> connectPresenters [

	super connectPresenters.
	self doubleClickActivated
]

{ #category : #initialization }
SpTextInputFieldDoubleClickPresenter >> doubleClickActivated [
	"double-clicking an input field browses the displayed Type"

	| item |
	self flag: 'unused class'.
	self presenters do: [ :presenter |
		presenter whenActivatedDo: [
			item := text withoutPrefix: 'Interface used by '.
			item browse ] ]
]
