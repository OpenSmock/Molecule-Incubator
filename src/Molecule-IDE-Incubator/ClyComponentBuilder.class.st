Class {
	#name : #ClyComponentBuilder,
	#superclass : #ClyBrowserToolMorph,
	#instVars : [
		'implementation'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #activation }
ClyComponentBuilder class >> browserTabActivation [
	"This declaration specifies that in any browser when a Type is selected, a ComponentBuilder window will be visible in a tab"

	<classAnnotation>
	^ ClyTabActivationStrategyAnnotation for:
		  ClyClass asCalypsoItemContext
]

{ #category : #testing }
ClyComponentBuilder class >> shouldBeActivatedInContext: aBrowserContext [
	"is only shown for Molecule components, not their Types"

	^ aBrowserContext isClassSelected and: [
		  aBrowserContext lastSelectedClass inheritsFrom: MolAbstractComponentImpl ]
]

{ #category : #accessing }
ClyComponentBuilder class >> tabOrder [
	^ ClyClassDefinitionEditorToolMorph tabOrder + 1
]

{ #category : #testing }
ClyComponentBuilder >> activationPriority [

	^ -300
]

{ #category : #testing }
ClyComponentBuilder >> build [

	| componentBuilder canvas |
	"see class side for shouldBeActivatedInContext: "
	self flag: 'entête roassal'.
	canvas := RSCanvas new.

	componentBuilder := ComponentBuilder new.
	componentBuilder implementation: implementation.
	componentBuilder canvas: canvas.
	"showComponent returns a RSCanvas"
	self addMorph: componentBuilder showComponent open fullFrame: LayoutFrame identity
]

{ #category : #initialization }
ClyComponentBuilder >> defaultIconName [

	^ #smallItalic
]

{ #category : #initialization }
ClyComponentBuilder >> defaultTitle [

	^ 'ComponentBuilder'
]

{ #category : #testing }
ClyComponentBuilder >> isSimilarTo: anotherBrowserTool [

	(super isSimilarTo: anotherBrowserTool) ifFalse: [ ^ false ].
	^ implementation = anotherBrowserTool type
]

{ #category : #testing }
ClyComponentBuilder >> isValidInContext: aClyFullBrowserContext [

	self context class = aClyFullBrowserContext class ifFalse: [ ^ false ].

	self context metaLevelScope = aClyFullBrowserContext metaLevelScope
		ifFalse: [ ^ false ].

	^ implementation = aClyFullBrowserContext lastSelectedClass or: [
		  implementation = aClyFullBrowserContext lastSelectedClass instanceSide ]
]

{ #category : #initialization }
ClyComponentBuilder >> setUpModelFromContext [

	implementation := context lastSelectedClass
]
