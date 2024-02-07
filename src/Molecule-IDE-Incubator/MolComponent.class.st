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
		'roleOfferedInterface'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #TOREMOVE }
MolComponent >> checkboxParameters [
	"shows used and provided parameter interfaces if the checkbox is checked"

	"removes them when the checkbox is unchecked"

	parametersCheckBox state
		ifTrue: [
			"self halt."
			self setUsedParameters.
			self setProvidedParameters ]
		ifFalse: [ self setEmptyParameters ]
]

{ #category : #TOREMOVE }
MolComponent >> connectPresenters [

	parametersCheckBox whenChangedDo: [ self checkboxParameters ].
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
	self flag: 'typeNameField a champ trop grand'.
	self flag: 'taille encadrés'.
	self flag: 'browse double-click ne fonctionne pas sur listes où services affichés ne correspondent pas à taille'.

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
					    add:
						    'Services                                                                        '
					    expand: false;
					    add: 'Used' expand: false;
					    add: usedServicesFrame expand: false;
					    add: 'Provided' expand: false;
					    add: providedServicesFrame expand: false)
			   expand: false;
			   add: SpBoxLayout newLeftToRight width: 5;
			   "second line, second column"add: (SpBoxLayout newVertical
					    add:
						    'Events                                                                         '
					    expand: false;
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
MolComponent >> deleteEventsServicesParameters: interface forFrame: interfaceFrame [
	"see addEventsServicesParameters: interface forFrame: interfaceFrame to know why the checked condition is fill ifFalse: "

	interfaceFrame children do: [ :eventServiceParameter |
		eventServiceParameter fill ifFalse: [ eventServiceParameter delete ] ]
]

{ #category : #TOREMOVE }
MolComponent >> initializeParameters [
	"shows used and provided parameter interfaces if a parameter interface is detected upon opening the window"

	providedParameters := typeName asClass allProvidedParameters.
	usedParameters := typeName asClass allUsedParameters.

	(usedParameters isNotEmpty or: providedParameters isNotEmpty)
		ifTrue: [ parametersCheckBox state: true ]
]

{ #category : #TOREMOVE }
MolComponent >> initializePresenters [

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

	| typeUsingInterface |

	"if an interface is offered, checks if it's required through another Type"
	roleInterface = roleRequiredInterface ifTrue: [
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

{ #category : #'as yet unclassified' }
MolComponent >> interfaceTreeAdd: interfaces forFrame: interfaceFrame roleInterface: roleInterface [
	"dynamically adds trees for the required or offered part of an interface"

	| interfaceTree compiledMethod eventServiceParameters |
	self flag: 'warning à côté liste'.
	self flag: 'children ont même children'.
	self flag: 'trait ou implem icone pour service individuel'.
	self flag: 'chaque interface est son arbre'.

	"adds every interface tree as well as their events, parameters or services under them"
	"also adds a warning icon to the left of an interface if it's necessary"
	"sorts the interfaces first"
	interfaces sort: [ :a :b | a name <= b name ].

	interfaces do: [ :interface | "warningArray := "
		"self halt."
		interfaceTree := self newTree
			                 children: [ :i | interface methodDict keys ];
			                 displayIcon: [ :aClass |
				                 self iconNamed: aClass systemIconName ];
			                 roots: { interface };
			                 expandRoots;
			                 beResizable;
			                 activateOnDoubleClick;
			                 whenActivatedDo: [ :eventServiceParameter |
				                 eventServiceParameter isTrait
					                 ifTrue: [
						                 eventServiceParameter selectedItem browse ]
					                 ifFalse: [
						                 compiledMethod := CompiledMethod new.
						                 compiledMethod methodClass: interface.
						                 compiledMethod selector: eventServiceParameter.
						                 compiledMethod browse ] ].
		interfaceFrame
			add: interfaceTree
			height: interface methodDict keys size + 1 * 20.
		"add: warningIcon;"

		self
			listTypesUsingInterface: interface
			forFrame: interfaceFrame
			roleInterface: roleInterface ]
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
	"lists other traits that use the given interface in the same package by checking the contract of their Type (for the moment being)"

	| typesInPackage browsableType typeString typesUsingInterface implementationTable typeUsingInterface |
	self flag: 'évolution Molecule implem a interfaces (changer texte)'.
	self flag: 'cherche uniquement dans même package'.
	self flag: 'typeUsingInterface peut être dans interface offered by'.
	self flag:
		'voir issue Molecule pour changer comment récupérer services'.
	self flag: 'tri pour table'.

	typesInPackage := self listTypesInPackage.
	typesUsingInterface := OrderedCollection new.

	"addOneTimeWarningIcon is an instance variable used in order to only add one warning icon per interface that needs it"
	addOneTimeWarningIcon := false.

	"if a Type uses an interface, keep track of it"
	typesInPackage do: [ :type |
		typeUsingInterface := self
			                      interface: interface
			                      isUsedBy: type
			                      frame: interfaceFrame
			                      roleInterface: roleInterface.
		typeUsingInterface class = UndefinedObject ifFalse: [
			typesUsingInterface add: typeUsingInterface ] ].

	"sort in order to have a display with the Traits in order"
	typesUsingInterface sort: [ :a :b | a name <= b name ].

	"if the interface isn't declared in the contract of any other type, warns the user"
	typesUsingInterface = OrderedCollection new
		ifTrue: [
			addOneTimeWarningIcon ifFalse: [ "roleInterface describes if the interface isn't required of offered""self halt."
				self flag: 'a des problèmes (molmyclock)'.
				self
					warningIconAndTooltip: interface
					forFrame: interfaceFrame
					roleInterface: roleInterface.
				addOneTimeWarningIcon := true ] ]
		ifFalse: [ "shows the other Types on screen using an interface, which can be browsed by clicking on them""shows their number if there is more than one implementation""typeUsingInterface = interface"
			browsableType := self newLink label:
				                 'Interface ' , roleInterface , 'ed by '.
			typesUsingInterface size > 1 ifTrue: [
				browsableType := browsableType , typesUsingInterface size asString
				                 , ' Traits'.
				implementationTable := self newTable
					                       addColumn:
						                       ((SpImageTableColumn evaluated: [ :aClass |
								                         self iconNamed: aClass systemIconName ])
							                        width: 30);
					                       addColumn:
						                       (SpStringTableColumn evaluated: [ :each |
								                        each ]);
					                       items: typesUsingInterface;
					                       hideColumnHeaders;
					                       activateOnDoubleClick;
					                       whenActivatedDo: [ :eventServiceParameter |
						                       eventServiceParameter selectedItem browse ].
				interfaceFrame add: browsableType expand: false.
				interfaceFrame
					add: implementationTable
					height: typesUsingInterface size * 20.
				"adds space for when an interface is used by other components and other interfaces are shown next in its respective interfaceFrame"
				interfaceFrame add: SpBoxLayout newVertical width: 50 ].
			typesUsingInterface size = 1 ifTrue: [
				[
				typeString := typesUsingInterface at: 1 asString.
				browsableType := browsableType
					                 , typeString;
					                 action: [ typeString asClass browse ];
					                 color: Color blue;
					                 yourself.
				interfaceFrame add: browsableType expand: false ] ] ]
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
		interfaceTreeAdd: consumedEvents
		forFrame: consumedEventsFrame
		roleInterface: roleOfferedInterface.
	self
		interfaceTreeAdd: producedEvents
		forFrame: producedEventsFrame
		roleInterface: roleRequiredInterface
]

{ #category : #TOREMOVE }
MolComponent >> setProvidedParameters [
	"shows provided parameter interfaces if the checkbox is checked"

	providedParametersLabel label: 'Provided'.

	self
		interfaceTreeAdd: providedParameters
		forFrame: providedParametersFrame
		roleInterface: roleRequiredInterface
]

{ #category : #TOREMOVE }
MolComponent >> setServices [
	"sets the Service interfaces related to the Type"

	usedServices := typeName asClass allUsedServices.
	providedServices := typeName asClass allProvidedServices.

	self
		interfaceTreeAdd: usedServices
		forFrame: usedServicesFrame
		roleInterface: roleOfferedInterface.
	self
		interfaceTreeAdd: providedServices
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

	self createComponentGraphic
]

{ #category : #TOREMOVE }
MolComponent >> setUsedParameters [
	"shows used parameter interfaces if the checkbox is checked"

	usedParametersLabel label: 'Used'.

	self
		interfaceTreeAdd: usedParameters
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
