"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I'm the builder of the diagram representation of a component, used in several options offered by Molecule-IDE. See the scientific papers around Molecule to know what interface shape means what.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	box:		<Object>
	canvas:		<Object>
	implementation:		<Object>
	shapeExtent:		<Object>
	type:		<Object>
	yEvent:		<Object>
	yParameter:		<Object>
	yService:		<Object>


    Implementation Points
"
Class {
	#name : #MolComponentBuilder,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'box',
		'type',
		'implementation',
		'yParameter',
		'shapeExtent',
		'yService',
		'yEvent'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #rendering }
MolComponentBuilder >> addLineFromBoxTo: interfaceShape [
	"used to link the main component box to its interface shapes"

	| line |
	line := RSLine new
		        from: box;
		        to: interfaceShape;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: line
]

{ #category : #rendering }
MolComponentBuilder >> asForm [
	"used to return a form, a static image and not a canvas which is drawn upon"
	self flag: 'à tester'.

	^ canvas asForm
]

{ #category : #rendering }
MolComponentBuilder >> canvas [
	"used to get the canvas in order to add it to the global canvas of MolComponentVisualizer"

	^ canvas
]

{ #category : #rendering }
MolComponentBuilder >> createForkShape: usedParameterX and: usedParameterY [
	"creates the fork shape used to represent the used parameter interfaces as defined by Molecule, made of a long upper line and two short ends"

	| lineThickness usedServiceUpperLine usedServiceLowerLeftLine usedServiceLowerRightLine lineLength |
	lineThickness := 1.
	lineLength := 40.

	usedServiceUpperLine := RSFork new
		                        color: Color black;
		                        extent: lineLength @ lineThickness;
		                        yourself.
	usedServiceUpperLine translateTo: usedParameterX @ usedParameterY.

	usedServiceLowerLeftLine := RSFork new
		                            color: Color black;
		                            extent: lineLength / 2 @ lineThickness;
		                            yourself.
	"puts the line vertically"
	usedServiceLowerLeftLine rotateByDegrees: 90.
	usedServiceLowerLeftLine translateTo:
		usedParameterX - 30 @ usedParameterY + 10.

	usedServiceLowerRightLine := RSFork new
		                             color: Color black;
		                             extent: lineLength / 2 @ lineThickness;
		                             yourself.
	usedServiceLowerRightLine rotateByDegrees: 90.
	usedServiceLowerRightLine translateTo:
		usedParameterX + 10 @ usedParameterY + 10.

	canvas add: usedServiceUpperLine.
	canvas add: usedServiceLowerLeftLine.
	canvas add: usedServiceLowerRightLine.

	"returned since it's used by the line as the end point"
	^ usedServiceUpperLine
]

{ #category : #rendering }
MolComponentBuilder >> generateConsumedEvents [
	"generates the consumed Events part, which is composed of the consumed event interfaces, the right arrow shape and the line that links the box and the shape"

	| consumedEventShape |
	self flag: 'shape à remttre'.
	self showInterfaces: 'consumedEvent' xValue: -220 yValue: yEvent.

	consumedEventShape := RSShapeFactory rightArrow
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: shapeExtent;
		                      yourself.
	consumedEventShape translateTo: -110 @ yEvent - 20.

	canvas add: consumedEventShape.

	self addLineFromBoxTo: consumedEventShape
]

{ #category : #rendering }
MolComponentBuilder >> generateMoleculeComponent [
	"generates the central box which represents the Molecule component as well as showing the name of the component"

	| component |
	box := RSBox new
		       extent: 200 @ 200;
		       borderColor: Color black;
		       color: Color white;
		       yourself.
	box cornerRadius: 10.
	box translateTo: 0 @ 0.

	component := RSLabel new
		             text: implementation;
		             yourself.
	component translateTo: 0 @ 0.

	canvas addShape: box.
	canvas addShape: component
]

{ #category : #rendering }
MolComponentBuilder >> generateProducedEvents [
	"generates the produced Events part, which is composed of the produced event interfaces, the diamond shape and the line that links the box and the shape"

	| producedEventShape |
	self showInterfaces: 'producedEvent' xValue: 220 yValue: yEvent.

	producedEventShape := RSShapeFactory diamond
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: shapeExtent;
		                      yourself.
	producedEventShape translateTo: 130 @ yEvent.

	canvas add: producedEventShape.
	
self addLineFromBoxTo: producedEventShape.
]

{ #category : #rendering }
MolComponentBuilder >> generateProvidedParameters [
	"generates the provided parameters part, which is composed of the provided parameter interfaces, the square shape and the line that links the box and the shape"

	| providedParameterShape |
	self
		showInterfaces: 'providedParameter'
		xValue: 100
		yValue: yParameter.

	providedParameterShape := RSBox new
		                          borderColor: Color black;
		                          color: Color white;
		                          extent: shapeExtent;
		                          yourself.
	providedParameterShape translateTo: 60 @ 130.

	canvas add: providedParameterShape.
	
self addLineFromBoxTo: providedParameterShape.
]

{ #category : #rendering }
MolComponentBuilder >> generateProvidedServices [
	"generates the provided services part, which is composed of the provided service interfaces, the circle shape and the line that links the box and the shape"

	| providedServiceShape |
	self showInterfaces: 'providedService' xValue: 220 yValue: yService.

	providedServiceShape := RSEllipse new
		                         borderColor: Color black;
		                         color: Color white;
		                         extent: shapeExtent;
		                         yourself.
	providedServiceShape translateTo: 130 @ yService.

	canvas add: providedServiceShape.
	
self addLineFromBoxTo: providedServiceShape.
]

{ #category : #rendering }
MolComponentBuilder >> generateType [
	"generates the black dot above the component as well as showing the Type of the component"

	| dot typeLabel yType |
	yType := -150.

	dot := RSCircle new
		       extent: shapeExtent;
		       color: Color black;
		       yourself.
	dot translateTo: 0 @ yType.

	typeLabel := RSLabel new
		             text: type asString;
		             yourself.
	typeLabel translateTo: 100 @ yType.

	canvas addShape: dot.
	canvas addShape: typeLabel.
	
	self addLineFromBoxTo: dot.
]

{ #category : #rendering }
MolComponentBuilder >> generateUsedParameters [
	"generates the used parameters part, which is composed of the used parameter interfaces, the fork shape and the line that links the box and the shape"

	| usedParameterUpperLine usedParameterY usedParameterX |
		self showInterfaces: 'usedParameter' xValue: -60 yValue: yParameter.
	
	usedParameterX := -40.
	usedParameterY := 115.
	usedParameterUpperLine := self
		                          createForkShape: usedParameterX
		                          and: usedParameterY.

	"usedParameterUpperLine can't be a RSLine since the from: to: of RSLine isn't applicable to herself"
	self addLineFromBoxTo: usedParameterUpperLine
]

{ #category : #rendering }
MolComponentBuilder >> generateUsedServices [
	"generates the used services part, which is composed of the used service interfaces, the half-empty circle shape and the line that links the box and the shape"

	| usedServiceShape |
	self showInterfaces: 'usedService' xValue: -200 yValue: yService.

	usedServiceShape := RSShapeFactory halfEmptyRightCircle
		                    borderColor: Color black;
		                    color: Color white;
		                    extent: shapeExtent;
		                    yourself.
	usedServiceShape cornerRadii: 10.
	usedServiceShape translateTo: -130 @ yService.

	canvas add: usedServiceShape.
	
	self addLineFromBoxTo: usedServiceShape.
]

{ #category : #rendering }
MolComponentBuilder >> implementation: aMoleculeImplementation [
	"attributes the implementation as well as getting their Molecule Type Trait"

	implementation := aMoleculeImplementation.
	type := implementation allTraits at: 1
]

{ #category : #rendering }
MolComponentBuilder >> initializeRelativeCoordinates [
	"y values used to position interface texts"

	yService := -50.
	yEvent := 80.
	yParameter := 160
]

{ #category : #rendering }
MolComponentBuilder >> showComponent [

	shapeExtent := 30 @ 30.

	canvas := RSCanvas new.
	canvas @ RSCanvasController.
	canvas zoomToFit.

	self initializeRelativeCoordinates.

	self generateMoleculeComponent.
	self generateType.

	"required part of the component"
	self generateUsedServices.
	self generateConsumedEvents.
	self generateUsedParameters.

	"offered part of the component"
	self generateProvidedParameters.
	self generateProducedEvents.
	self generateProvidedServices.

	^ canvas
]

{ #category : #rendering }
MolComponentBuilder >> showInterfaces: anInterfaceString xValue: xValue yValue: yValue [
	"shows and formats the interfaces required and offered by a component"

	| interfaces label yLabel |
	self flag: 'texte centré donc fait bizarre sur plusieurs lignes'.
	"don't show a component if the selected element isn't one (Object superclass...)"
	type isComponentType ifFalse: [ ^ '' ].

	anInterfaceString = 'consumedEvent' ifTrue: [
		interfaces := type allConsumedEvents ].
	anInterfaceString = 'usedParameter' ifTrue: [
		interfaces := type allUsedParameters ].
	anInterfaceString = 'usedService' ifTrue: [
		interfaces := type allUsedServices ].

	anInterfaceString = 'producedEvent' ifTrue: [
		interfaces := type allProducedEvents ].
	anInterfaceString = 'providedParameter' ifTrue: [
		interfaces := type allProvidedParameters ].
	anInterfaceString = 'providedService' ifTrue: [
		interfaces := type allProvidedServices ].

	interfaces = OrderedCollection new ifTrue: [
		label := RSLabel new
			         text: '';
			         yourself.
		label translateTo: xValue @ yValue.
		canvas add: label ].
	"starts the Text by anOrderedCollection() without this line"
	interfaces size = 1 ifTrue: [
		label := RSLabel new
			         text: (interfaces at: 1) asString;
			         yourself.
		label translateTo: xValue @ yValue.
		canvas add: label ].

	"used to position multiple labels when multiple interfaces need to be shown"
	yLabel := 0.
	interfaces do: [ :interface |
		label := RSLabel new
			         text: interface asString;
			         yourself.
		label translateTo: xValue @ yValue + yLabel.
		canvas add: label.

		yLabel := yLabel + 20 ]
]
