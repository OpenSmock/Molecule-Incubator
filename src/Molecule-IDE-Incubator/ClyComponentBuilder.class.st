Class {
	#name : #ClyComponentBuilder,
	#superclass : #ClyBrowserToolMorph,
	#instVars : [
		'type',
		'imageMorph'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #activation }
ClyComponentBuilder class >> browserTabActivation [
	"This declaration specifies that in any browser when classes are selected, a test setup editor will be available in a tab."

	<classAnnotation>
	^ ClyTabActivationStrategyAnnotation for: ClyClass asCalypsoItemContext
]

{ #category : #testing }
ClyComponentBuilder class >> shouldBeActivatedInContext: aBrowserContext [
	aBrowserContext isClassSelected ifFalse: [ ^false ].

	(aBrowserContext lastSelectedItem hasProperty: ClyTestResultProperty) ifFalse: [ ^false ].

	(aBrowserContext lastSelectedClass lookupSelector: #setUp) ifNil: [ ^false ].
	"last condition is to not show this tool if user selects #setUp method manually"
	aBrowserContext isMethodSelected ifFalse: [ ^true ].
	^aBrowserContext browser methodSelection lastSelectedItem name ~= 'setUp'
]

{ #category : #accessing }
ClyComponentBuilder class >> tabOrder [
	^ ClyClassDefinitionEditorToolMorph tabOrder + 1
]

{ #category : #accessing }
ClyComponentBuilder >> activationPriority [
	^-100
]

{ #category : #testing }
ClyComponentBuilder >> belongsToCurrentBrowserContext [

	self flag: 'fait que pour test case check Type Molecule voir classes cmd'.
	^ browser isClassSelected: type
]

{ #category : #testing }
ClyComponentBuilder >> build [

	| componentBuilder |
	self flag:
		'pourquoi texte roassal affiché, sauvegarde type sélectionné'.
	"open returns a RSCanvas"
	componentBuilder := ComponentBuilder new open.
	self addMorph: componentBuilder open fullFrame: LayoutFrame identity
]

{ #category : #initialization }
ClyComponentBuilder >> defaultTitle [

	^ 'ComponentBuilder'
]

{ #category : #testing }
ClyComponentBuilder >> isSimilarTo: anotherBrowserTool [

	^ self class = anotherBrowserTool class "and: [
		  testClass == anotherBrowserTool testClass ]"
]

{ #category : #testing }
ClyComponentBuilder >> isValidInContext: aClyFullBrowserContext [

	self context class = aClyFullBrowserContext class ifFalse: [ ^ false ].

	^ aClyFullBrowserContext selectedClasses includes: self type
]

{ #category : #initialization }
ClyComponentBuilder >> setUpModelFromContext [

	type := context lastSelectedClass
]

{ #category : #controlling }
ClyComponentBuilder >> switchToMethod: aMethod [
	self flag: 'unused'.

	browser selectMethod: aMethod.
	self removeFromBrowser
]

{ #category : #testing }
ClyComponentBuilder >> type [
	^ type
]
