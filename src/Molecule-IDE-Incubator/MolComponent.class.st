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
		'scrollableUsedServicesPresenter'
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
	self flag: 'voir molexamplecomponent moleculegui-tests'.
	self flag:
		'possible de rendre tables non scrollables? withoutScrollBars ne fonctionne pas'.
	self flag: 'parametersLayout pas utile'.
	self flag: 'yourself ne changent rien'.

	"first line, only column"
	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newVertical
				   add: 'Contract definition' expand: false;
				   add: (SpBoxLayout newLeftToRight
						    add: 'Type name' expand: false;
						    add: typeNameField expand: true;
						    yourself)
				   expand: false;
				   yourself)
		  expand: false;
		  add: SpBoxLayout newLeftToRight width: 5;
		  "second line, first column"add: (SpBoxLayout newLeftToRight
			   add: (SpBoxLayout newVertical
					    add: 'Services' expand: false;
					    add: 'Used' expand: false;
					    "add: scrollableUsedServicesPresenter expand: false;"add:
						    usedServicesFrame
					    expand: false;
					    add: 'Provided' expand: false;
					    add: providedServicesFrame expand: false;
					    yourself)
			   expand: true;
			   add: SpBoxLayout newLeftToRight expand: false;
			   "second line, second column"add: (SpBoxLayout newVertical
					    add: 'Events' expand: false;
					    add: 'Consumed' expand: false;
					    add: consumedEventsFrame expand: false;
					    add: 'Produced' expand: false;
					    add: producedEventsFrame expand: false;
					    yourself)
			   expand: true;
			   add: SpBoxLayout newLeftToRight width: 5;
			   "second line, third column, is not shown by default except if a parameter interface is detected"
			   add: (parametersLayout
					    add: 'Parameters' expand: false;
					    add: parametersCheckBox expand: false;
					    add: usedParametersLabel expand: false;
					    add: usedParametersFrame expand: false;
					    add: providedParametersLabel expand: false;
					    add: providedParametersFrame expand: false;
					    yourself)
			   expand: false;
			   yourself) yourself
]

