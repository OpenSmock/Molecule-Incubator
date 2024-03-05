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

	| lineThickness usedServiceUpperLine usedServiceLowerLeftLine usedServiceLowerRightLine lineLength  |
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
	usedServiceLowerLeftLine translateTo:
		usedParameterX - 30 @ usedParameterY + 10.

	usedServiceLowerRightLine := RSBox new
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

	| consumedEventText consumedEventShape line |
	consumedEventText := RSLabel new
		                     text: (self showInterface: 'consumedEvent');
		                     yourself.
	consumedEventText translateTo: -220 @ yEvent.

	consumedEventShape := RSShapeFactory rightArrow
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: shapeExtent;
		                      yourself.
	consumedEventShape translateTo: -110 @ yEvent - 20.

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

	| producedEventText producedEventShape line |
	producedEventText := RSLabel new
		                     text: (self showInterface: 'producedEvent');
		                     yourself.
	producedEventText translateTo: 220 @ yEvent.

	producedEventShape := RSShapeFactory diamond
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: shapeExtent;
		                      yourself.
	producedEventShape translateTo: 130 @ yEvent.

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
MolComponentBuilder >> generateProvidedParameters [
	"generates the provided parameters part, which is composed of the provided parameter interfaces, the square shape and the line that links the box and the shape"

	| providedParameterText providedParameterShape line |
	providedParameterText := RSLabel new
		                         text:
			                         (self showInterface: 'providedParameter');
		                         yourself.
	providedParameterText translateTo: 100 @ yParameter.

	providedParameterShape := RSBox new
		                          borderColor: Color black;
		                          color: Color white;
		                          extent: shapeExtent;
		                          yourself.
	providedParameterShape translateTo: 60 @ 130.

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
MolComponentBuilder >> generateProvidedServices [
	"generates the provided services part, which is composed of the provided service interfaces, the circle shape and the line that links the box and the shape"

	| providedServicesText providedServicesShape line |
	providedServicesText := RSLabel new
		                        text:
			                        (self showInterface: 'providedService');
		                        yourself.
	providedServicesText translateTo: 220 @ yService.

	providedServicesShape := RSEllipse new
		                         borderColor: Color black;
		                         color: Color white;
		                         extent: shapeExtent;
		                         yourself.
	providedServicesShape translateTo: 130 @ yService.

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
MolComponentBuilder >> generateType [
	"generates the black dot above the component as well as showing the Type of the component"

	| dot line typeLabel yType |
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
MolComponentBuilder >> generateUsedParameters [
	"generates the used parameters part, which is composed of the used parameter interfaces, the fork shape and the line that links the box and the shape"

	| usedParameterText line usedServiceUpperLine usedParameterY usedParameterX |
	usedParameterText := RSLabel new
		                     text: (self showInterface: 'usedParameter');
		                     yourself.
	usedParameterText translateTo: -60 @ yParameter.

	usedParameterX := -40.
	usedParameterY := 115.
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
MolComponentBuilder >> generateUsedServices [
	"generates the used services part, which is composed of the used service interfaces, the half-empty circle shape and the line that links the box and the shape"

	| usedServicesText usedServicesShape line |
	self flag: 'shape'.
	usedServicesText := RSLabel new
		                    text: (self showInterface: 'usedService');
		                    yourself.
	usedServicesText translateTo: -200 @ yService.

	usedServicesShape := RSShapeFactory halfEmptyRightCircle
		                     borderColor: Color black;
		                     color: Color white;
		                     extent: shapeExtent;
		                     yourself.
	usedServicesShape cornerRadii: 10.
	usedServicesShape translateTo: -130 @ yService.

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
MolComponentBuilder >> showInterface: anInterfaceString [
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
