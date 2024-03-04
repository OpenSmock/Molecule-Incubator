Class {
	#name : #ComponentBuilder,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'box',
		'type',
		'implementation',
		'yParameter',
		'shapeExtent',
		'yService',
		'yEvent',
		'xValue',
		'yValue'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #rendering }
ComponentBuilder >> asForm [
	"used to return a form, a static image and not a canvas which is drawn upon"
	self flag: 'à tester'.

	^ canvas asForm
]

{ #category : #rendering }
ComponentBuilder >> canvas: aCanvas [
	"used so that one or more component(s) can be displayed in the same window, the canvas being independent from ComponentBuilder"

	canvas := aCanvas
]

{ #category : #rendering }
ComponentBuilder >> createForkShape: usedParameterX and: usedParameterY [
	"creates the fork shape used to represent the used parameter interfaces as defined by Molecule, made of a long upper line and two short ends"

	| lineThickness usedServiceUpperLine usedServiceLowerLeftLine usedServiceLowerRightLine lineLength |
	lineThickness := 1.
	lineLength := 40.

	usedServiceUpperLine := RSBox new
		                        color: Color black;
		                        extent: lineLength @ lineThickness;
		                        yourself.
	usedServiceUpperLine translateTo: usedParameterX @ usedParameterY.

	usedServiceLowerLeftLine := RSBox new
		                            color: Color black;
		                            extent: lineLength / 2 @ lineThickness;
		                            yourself.
	"puts the line vertically"
	usedServiceLowerLeftLine rotateByDegrees: 90.
	usedServiceLowerLeftLine translateTo: usedParameterX - 30 @ usedParameterY + 10.

	usedServiceLowerRightLine := RSBox new
		                             color: Color black;
		                             extent: lineLength / 2 @ lineThickness;
		                             yourself.
	usedServiceLowerRightLine rotateByDegrees: 90.
	usedServiceLowerRightLine translateTo: usedParameterX + 10 @ usedParameterY + 10.

	canvas add: usedServiceUpperLine.
	canvas add: usedServiceLowerLeftLine.
	canvas add: usedServiceLowerRightLine.

	"returned since it's used by the line as the end point"
	^ usedServiceUpperLine
]

{ #category : #rendering }
ComponentBuilder >> generateConsumedEvents [
	"generates the consumed Events part, which is composed of the consumed event interfaces, the right arrow shape and the line that links the box and the shape"

	| consumedEventText consumedEventShape line |
	consumedEventText := RSLabel new
		                     text: (self showInterface: 'consumedEvent');
		                     yourself.
	consumedEventText translateTo: -220 + xValue @ yEvent.

	consumedEventShape := RSShapeFactory rightArrow
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: shapeExtent;
		                      yourself.
	consumedEventShape translateTo: -110 + xValue @ yEvent - 20.

	line := RSLine new
		        from: box;
		        to: consumedEventShape;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: consumedEventText.
	canvas add: consumedEventShape.
	canvas add: line
]

{ #category : #rendering }
ComponentBuilder >> generateMoleculeComponent [
	"generates the central box which represents the Molecule component as well as showing the name of the component"

	| component |
	self flag: 'yValue'.
	box := RSBox new
		       extent: 200 @ 200;
		       borderColor: Color black;
		       color: Color white;
		       yourself.
	box cornerRadius: 10.
	box translateTo: xValue @ yValue.

	component := RSLabel new
		             text: implementation;
		             yourself.
	component translateTo: xValue @ yValue.

	canvas addShape: box.
	canvas addShape: component
]

{ #category : #rendering }
ComponentBuilder >> generateProducedEvents [
	"generates the produced Events part, which is composed of the produced event interfaces, the diamond shape and the line that links the box and the shape"

	| producedEventText producedEventShape line |
	producedEventText := RSLabel new
		                     text: (self showInterface: 'producedEvent');
		                     yourself.
	producedEventText translateTo: 220 + xValue @ yEvent.

	producedEventShape := RSShapeFactory diamond
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: shapeExtent;
		                      yourself.
	producedEventShape translateTo: 130 + xValue @ yEvent.

	line := RSLine new
		        from: box;
		        to: producedEventShape;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: producedEventText.
	canvas add: producedEventShape.
	canvas add: line
]

{ #category : #rendering }
ComponentBuilder >> generateProvidedParameters [
	"generates the provided parameters part, which is composed of the provided parameter interfaces, the square shape and the line that links the box and the shape"

	| providedParameterText providedParameterShape line |
	providedParameterText := RSLabel new
		                         text:
			                         (self showInterface: 'providedParameter');
		                         yourself.
	providedParameterText translateTo: 100 + xValue @ yParameter.

	providedParameterShape := RSBox new
		                          borderColor: Color black;
		                          color: Color white;
		                          extent: shapeExtent;
		                          yourself.
	providedParameterShape translateTo: 60 + xValue @ 130.

	line := RSLine new
		        from: box;
		        to: providedParameterShape;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: providedParameterText.
	canvas add: providedParameterShape.
	canvas add: line
]

{ #category : #rendering }
ComponentBuilder >> generateProvidedServices [
	"generates the provided services part, which is composed of the provided service interfaces, the circle shape and the line that links the box and the shape"

	| providedServicesText providedServicesShape line |
	providedServicesText := RSLabel new
		                        text:
			                        (self showInterface: 'providedService');
		                        yourself.
	providedServicesText translateTo: 220 + xValue @ yService.

	providedServicesShape := RSCircle new
		                         borderColor: Color black;
		                         color: Color white;
		                         extent: shapeExtent;
		                         yourself.
	providedServicesShape translateTo: 130 + xValue @ yService.

	line := RSLine new
		        from: box;
		        to: providedServicesShape;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: providedServicesText.
	canvas add: providedServicesShape.
	canvas add: line
]

{ #category : #rendering }
ComponentBuilder >> generateType [
	"generates the black dot above the component as well as showing the Type of the component"

	| dot line typeLabel yType |
	yType := -150 + yValue.

	dot := RSCircle new
		       extent: shapeExtent;
		       color: Color black;
		       yourself.
	dot translateTo: xValue @ yType.

	typeLabel := RSLabel new
		             text: type asString;
		             yourself.
	typeLabel translateTo: 100 + xValue @ yType.

	line := RSLine new
		        from: box;
		        to: dot;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas addShape: dot.
	canvas addShape: typeLabel.
	canvas addShape: line
]

{ #category : #rendering }
ComponentBuilder >> generateUsedParameters [
	"generates the used parameters part, which is composed of the used parameter interfaces, the fork shape and the line that links the box and the shape"

	| usedParameterText line usedServiceUpperLine usedParameterY usedParameterX |
	usedParameterText := RSLabel new
		                     text: (self showInterface: 'usedParameter');
		                     yourself.
	usedParameterText translateTo: -60 + xValue @ yParameter + yValue.

	usedParameterX := -40 + xValue.
	usedParameterY := 115 + yValue.
	usedServiceUpperLine := self
		                        createForkShape: usedParameterX
		                        and: usedParameterY.

	"usedServiceUpperLine can't be a RSLine since the from: to: of RSLine isn't applicable to herself"
	line := RSLine new
		        from: box;
		        to: usedServiceUpperLine;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: usedParameterText.
	canvas add: line
]

{ #category : #rendering }
ComponentBuilder >> generateUsedServices [
	"generates the used services part, which is composed of the used service interfaces, the half-empty circle shape and the line that links the box and the shape"

	| usedServicesText usedServicesShape line |
	self flag: 'shape'.
	usedServicesText := RSLabel new
		                    text: (self showInterface: 'usedService');
		                    yourself.
	usedServicesText translateTo: -200 + xValue @ yService.

	usedServicesShape := RSShapeFactory halfEmptyRightCircle
		                     borderColor: Color black;
		                     color: Color white;
		                     extent: shapeExtent;
		                     yourself.
	usedServicesShape cornerRadii: 10.
	usedServicesShape translateTo: -130 + xValue @ yService.

	line := RSLine new
		        from: box;
		        to: usedServicesShape;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: usedServicesText.
	canvas add: usedServicesShape.
	canvas add: line
]

{ #category : #rendering }
ComponentBuilder >> implementation: aMoleculeImplementation [
	"attributes the implementation as well as getting their Molecule Type Trait"

	implementation := aMoleculeImplementation.
	type := implementation allTraits at: 1
]

{ #category : #rendering }
ComponentBuilder >> initializeRelativeCoordinates [
	"xValue and yValue are used for MolComponentVisualize so that components don't overlap, set to 0 if only one is shown"

	xValue ifNil: [ xValue := 0 ].
	yValue ifNil: [ yValue := 0 ].

	"y values used to position interface texts"
	yService := -50.
	yEvent := 80.
	yParameter := 160
]

{ #category : #rendering }
ComponentBuilder >> showComponent [

	shapeExtent := 30 @ 30.
	canvas @ RSCanvasController.

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
ComponentBuilder >> showInterface: anInterfaceString [
	"shows and formats the interfaces required and offered by a component"

	| interfaces interfacesCopy |
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

	interfaces = OrderedCollection new ifTrue: [ ^ '' ].
	"starts the Text by anOrderedCollection() without this line"
	interfaces size = 1 ifTrue: [ ^ interfaces at: 1 ].
	"needs to add carriage returns in order to not have every interface of a part of the component's contract displayed on the same line"
	interfacesCopy := interfaces.
	self flag: 'cr'.
	interfaces := String new.
	interfaces := String streamContents: [ :stream |
		              interfacesCopy do: [ :interface | "interfaces add: interface asString , String cr""separatedBy: [
				              stream
					              nextPutAll: (String with: Character cr);
					              nextPutAll: String cr;
					              nextPutAll: '
			' ]"
			              stream nextPutAll: interface asString.
			              "stream nextPutAll: String cr"
			              "stream nextPutAll: ' <r> '"
			              "stream nextPutAll: '\ '"
			              "stream nextPutAll: Win64Platform lineEnding"
			              "stream nextPutAll: '
			 '"
			              "stream
				              << interface asString;""<< String cr""stream cr ""cr" ] ].
	"interfaces expandMacros."
	"interfaces withCRs."

	^ interfaces
]

{ #category : #rendering }
ComponentBuilder >> xValue: x [

	xValue := x
]

{ #category : #rendering }
ComponentBuilder >> yValue: y [

	yValue := y
]
