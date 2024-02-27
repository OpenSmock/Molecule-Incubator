Class {
	#name : #SpTextInputFieldDoubleClickPresenter,
	#superclass : #SpTextInputFieldPresenter,
	#instVars : [
		'activateOnSingleClick'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
SpTextInputFieldDoubleClickPresenter >> connectPresenters [

	super connectPresenters
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
