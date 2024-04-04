"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I'm the tab added to the System Browser whenever a Molecule Component is selected. I display the diagram representation offered by MolComponentBuilder.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	implementation:		<Object>


    Implementation Points
"
Class {
	#name : #MolClyComponentBuilder,
	#superclass : #ClyBrowserToolMorph,
	#instVars : [
		'implementation'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #activation }
MolClyComponentBuilder class >> browserTabActivation [
	"This declaration specifies that in any browser when a Type is selected, a ComponentBuilder window will be visible in a tab"

	<classAnnotation>
	^ ClyTabActivationStrategyAnnotation for:
		  ClyClass asCalypsoItemContext
]

{ #category : #testing }
MolClyComponentBuilder class >> shouldBeActivatedInContext: aBrowserContext [
	"is only shown for Molecule components, Types included"

	aBrowserContext lastSelectedClass isTrait ifTrue: [
		^ aBrowserContext lastSelectedClass isComponentType ].

	^ aBrowserContext isClassSelected and: [
		  aBrowserContext lastSelectedClass inheritsFrom:
			  MolAbstractComponentImpl ]
]

{ #category : #accessing }
MolClyComponentBuilder class >> tabOrder [
	^ ClyClassDefinitionEditorToolMorph tabOrder + 1
]

{ #category : #testing }
MolClyComponentBuilder >> activationPriority [

	^ -300
]

{ #category : #testing }
MolClyComponentBuilder >> build [

	| componentBuilder canvas rs |
	"see class side for shouldBeActivatedInContext: , which is the method that determines for which selected Pharo element in the System Browser the option should be displayed"
	canvas := RSCanvas new.

	componentBuilder := MolComponentBuilder new.
	componentBuilder implementation: implementation.

	"showComponent returns a RSCanvas"
	rs := componentBuilder showComponent: nil.
	rs @ RSCanvasController.
	rs zoomToFit.

	"createMorph doesn't return a Roassal window with its own buttons and title"
	self addMorph: rs createMorph fullFrame: LayoutFrame identity
]

{ #category : #initialization }
MolClyComponentBuilder >> defaultIconName [

	^ #smallItalic
]

{ #category : #initialization }
MolClyComponentBuilder >> defaultTitle [

	^ 'ComponentBuilder'
]

{ #category : #testing }
MolClyComponentBuilder >> isSimilarTo: anotherBrowserTool [

	(super isSimilarTo: anotherBrowserTool) ifFalse: [ ^ false ].
	^ implementation = anotherBrowserTool type
]

{ #category : #testing }
MolClyComponentBuilder >> isValidInContext: aClyFullBrowserContext [

	self context class = aClyFullBrowserContext class ifFalse: [ ^ false ].

	self context metaLevelScope = aClyFullBrowserContext metaLevelScope
		ifFalse: [ ^ false ].

	^ implementation = aClyFullBrowserContext lastSelectedClass or: [
		  implementation = aClyFullBrowserContext lastSelectedClass instanceSide ]
]

{ #category : #initialization }
MolClyComponentBuilder >> setUpModelFromContext [

	implementation := context lastSelectedClass
]
