Class {
	#name : #ClyComponentBuilder,
	#superclass : #ClyBrowserToolMorph,
	#instVars : [
		'type'
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

	^ aBrowserContext isClassSelected and: [
		  aBrowserContext lastSelectedClass allTraits includes: MolComponentType ]
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
ClyComponentBuilder >> belongsToCurrentBrowserContext [

	self flag:
		'fait que pour test case check Type Molecule voir classes cmd'.
	^ "type isComponentType" (browser isClassSelected: type) or: [
		  browser isClassSelected: type instanceSide ] "and: [ type isComponentType ]"
]

{ #category : #testing }
ClyComponentBuilder >> build [

	| componentBuilder |
	"see class side for shouldBeActivatedInContext"
	self flag: 'pourquoi texte roassal affiché'.
	componentBuilder := ComponentBuilder new.
	componentBuilder type: type.
	"showComponent returns a RSCanvas"
	componentBuilder := componentBuilder showComponent.
	self addMorph: componentBuilder open fullFrame: LayoutFrame identity
]

{ #category : #initialization }
ClyComponentBuilder >> defaultTitle [

	^ 'ComponentBuilder'
]

{ #category : #testing }
ClyComponentBuilder >> isSimilarTo: anotherBrowserTool [

	self flag: ''.
	"^ self class = anotherBrowserTool class"

	"and: [
		  testClass == anotherBrowserTool testClass ]"

	(super isSimilarTo: anotherBrowserTool) ifFalse: [ ^ false ].
	^ self type = anotherBrowserTool type
]

{ #category : #testing }
ClyComponentBuilder >> isValidInContext: aClyFullBrowserContext [

	self context class = aClyFullBrowserContext class ifFalse: [ ^ false ].

	self context metaLevelScope = aClyFullBrowserContext metaLevelScope
		ifFalse: [ ^ false ].

	^ type = aClyFullBrowserContext lastSelectedClass or: [
		  type = aClyFullBrowserContext lastSelectedClass instanceSide ]
]

{ #category : #testing }
ClyComponentBuilder >> selectedClassOrMetaClass [

	^ type
]

{ #category : #initialization }
ClyComponentBuilder >> setUpModelFromContext [
	"super setUpModelFromContext."

	self type: context lastSelectedClass

	"self type: context lastSelectedClassGroup"

	"self type: context selectedClassGroups"
]

{ #category : #testing }
ClyComponentBuilder >> type [
	^ type
]

{ #category : #initialization }
ClyComponentBuilder >> type: aType [

	type := aType
]
