Class {
	#name : #MolComponent,
	#superclass : #SpPresenter,
	#instVars : [
		'typeNameField',
		'parametersCheckBox',
		'typeName',
		'consumedEvents',
		'producedEvents',
		'consumedEventsFrame',
		'producedEventsFrame',
		'usedServicesFrame',
		'providedServicesFrame',
		'usedParametersFrame',
		'providedParametersFrame',
		'usedParameters',
		'providedParameters',
		'usedServices',
		'providedServices',
		'componentGraphic',
		'package',
		'parametersLayout',
		'usedParametersLabel',
		'providedParametersLabel',
		'eventText',
		'addOneTimeWarningIcon',
		'roleRequiredInterface',
		'roleOfferedInterface',
		'typeUsingInterface'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #TOREMOVE }
MolComponent >> addEventsServicesParameters: interface forFrame: interfaceFrame [
	"adds under an interface drop-down list its events, services or parameters"

	"clicking on one of them opens it in the System Browser"

	| eventServiceParameterS compiledMethod |
								 self flag:
									 'n arrive pas sur méthode dans system browser (dans class side, contrat), juste classe'.
	self flag:
		'comment les cacher avec flèche déroulante ?, espace entre services'.
	interfaceFrame ifNotNil: [
		eventServiceParameterS := interface methodDict.
		eventServiceParameterS do: [ :eventServiceParameter | "copyUpToSubstring: is used since eventServiceParameter also contains the content of the method"
			interfaceFrame
				add: (self newLink
						 label: (eventServiceParameter asString copyUpToSubstring:
									  Character cr asString);
						 action: [
							 compiledMethod := CompiledMethod new.
							 compiledMethod methodClass: interface.
							 compiledMethod selector: eventServiceParameter.
							 compiledMethod browse ])
				expand: false ] ]
]

{ #category : #TOREMOVE }
MolComponent >> checkboxParameters [
	"shows used and provided parameter interfaces if the checkbox is checked"

	"removes them when the checkbox is unchecked"

	parametersCheckBox state
		ifTrue: [
			self setUsedParameters.
			self setProvidedParameters ]
		ifFalse: [ self setEmptyParameters ]
]

{ #category : #TOREMOVE }
MolComponent >> connectPresenters [

	parametersCheckBox whenChangedDo: [ self checkboxParameters ]
	
]

{ #category : #TOREMOVE }
MolComponent >> createComponentGraphic [
	"shows in the upper right corner a representation of the component based on the Corba Component Model (its Type and interfaces with icons symbolizing what role they have based on the component contract)"

	self flag:
		'to do dans autre classe Pharo' 
		"typeName"
		"interfaceFrame ifNotNil: [
		interfaces do: [ :interface |
			eventServiceParameterS := interface methodDict.
			eventServiceParameterS do: [ :eventServiceParameter | ]"
]

{ #category : #TOREMOVE }
MolComponent >> defaultLayout [

	self flag: 'couleurs displayColor: [ :aClass |
(aClass name endsWith: ''Test'')
ifTrue: [ Color green ]'.
	self flag: 'editable selector'.
	self flag:
		'voir pour liste déroulante quand trop de trucs à afficher (LSHControllerCamera)'.
		self flag: 'typeNameField'.

	"first line, only column"
	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newVertical
				   add: 'Contract definition' expand: false;
				   add: 'Type name' expand: false;
				   add: typeNameField expand: false)
		  expand: false;
		  add: SpBoxLayout newLeftToRight width: 5;
		  "second line, first column"add: (SpBoxLayout newLeftToRight
			   add: (SpBoxLayout newVertical
					    add: 'Services' expand: false;
					    add: 'Used' expand: false;
					    add: usedServicesFrame expand: false;
					    add: 'Provided' expand: false;
					    add: providedServicesFrame expand: false)
			   expand: false;
			   add: SpBoxLayout newLeftToRight width: 5;
			   "second line, second column"add: (SpBoxLayout newVertical
					    add: 'Events' expand: false;
					    add: 'Consumed' expand: false;
					    add: consumedEventsFrame expand: false;
					    add: 'Produced' expand: false;
					    add: producedEventsFrame expand: false)
			   expand: false;
			   add: SpBoxLayout newLeftToRight width: 5;
			   "second line, third column, is not shown by default except if a parameter interface is detected"
			   add: (parametersLayout
					    add: 'Parameters' expand: false;
					    add: parametersCheckBox expand: false;
					    add: usedParametersLabel expand: false;
					    add: usedParametersFrame expand: false;
					    add: providedParametersLabel expand: false;
					    add: providedParametersFrame expand: false)
			   expand: false)
]

{ #category : #'as yet unclassified' }
MolComponent >> dropDownInterfaceAdd: interfaces forFrame: interfaceFrame roleInterface: roleInterface [
	"dynamically adds drop-down menus for the required or offered part of an interface"

	self flag: 'pas assez espacé'.
	self flag: 'usage'.
	self flag: 'trait icone'.
	self flag: 'warning à côté liste'.

	"adds every drop-down interface list as well as their events, parameters or services under them"
	"also adds a warning icon to the left of an interface if it's necessary"
	interfaces do: [ :interface | "warningArray := "
		interfaceFrame
			add: (self newDropList addItemLabeled: interface name do: [  ])
			expand: false.
		"add: (SpBoxLayout newLeftToRight
					 add: warningIcon;" ") 		expand: false)"

		self addEventsServicesParameters: interface forFrame: interfaceFrame.
		"self halt."
		self
			listTypesUsingInterface: interface
			forFrame: interfaceFrame
			roleInterface: roleInterface ]
]

{ #category : #TOREMOVE }
MolComponent >> initializeParameters [
	"shows used and provided parameter interfaces if a parameter interface is detected upon opening the window"

	providedParameters := typeName asClass allProvidedParameters.
	usedParameters := typeName asClass allUsedParameters.
	"self halt."

	(usedParameters isNotEmpty or: providedParameters isNotEmpty)
		ifTrue: [ parametersCheckBox state: true ]
]

{ #category : #TOREMOVE }
MolComponent >> initializePresenters [

	self flag: 'extent taille encadrés ?'.
	typeNameField := self newTextInput
		                 editable: false;
		                 yourself.

	"eventText := Morph new.
	eventText
		name: 'Events';
		color: Color lightCyan;
		yourself."
	"contents: pour StringMorph,backgroundColor:"

	roleRequiredInterface := 'requir'.
	roleOfferedInterface := 'offer'.

	parametersCheckBox := self newCheckBox.
	usedParametersLabel := self newLabel label: ''.
	providedParametersLabel := self newLabel label: ''.

	consumedEventsFrame := SpBoxLayout newVertical.
	producedEventsFrame := SpBoxLayout newVertical.
	usedServicesFrame := SpBoxLayout newVertical.
	providedServicesFrame := SpBoxLayout newVertical.
	usedParametersFrame := SpBoxLayout newVertical.
	providedParametersFrame := SpBoxLayout newVertical.

	parametersLayout := SpBoxLayout newVertical
]

{ #category : #'as yet unclassified' }
MolComponent >> interface: interface isUsedBy: type frame: interfaceFrame roleInterface: roleInterface [
	"checks if an interface is used by another Type located in the same package than the Type given"

	self flag:
		'doesn t work (molgeoposequipmentservices, molmylocaltimeevents) car boucle listTypesUsing... ne focntionne pas car lonelyInterface dans cette méthode'.
	"self halt."

	"if an interface is offered, checks if it's required through another Type"
	roleInterface = roleRequiredInterface ifTrue: [ "self halt."
		(type allConsumedEvents includes: interface) ifTrue: [
			typeUsingInterface := type ].

		(type allUsedServices includes: interface) ifTrue: [
			typeUsingInterface := type ].

		(type allUsedParameters includes: interface) ifTrue: [ "self halt."
			typeUsingInterface := type ] ].

	"if an interface is required, checks if it's offered through another Type"
	roleInterface = roleOfferedInterface ifTrue: [
		(type allProducedEvents includes: interface) ifTrue: [
			typeUsingInterface := type ].

		(type allProvidedParameters includes: interface) ifTrue: [
			typeUsingInterface := type ].

		(type allProvidedServices includes: interface) ifTrue: [
			typeUsingInterface := type ] ].

	^ typeUsingInterface
]

{ #category : #TOREMOVE }
MolComponent >> listTypesInPackage [
	"lists all the Type Traits in the current package"

	| typesInPackage classesInPackage |
	classesInPackage := package classes.

	"all those superclasses don't implement isComponentType"
	classesInPackage := classesInPackage select: [ :c |
		                    c superclass = Object = false and:
			                    (c superclass = MolAbstractComponentImpl
			                     = false and:
				                     c superclass = PackageManifest = false) ].
	typesInPackage := classesInPackage select: [ :c | c isComponentType ].
	^ typesInPackage
]

{ #category : #'as yet unclassified' }
MolComponent >> listTypesUsingInterface: interface forFrame: interfaceFrame roleInterface: roleInterface [
	"lists other traits that use the given interface by checking the contract of their Type (for the moment being)"

	| typesInPackage browsableType typeString |
	self flag: 'évolution Molecule implem a interfaces'.
	self flag: 'cherche uniquement dans même package'.
	self flag: 'typeUsingInterface peut être dans insterface offered by'.
	self flag:
		'n affiche pas plusieurs interface offertes (molmylocaltime)?'.

	typesInPackage := self listTypesInPackage.

	"addOneTimeWarningIcon is an instance variable used in order to only add one warning icon per interface that needs it"
	addOneTimeWarningIcon := false.

	"if a Type uses an interface, keep track of it"
	typesInPackage do: [ :type |
		typeUsingInterface := self
			                      interface: interface
			                      isUsedBy: type
			                      frame: interfaceFrame
			                      roleInterface: roleInterface ].

	"if the interface isn't declared in the contract of any other type, warns the user"
	typeUsingInterface ifNil: [
		addOneTimeWarningIcon ifFalse: [ "roleInterface describes if the interface isn't required of offered""self halt."
			self flag: 'a des problèmes (molmyclock)'.
			self
				warningIconAndTooltip: interface
				forFrame: interfaceFrame
				roleInterface: roleInterface.
			addOneTimeWarningIcon := true ] ].

	"shows the other Types on screen using an interface, which can be browsed by clicking on them"
	typeUsingInterface ifNotNil: [
		typeUsingInterface = interface ifFalse: [ "self halt."
			typeString := typeUsingInterface asString.
			browsableType := self newLink
				                 label:
					                 'Interface ' , roleInterface , 'ed by '
					                 , typeString;
				                 action: [ typeString asClass browse ];
				                 color: Color blue;
				                 yourself.
			interfaceFrame add: browsableType expand: false ] ]
]

{ #category : #TOREMOVE }
MolComponent >> setEmptyParameters [
	"removes the parameters when the checkbox is unchecked"

			usedParametersLabel label: ''.
			providedParametersLabel label: ''.

			providedParametersFrame removeAll.
			usedParametersFrame removeAll
]

{ #category : #TOREMOVE }
MolComponent >> setEvents [
	"sets the Event interfaces related to the Type"

	consumedEvents := typeName asClass allConsumedEvents.
	producedEvents := typeName asClass allProducedEvents.

	self
		dropDownInterfaceAdd: consumedEvents
		forFrame: consumedEventsFrame
		roleInterface: roleOfferedInterface.
	self
		dropDownInterfaceAdd: producedEvents
		forFrame: producedEventsFrame
		roleInterface: roleRequiredInterface
]

{ #category : #TOREMOVE }
MolComponent >> setProvidedParameters [
	"shows provided parameter interfaces if the checkbox is checked"

	providedParametersLabel label: 'Provided'.

	self
		dropDownInterfaceAdd: providedParameters
		forFrame: providedParametersFrame
		roleInterface: roleRequiredInterface
]

{ #category : #TOREMOVE }
MolComponent >> setServices [
	"sets the Service interfaces related to the Type"

	usedServices := typeName asClass allUsedServices.
	providedServices := typeName asClass allProvidedServices.

	self
		dropDownInterfaceAdd: usedServices
		forFrame: usedServicesFrame
		roleInterface: roleOfferedInterface.
	self
		dropDownInterfaceAdd: providedServices
		forFrame: providedServicesFrame
		roleInterface: roleRequiredInterface
]

{ #category : #TOREMOVE }
MolComponent >> setTypeName: aTypeName package: aPackage [
	"sets the Type name to its associated field, which triggers the showing of its interfaces"

	typeName := aTypeName.
	typeNameField text: typeName.
	package := aPackage.

	self setEvents.
	self setServices.
	self initializeParameters.
	self checkboxParameters.

	self createComponentGraphic
]

{ #category : #TOREMOVE }
MolComponent >> setUsedParameters [
	"shows used parameter interfaces if the checkbox is checked"

	usedParametersLabel label: 'Used'.

	self
		dropDownInterfaceAdd: usedParameters
		forFrame: usedParametersFrame
		roleInterface: roleOfferedInterface
]

{ #category : #TOREMOVE }
MolComponent >> title [

	^ 'Edit Molecule Component'
]

{ #category : #'as yet unclassified' }
MolComponent >> warningIconAndTooltip: anInterface forFrame: interfaceFrame roleInterface: roleInterface [
	"shows a warning icon and a tooltip (when the mouse cursor is on top of the icon)"

	"this tooltip details current problems with the interface, such as"

	"- not having any other Type using one of the declared interfaces (if an interface is declared as being in the usedServices part of the Type contract, it should be declared in another Type's providedServices part, otherwise it's worthless) "

	"- not having any event/parameter/service declared in an interface"

	| warningTooltip typeInterface |
	self flag:
		'appelé si interface vide mais déclaré dans autre composant ?'.
	warningTooltip := 'No Component is declared as ' , roleInterface
	                  , 'ing this interface !'.

	anInterface methodDict isEmpty ifTrue: [
		anInterface isComponentEvents ifTrue: [ typeInterface := 'Event' ].
		anInterface isComponentParameters ifTrue: [
			typeInterface := 'Parameter' ].
		anInterface isComponentServices ifTrue: [
			typeInterface := 'Service' ].

		warningTooltip := warningTooltip , '
		This ' , typeInterface , ' Trait has no ' , typeInterface
		                  , ' !' ].

	interfaceFrame add: (SpButtonPresenter new
			 icon: (self iconNamed: #warning);
			 help: warningTooltip)
	"extent: 10 @ 10;"
]
