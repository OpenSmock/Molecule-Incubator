Class {
	#name : #ComponentBuilder,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'box',
		'extent',
		'type',
		'implementation',
		'typeClass'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

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
	self flag: 'coordonnées relatives'.
	consumedEventText := RSLabel new
		                     text: (self showInterface: 'consumedEvent');
		                     yourself.
	consumedEventText translateTo: -200 @ 80.

	consumedEventShape := RSShapeFactory rightArrow
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: 30 @ 30;
		                      yourself.
	consumedEventShape translateTo: -110 @ 60.

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
	"generates the central box which represents the component as well as showing the name of the component"

	| component |
	self flag: 'texte dynamique, texte à intérieur box'.
	box := RSBox new
		       extent: 200 @ 200;
		       borderColor: Color black;
		       color: Color white;
		       yourself.
	box cornerRadius: 10.

	component := RSLabel new
		             text: implementation;
		             yourself.
	"component translateTo: 0 @ 0."

	canvas addShape: box.
	canvas addShape: component
]

{ #category : #rendering }
ComponentBuilder >> generateProducedEvents [
	"generates the produced Events part, which is composed of the produced event interfaces, the diamond shape and the line that links the box and the shape"

	| producedEventText producedEventShape line |
	self flag: 'coordonnées relatives'.
	producedEventText := RSLabel new
		                     text: (self showInterface: 'producedEvent');
		                     yourself.
	producedEventText translateTo: 200 @ 80.

	producedEventShape := RSShapeFactory diamond
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: 30 @ 30;
		                      yourself.
	producedEventShape translateTo: 130 @ 80.

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
	self flag: 'coordonnées relatives'.
	providedParameterText := RSLabel new
		                         text:
			                         (self showInterface: 'providedParameter');
		                         yourself.
	providedParameterText translateTo: 100 @ 160.

	providedParameterShape := RSBox new
		                          borderColor: Color black;
		                          color: Color white;
		                          extent: 30 @ 30;
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
ComponentBuilder >> generateProvidedServices [
	"generates the provided services part, which is composed of the provided service interfaces, the circle shape and the line that links the box and the shape"

	| providedServicesText providedServicesShape line |
	self flag: 'coordonnées relatives'.
	providedServicesText := RSLabel new
		                        text: (self showInterface: 'providedService');
		                        yourself.
	providedServicesText translateTo: 200 @ -50.

	providedServicesShape := RSCircle new
		                         borderColor: Color black;
		                         color: Color white;
		                         extent: 30 @ 30;
		                         yourself.
	providedServicesShape translateTo: 130 @ -50.

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

	| dot line typeLabel |
	dot := RSCircle new
		       extent: 30 @ 30;
		       color: Color black;
		       yourself.
	dot translateTo: 0 @ -150.

	typeLabel := RSLabel new
		             text: type asString;
		             yourself.
	typeLabel translateTo: 30 @ -150.

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
	self flag: 'coordonnées relatives'.
	usedParameterText := RSLabel new
		                     text: (self showInterface: 'usedParameter');
		                     yourself.
	usedParameterText translateTo: -60 @ 160.

	"usedParameterShape := RSShapeFactory fork
		                      borderColor: Color black;
		                      color: Color white;
		                      extent: 30 @ 30;
		                      yourself.
	usedParameterShape translateTo: -60 @ 130."
	usedParameterX := -40.
	usedParameterY := 115.
	usedServiceUpperLine := self
		                        createForkShape: usedParameterX
		                        and: usedParameterY.

	"usedServiceUpperLine can't be a RSLine since the from: to: of RSLine isn't applicable to herself"
	line := RSLine new
		        from: box;
		        "to: usedParameterShape;"to: usedServiceUpperLine;
		        color: Color black;
		        yourself.
	line attachPoint: RSBorderAttachPoint new.
	line update.

	canvas add: usedParameterText.
	"canvas add: usedParameterShape."
	canvas add: line
]

{ #category : #rendering }
ComponentBuilder >> generateUsedServices [
	"generates the used services part, which is composed of the used service interfaces, the half-empty circle shape and the line that links the box and the shape"

	| usedServicesText usedServicesShape line |
	self flag: 'coordonnées relatives, shape'.
	usedServicesText := RSLabel new
		                    text: (self showInterface: 'usedService');
		                    yourself.
	usedServicesText translateTo: -200 @ -50.

	usedServicesShape := RSShapeFactory halfEmptyRightCircle
		                     borderColor: Color black;
		                     color: Color white;
		                     extent: 30 @ 30;
		                     yourself.
	usedServicesShape cornerRadii: 10.
	usedServicesShape translateTo: -130 @ -50.

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

	implementation := aMoleculeImplementation.
	type :=  implementation allTraits at: 1.
]

{ #category : #rendering }
ComponentBuilder >> showComponent [

	self flag:
		'faire méthodes pour x et y value, textes dynamiques, composant plus petit pour fenêtre?, zoom'.

	canvas := RSCanvas new.

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
	"shows and formats the interfaces required and offered by a Component"

	| interfaces |
	anInterfaceString = 'producedEvent' ifTrue: [
		interfaces := type allProducedEvents ].
	anInterfaceString = 'providedParameter' ifTrue: [
		interfaces := type allProvidedParameters ].
	anInterfaceString = 'providedService' ifTrue: [
		interfaces := type allProvidedServices ].

	anInterfaceString = 'consumedEvent' ifTrue: [
		interfaces := type allConsumedEvents ].
	anInterfaceString = 'usedParameter' ifTrue: [
		interfaces := type allUsedParameters ].
	anInterfaceString = 'usedService' ifTrue: [
		interfaces := type allUsedServices ].

	interfaces = OrderedCollection new ifTrue: [ ^ '' ].
	interfaces size = 1 ifTrue: [ interfaces := interfaces at: 1 ].
	^ interfaces
]

{ #category : #rendering }
ComponentBuilder >> type: aMoleculeType [

	type := aMoleculeType.
]
