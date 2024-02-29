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

{ #category : #testing }
ClyComponentBuilder >> belongsToCurrentBrowserContext [

	self flag: 'fait que pour test case check Type Molecule voir classes cmd'.
	^ (browser isClassSelected: type) "and: [ type isComponentType ]" or: [ browser isClassSelected: type instanceSide ]
]

{ #category : #testing }
ClyComponentBuilder >> build [

	| componentBuilder |
	self flag:
		'pourquoi texte roassal affiché, sauvegarde type sélectionné, méthode et mécanisme d update?'.
	componentBuilder := ComponentBuilder new.
	componentBuilder type: type.
	"open returns a RSCanvas"
	componentBuilder := componentBuilder open.
	self addMorph: componentBuilder open fullFrame: LayoutFrame identity
]

{ #category : #initialization }
ClyComponentBuilder >> defaultTitle [

	^ 'ComponentBuilder'
]

{ #category : #testing }
ClyComponentBuilder >> isSimilarTo: anotherBrowserTool [
	"^ self class = anotherBrowserTool class"

	"and: [
		  testClass == anotherBrowserTool testClass ]"

	(super isSimilarTo: anotherBrowserTool) ifFalse: [ ^ false ].
	^ type = anotherBrowserTool type
]

{ #category : #testing }
ClyComponentBuilder >> isValidInContext: aClyFullBrowserContext [

	self context class = aClyFullBrowserContext class ifFalse: [ ^ false ].

	self context metaLevelScope = aClyFullBrowserContext metaLevelScope
		ifFalse: [ ^ false ].

	^ aClyFullBrowserContext = aClyFullBrowserContext lastSelectedClass
		  or: [ type = aClyFullBrowserContext lastSelectedClass instanceSide ]
]

{ #category : #initialization }
ClyComponentBuilder >> setUpModelFromContext [

	super setUpModelFromContext.
	type := context lastSelectedClass
]

{ #category : #testing }
ClyComponentBuilder >> type [
	^ type
]