{ #category : #'as yet unclassified' }
MolComponent >> deleteEventsServicesParameters: interface forFrame: interfaceFrame [
	"see addEventsServicesParameters: interface forFrame: interfaceFrame to know why the checked condition is fill ifFalse: "

	interfaceFrame children do: [ :eventServiceParameter |
		eventServiceParameter fill ifFalse: [ eventServiceParameter delete ] ]
]

{ #category : #TOREMOVE }
MolComponent >> determineRoleInterface: interface [
	"used in order to search in the relevant parts of the contracts of the Types using an interface (for a required interface, it will search in the offered parts of a component's contract)"

	| consumedEventsBoolean usedParametersBoolean usedServicesBoolean |
	consumedEventsBoolean := consumedEvents includes: interface.
	usedParametersBoolean := usedParameters includes: interface.
	usedServicesBoolean := usedServices includes: interface.

	"self halt."
	(consumedEventsBoolean or:
		 (usedParametersBoolean or: usedServicesBoolean))
		ifTrue: [ ^ roleOfferedInterface ]
		ifFalse: [ ^ roleRequiredInterface ]
]

{ #category : #TOREMOVE }
MolComponent >> initializeParameters [
	"shows used and provided parameter interfaces if a parameter interface is detected upon opening the window"

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
	
		scrollableUsedServicesPresenter := SpPresenter new.

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

	| interfaceTree compiledMethod interfacesTree spacingNumber warningIcon interfaceUsedBoolean interfaceLayout |
	self flag: 'children ont même children'.
	self flag: 'trait ou implem icone pour service individuel'.
	self flag:
		'chaque interface est son arbre (impossible de scroller quand beaucoup d interfaces pour une partie required ou offered), voir scrollable layout spec2 demo, ajouter une super-classe temporaire par le code?'.

	"adds every interface tree as well as their events, parameters or services under them"
	"also adds a warning icon to the left of an interface if it's necessary"
	"sorts the interfaces first"
	interfaces sort: [ :a :b | a name <= b name ].
	interfacesTree := SpBoxLayout newVertical.

	interfaces do: [ :interface | "if a required interface is not offered by another type (the contrary also applies), warns the user"
		interfaceUsedBoolean := self
			                        isInterfaceUsed: interface
			                        forFrame: interfaceFrame
			                        roleInterface: roleInterface.
		interfaceUsedBoolean ifTrue: [
			warningIcon := self
				               warningNoOtherUsage: interface
				               forFrame: interfaceFrame
				               roleInterface:
				               (self determineRoleInterface: interface) ].

		interfaceTree := self newTree
			                 children: [ :i | interface methodDict keys ];
			                 displayIcon: [ :aClass |
				                 self iconNamed: aClass systemIconName ];
			                 roots: { interface };
			                 expandRoots;
			                 withoutScrollBars;
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
		"interfacesTree add: interfaceTree expand: false."
		"a tree table needs a certains amount of space (enough to show 3 elements) in order to be correctly browsable"
		interface methodDict keys size = 1
			ifTrue: [ spacingNumber := 2 ]
			ifFalse: [ spacingNumber := 1 ].

		interfaceLayout := SpBoxLayout newLeftToRight.
		interfaceUsedBoolean ifTrue: [
			interfaceLayout add: warningIcon width: 30 ].
		"height property is only applied for vertical layouts, so nesting this one is needed"
		interfaceLayout add: (SpBoxLayout newTopToBottom
				 add: interfaceTree
				 height: interface methodDict keys size + spacingNumber * 20).

		interfaceFrame add: interfaceLayout expand: false.

		self
			listTypesUsingInterface: interface
			forFrame: interfaceFrame
			roleInterface: roleInterface ].

	^ interfacesTree
]

{ #category : #'as yet unclassified' }
MolComponent >> isInterfaceUsed: interface forFrame: interfaceFrame roleInterface: roleInterface [
	"this method is used to determine if a required interface is offered in another Type and vice-versa"

	| typesInPackage typesUsingInterface typeUsingInterface |
	typesInPackage := self listTypesInPackage.
	typesUsingInterface := OrderedCollection new.

	typesInPackage do: [ :type |
		typeUsingInterface := self
			                      interface: interface
			                      isUsedBy: type
			                      frame: interfaceFrame
			                      roleInterface: roleInterface.
		typeUsingInterface class = UndefinedObject ifFalse: [
			typesUsingInterface add: typeUsingInterface ] ].

	^ typesUsingInterface = OrderedCollection new
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

	| typesInPackage browsableType typesUsingInterface implementationTable typeUsingInterface spacingNumber |
	self flag: 'évolution Molecule implem a interfaces (changer texte)'.
	self flag: 'cherche uniquement dans même package'.
	self flag:
		'voir issue Molecule pour changer comment récupérer services'.
	self flag:
		'Pas de texte interface consumed by lshmemory lshhomemanagercomponent'.
	typesInPackage := self listTypesInPackage.
	typesUsingInterface := OrderedCollection new.

	typesInPackage do: [ :type |
		typeUsingInterface := self
			                      interface: interface
			                      isUsedBy: type
			                      frame: interfaceFrame
			                      roleInterface: roleInterface.
		typeUsingInterface class = UndefinedObject ifFalse: [
			typesUsingInterface add: typeUsingInterface ] ].

	typesUsingInterface sort: [ :a :b | a name <= b name ].

	browsableType := self newLink label:
		                 'Interface ' , roleInterface , 'ed by '.
	"used in order so that it doesn't show a text like Interface offered by 0 Trait"
	typesUsingInterface isEmpty ifTrue: [ ^ self ].

	browsableType := browsableType , typesUsingInterface size asString
	                 , ' Trait'.

	typesUsingInterface size = 1 ifFalse: [
		browsableType := browsableType , 's' ].
	"self halt."

	implementationTable := self newTable
		                       addColumn:
			                       ((SpImageTableColumn evaluated: [ :aClass |
					                         self iconNamed: aClass systemIconName ])
				                        width: 20);
		                       addColumn:
			                       (SpStringTableColumn evaluated: #name);
		                       items: typesUsingInterface;
		                       hideColumnHeaders;
		                       activateOnDoubleClick;
		                       withoutScrollBars;
		                       whenActivatedDo: [ :eventServiceParameter |
			                       eventServiceParameter selectedItem browse ].

	interfaceFrame add: browsableType expand: false.

	typesUsingInterface size < 3
		ifTrue: [ spacingNumber := 1 ]
		ifFalse: [ spacingNumber := 0 ].

	interfaceFrame
		add: implementationTable
		height: typesUsingInterface size + spacingNumber * 20.

	interfaceFrame add: SpBoxLayout newVertical width: 50
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

	| consumedEventsTree producedEventsTree |
	"consumedEvents := typeName asClass allConsumedEvents.
	producedEvents := typeName asClass allProducedEvents."

	consumedEventsTree := self
		                      interfaceTreeAdd: consumedEvents
		                      forFrame: consumedEventsFrame
		                      roleInterface: roleOfferedInterface.
	"consumedEventsFrame add: consumedEventsTree."
	producedEventsTree := self
		                      interfaceTreeAdd: producedEvents
		                      forFrame: producedEventsFrame
		                      roleInterface: roleRequiredInterface
	"producedEventsFrame add: producedEventsTree"
]

{ #category : #TOREMOVE }
MolComponent >> setInterfaces [
	"sets the interfaces of the current Type"

	consumedEvents := typeName asClass allConsumedEvents.
	producedEvents := typeName asClass allProducedEvents.
	
		providedParameters := typeName asClass allProvidedParameters.
	usedParameters := typeName asClass allUsedParameters.

	usedServices := typeName asClass allUsedServices.
	providedServices := typeName asClass allProvidedServices
]

{ #category : #TOREMOVE }
MolComponent >> setProvidedParameters [
	"shows provided parameter interfaces if the checkbox is checked"

	| providedParametersTree |
	providedParametersLabel label: 'Provided'.

	providedParametersTree := self
		                          interfaceTreeAdd: providedParameters
		                          forFrame: providedParametersFrame
		                          roleInterface: roleRequiredInterface.
	"providedParametersFrame add: providedParametersTree"
]

{ #category : #TOREMOVE }
MolComponent >> setServices [
	"sets the Service interfaces related to the Type"

	| usedServicesTree providedServicesTree |
	"usedServices := typeName asClass allUsedServices.
	providedServices := typeName asClass allProvidedServices."

	usedServicesTree := self
		                    interfaceTreeAdd: usedServices
		                    forFrame: usedServicesFrame
		                    roleInterface: roleOfferedInterface.
	"scrollableUsedServicesPresenter layout: usedServicesTree."
	providedServicesTree := self
		                        interfaceTreeAdd: providedServices
		                        forFrame: providedServicesFrame
		                        roleInterface: roleRequiredInterface
	"providedServicesFrame add: providedServicesTree"
]

{ #category : #TOREMOVE }
MolComponent >> setTypeName: aTypeName package: aPackage [
	"sets the Type name to its associated field, which triggers the showing of its interfaces"

	typeName := aTypeName.
	typeNameField text: typeName.
	package := aPackage.
	
	self setInterfaces.

	self setEvents.
	self setServices.
	self initializeParameters.

	"self halt."
	"self showWarningIcons."

	self createComponentGraphic
]

{ #category : #TOREMOVE }
MolComponent >> setUsedParameters [
	"shows used parameter interfaces if the checkbox is checked"

	| usedParametersTree |
	usedParametersLabel label: 'Used'.

	usedParametersTree := self
		                      interfaceTreeAdd: usedParameters
		                      forFrame: usedParametersFrame
		                      roleInterface: roleOfferedInterface.
	"self halt"
	"usedParametersFrame add: usedParametersTree"
]

{ #category : #'as yet unclassified' }
MolComponent >> showWarningIcons [
	"if an interface isn't used as it should, warns the user"
	self flag: 'unused'.

	consumedEvents = OrderedCollection new ifFalse: [
		self
			warningNoOtherUsage: consumedEvents
			forFrame: consumedEventsFrame
			roleInterface: roleOfferedInterface ].
	producedEvents = OrderedCollection new ifFalse: [
		self
			warningNoOtherUsage: producedEvents
			forFrame: producedEventsFrame
			roleInterface: roleRequiredInterface ].

	usedServices = OrderedCollection new ifFalse: [
		self
			warningNoOtherUsage: usedServices
			forFrame: usedServicesFrame
			roleInterface: roleOfferedInterface ].
	providedServices = OrderedCollection new ifFalse: [
		self
			warningNoOtherUsage: providedServices
			forFrame: providedServicesFrame
			roleInterface: roleRequiredInterface ].

	usedParameters = OrderedCollection new ifFalse: [
		self
			warningNoOtherUsage: usedParameters
			forFrame: usedParametersFrame
			roleInterface: roleRequiredInterface ].
	providedParameters = OrderedCollection new ifFalse: [
		self
			warningNoOtherUsage: providedParameters
			forFrame: providedParametersFrame
			roleInterface: roleRequiredInterface ]
]

{ #category : #TOREMOVE }
MolComponent >> title [

	^ 'Edit Molecule Component'
]

{ #category : #'as yet unclassified' }
MolComponent >> warningNoEventServiceParameter: interface forFrame: interfaceFrame roleInterface: roleInterface [
	"shows a warning icon and a tooltip (when the mouse cursor is on top of the icon)"

	"this tooltip details current problems with the interface (see warningNoOtherUsage for the first one)"

	"in this method is known if an interface has no event/parameter/service"

	| typeInterface |
	interface methodDict size = 0 ifFalse: [ ^ self ].

	interface isComponentEvents ifTrue: [ typeInterface := 'Event' ].
	interface isComponentParameters ifTrue: [
		typeInterface := 'Parameter' ].
	interface isComponentServices ifTrue: [ typeInterface := 'Service' ].

	^ '
		This ' , typeInterface , ' Trait has no ' , typeInterface , ' !'
]

{ #category : #'as yet unclassified' }
MolComponent >> warningNoOtherUsage: interface forFrame: interfaceFrame roleInterface: roleInterface [
	"shows a warning icon and a tooltip (when the mouse cursor is on top of the icon)"

	"this tooltip details current problems with the interface (see warningNoOtherUsage for the first one)"

	"if an interface is required by a Type but not offered by another and vice-versa, warns the user"

	| warningTooltip warningButton |
	warningTooltip := 'No Component is declared as ' , roleInterface
	                  , 'ing this interface !' , (self
		                   warningNoEventServiceParameter: interface
		                   forFrame: interfaceFrame
		                   roleInterface: roleInterface).

	warningButton := SpButtonPresenter new
		                 icon: (self iconNamed: #warning);
		                 help: warningTooltip.

	^ warningButton
]
