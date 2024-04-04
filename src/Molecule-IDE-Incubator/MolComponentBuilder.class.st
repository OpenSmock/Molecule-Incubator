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
MolComponentBuilder >> addLineFrom: interfaceLabel to: interfaceShape [
	"used to link an interface label to its interface shape (while being invisible by the color of the link being white), used to highlight the corresponding labels when an interface shape is hovered on"

	| line |
	line := RSLine new
		        from: interfaceLabel;
		        to: interfaceShape;
		        color: Color white;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: line
]

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

	self flag: 'see RSCanvas asForm'.

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
	self flag: 'can t be highlighted'.
	lineThickness := 1.
	lineLength := 40.

	usedServiceUpperLine := RSShapeFactory fork
		                        color: Color black;
		                        extent: lineLength @ lineThickness;
		                        yourself. "Fork new"
	usedServiceUpperLine translateTo: usedParameterX @ usedParameterY.

	usedServiceLowerLeftLine := RSShapeFactory fork
		                            color: Color black;
		                            extent: lineLength / 2 @ lineThickness;
		                            yourself. "Fork new"
	"puts the line vertically"
	usedServiceLowerLeftLine rotateByDegrees: 90.
	usedServiceLowerLeftLine translateTo:
		usedParameterX - 30 @ usedParameterY + 10.

	usedServiceLowerRightLine := RSShapeFactory fork
		                             color: Color black;
		                             extent: lineLength / 2 @ lineThickness;
		                             yourself. "Fork new"
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

	| consumedEventShape labels |
	labels := self
		          showInterfaces: 'consumedEvent'
		          xValue: -220
		          yValue: yEvent.

	labels ifNotNil: [
		self flag: 'shape'.
		consumedEventShape := RSShapeFactory rightArrow
			                      borderColor: Color black;
			                      color: Color white;
			                      extent: shapeExtent;
			                      yourself.
		consumedEventShape translateTo: -110 @ yEvent - 20.
		canvas add: consumedEventShape.

		self addLineFromBoxTo: consumedEventShape ]
]

{ #category : #rendering }
MolComponentBuilder >> generateMoleculeBox: numberedComponent [
	"generates the central box which represents the Molecule component and stocks in it the index of the component in the canvas"

	box := MolBoxComponent new
		       extent: 200 @ 200;
		       borderColor: Color black;
		       color: Color white;
		       yourself.
	box cornerRadius: 10.
	box translateTo: 0 @ 0.
	
	numberedComponent ifNotNil: [ 
	box componentNumber: numberedComponent ].

	canvas addShape: box
]

{ #category : #rendering }
MolComponentBuilder >> generateMoleculeComponentName [
	"generates the name of the component"

	| component |
	component := MolCenterLabel new
		             text: implementation;
		             yourself.
	component translateTo: 0 @ 0.

	canvas addShape: component
]

{ #category : #rendering }
MolComponentBuilder >> generateName [
	"generates the name of the component if it has been started with one (default not being shown), corresponds to the key of the Inspect running Components option"

	| nameLabel name |
	"can't get the name through the component directly so MolComponentManager is used here"
	MolComponentManager default homeServices deployedComponents
		keysAndValuesDo: [ :key :value |
			key = implementation ifTrue: [
				value keysDo: [ :keyName |
					keyName = 'default' ifFalse: [ name := keyName ] ] ] ].

	name ifNotNil: [
		nameLabel := MolCenterLabel new
			             text: name;
			             yourself.
		nameLabel translateTo: 0 @ 50.

		canvas addShape: nameLabel ]
]

{ #category : #rendering }
MolComponentBuilder >> generateProducedEvents [
	"generates the produced Events part, which is composed of the produced event interfaces, the diamond shape and the line that links the box and the shape"

	| producedEventShape labels |
	labels := self
		          showInterfaces: 'producedEvent'
		          xValue: 220
		          yValue: yEvent.

	labels ifNotNil: [
		producedEventShape := RSShapeFactory diamond
			                      borderColor: Color black;
			                      color: Color white;
			                      extent: shapeExtent;
			                      yourself.
		producedEventShape translateTo: 130 @ yEvent.
		canvas add: producedEventShape.

		self addLineFromBoxTo: producedEventShape ]
]

{ #category : #rendering }
MolComponentBuilder >> generateProvidedParameters [
	"generates the provided parameters part, which is composed of the provided parameter interfaces, the square shape and the line that links the box and the shape"

	| providedParameterShape labels |
	labels := self
		          showInterfaces: 'providedParameter'
		          xValue: 100
		          yValue: yParameter.

	labels ifNotNil: [
		providedParameterShape := RSBox new
			                          borderColor: Color black;
			                          color: Color white;
			                          extent: shapeExtent;
			                          yourself.
		providedParameterShape translateTo: 60 @ 130.
		canvas add: providedParameterShape.

		self addLineFromBoxTo: providedParameterShape ]
]

{ #category : #rendering }
MolComponentBuilder >> generateProvidedServices [
	"generates the provided services part, which is composed of the provided service interfaces, the circle shape and the line that links the box and the shape"

	| providedServiceShape labels |
	labels := self
		          showInterfaces: 'providedService'
		          xValue: 220
		          yValue: yService.

	labels ifNotNil: [
		providedServiceShape := RSEllipse new
			                        borderColor: Color black;
			                        color: Color white;
			                        extent: shapeExtent;
			                        yourself.
		providedServiceShape translateTo: 130 @ yService.
		canvas add: providedServiceShape.

		self addLineFromBoxTo: providedServiceShape ]
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

	typeLabel := MolCenterLabel new
		             text: type asString;
		             yourself.
	typeLabel translateTo: 100 @ yType.

	canvas addShape: dot.
	canvas addShape: typeLabel.

	self addLineFromBoxTo: dot
]

{ #category : #rendering }
MolComponentBuilder >> generateUsedParameters [
	"generates the used parameters part, which is composed of the used parameter interfaces, the fork shape and the line that links the box and the shape"

	| usedParameterUpperLine usedParameterY usedParameterX labels |
	labels := self
		          showInterfaces: 'usedParameter'
		          xValue: -60
		          yValue: yParameter.

	usedParameterX := -40.
	usedParameterY := 115.

	labels ifNotNil: [
		self flag: 'shape'.
		usedParameterUpperLine := self
			                          createForkShape: usedParameterX
			                          and: usedParameterY.

		"self createInvisibleLinksBetween: labels and: usedParameterUpperLine."
		"usedParameterUpperLine can't be a RSLine since the from: to: of RSLine isn't applicable to herself"
		self addLineFromBoxTo: usedParameterUpperLine ]
]

{ #category : #rendering }
MolComponentBuilder >> generateUsedServices [
	"generates the used services part, which is composed of the used service interfaces, the half-empty circle shape and the line that links the box and the shape"

	| usedServiceShape labels usedServiceBlElement usedServiceComposite |
	labels := self
		          showInterfaces: 'usedService'
		          xValue: -200
		          yValue: yService.

	labels ifNotNil: [
		self flag: 'shape'.
		usedServiceShape := RSShapeFactory halfEmptyRightCircle
			                    borderColor: Color black;
			                    color: Color white;
			                    extent: shapeExtent;
			                    yourself.
		usedServiceShape cornerRadii: 10.
		"usedServiceShape := ShapeIcon usedServiceIcon."
		"usedServiceShape := Form fromBase64String:
			                    ShapeIcon usedServiceIconEncoding."
		usedServiceShape translateTo: -130 @ yService.
		"usedServiceShape offset: -130 @ yService."
		"usedServiceBlElement := (BlElement new layout: usedServiceShape)
			                        asShape."
		"usedServiceComposite := RSComposite new add: usedServiceShape." "shapes:"
		canvas add: usedServiceShape.
		"canvas add: usedServiceBlElement."
		"canvas add: usedServiceComposite."

		"self createInvisibleLinksBetween: labels and: usedServiceShape."
		self addLineFromBoxTo: usedServiceShape ]
]

{ #category : #rendering }
MolComponentBuilder >> implementation: aMoleculeImplementation [
	"attributes the implementation as well as getting its Molecule Type Trait"

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
MolComponentBuilder >> showComponent: numberedComponent [
	"method used for Visualize running Components, every main component box needs to know the index of its component in order to highlight every interface shape and label as well as the lines that connect it to other components"

	shapeExtent := 30 @ 30.

	canvas := RSCanvas new.
	canvas zoomToFit.

	self initializeRelativeCoordinates.

	"Molecule Type (Component Representation tab in the Edit Component Type option) doesn't need to show these shapes"
	implementation ifNotNil: [
		canvas @ RSCanvasController.

		self generateMoleculeBox: numberedComponent.
		self generateMoleculeComponentName.
		"generateType was here if the order needs to be respected"
		self generateName ].

	implementation ifNil: [ self generateMoleculeBox: nil ].

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
	"shows and formats the interfaces required and offered by a component, returns the created labels"

	| interfaces label yLabel labels |
	self flag: 'texte centré donc fait bizarre sur plusieurs lignes'.
	"don't show a component if the selected element isn't one (Object superclass...)"
	type isComponentType ifFalse: [ ^ nil ].

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

	interfaces = OrderedCollection new ifTrue: [ "doesn't show the interface shape if no interface label exists"
		label := RSLabel new
			         text: '';
			         yourself.
		label translateTo: xValue @ yValue.
		canvas add: label.
		^ nil ].

	"starts the Text by anOrderedCollection() without this line"
	interfaces size = 1 ifTrue: [
		label := RSLabel new
			         text: (interfaces at: 1) asString;
			         yourself.
		label translateTo: xValue @ yValue.
		canvas add: label.
		^ label ].

	labels := OrderedCollection new.
	"used to position multiple labels when multiple interfaces need to be shown"
	yLabel := 0.
	interfaces do: [ :interface |
		label := RSLabel new
			         text: interface asString;
			         yourself.
		"xValue +/- (label textWidth / 10)"
		label translateTo: xValue @ yValue + yLabel.
		canvas add: label.
		labels add: label.

		yLabel := yLabel + 20 ].

	^ labels
]

{ #category : #rendering }
MolComponentBuilder >> type: typeClass [
	"used for the Component Representation tab for the Edit Component Type option"

	type := typeClass
]
