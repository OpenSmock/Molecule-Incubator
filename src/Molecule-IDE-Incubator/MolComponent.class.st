"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I display the interfaces required and offered by a Molecule Type and by what other Type they're also used. I'm accessible by right-clicking a Molecule Type -> Molecule -> Edit Component Type.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	componentRepresentation:		<Object>
	componentTypeText:		<Object>
	consumedEventFrame:		<Object>
	consumedEvents:		<Object>
	package:		<Object>
	parameterCheckboxRechecked:		<Object>
	parameterLayout:		<Object>
	parametersCheckBox:		<Object>
	producedEventFrame:		<Object>
	producedEvents:		<Object>
	providedParameterChildren:		<Object>
	providedParameterFrame:		<Object>
	providedParameterLabel:		<Object>
	providedParameterPresenter:		<Object>
	providedParameters:		<Object>
	providedServiceFrame:		<Object>
	providedServices:		<Object>
	roleOfferedInterface:		<Object>
	roleRequiredInterface:		<Object>
	scrollableUsedServicesPresenter:		<Object>
	typeName:		<Object>
	typeNameField:		<Object>
	usedParameterChildren:		<Object>
	usedParameterFrame:		<Object>
	usedParameterLabel:		<Object>
	usedParameterPresenter:		<Object>
	usedParameters:		<Object>
	usedServiceFrame:		<Object>
	usedServices:		<Object>


    Implementation Points
"
Class {
	#name : #MolComponent,
	#superclass : #SpPresenter,
	#instVars : [
		'typeNameField',
		'parametersCheckBox',
		'typeName',
		'consumedEvents',
		'producedEvents',
		'consumedEventFrame',
		'providedServiceFrame',
		'providedParameterFrame',
		'usedParameters',
		'providedParameters',
		'usedServices',
		'providedServices',
		'package',
		'roleRequiredInterface',
		'roleOfferedInterface',
		'scrollableUsedServicesPresenter',
		'componentTypeText',
		'componentRepresentation',
		'usedParameterFrame',
		'usedParameterLabel',
		'usedServiceFrame',
		'providedParameterLabel',
		'producedEventFrame',
		'providedParameterPresenter',
		'parameterLayout',
		'providedParameterChildren',
		'usedParameterChildren',
		'usedParameterPresenter',
		'parameterCheckboxRechecked'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #TOREMOVE }
MolComponent >> addBackLayouts: parameterChildren forPresenter: parameterPresenter [
	"used to add the parameter layouts after they've been deleted from unchecking the checkbox"

	"parameters use presenters that contain layouts since it isn't possible in Spec to add dynamically layouts"

	| parameterChildrenLayout |
	parameterChildrenLayout := SpBoxLayout newVertical.
	self flag: 'interfaces et méthodes non dépliées'.

	parameterChildren ifNotNil: [ "self halt."
		parameterChildren do: [ :child |
			child class = SpBoxLayout ifTrue: [ "self halt."
				child children do: [ :grandChild | "self halt."
					grandChild class = ByteString ifFalse: [
						grandChild children do: [ :greatGrandChild |
							greatGrandChild class = SpTreePresenter ifTrue: [ "self halt."
								greatGrandChild expandRoots.
								greatGrandChild expandPath: #( 1 ) ] ] ] ] ].
			parameterChildrenLayout add: child expand: false ].

		parameterPresenter layout: parameterChildrenLayout ]
]

{ #category : #TOREMOVE }
MolComponent >> checkboxParameters [
	"shows used and provided parameter interfaces if the checkbox is checked"

	"removes them when the checkbox is unchecked"

	parametersCheckBox state
		ifTrue: [
			self setProvidedParameters.
			self setUsedParameters. ]
		ifFalse: [ self setEmptyParameters ]
]

{ #category : #TOREMOVE }
MolComponent >> componentRepresentationTab [
	"used to define the second tab of the window, which shows a graphical representation of the component based on the Corba Component Model (its Type and interfaces with icons symbolizing what role they have based on its component contract)"

	"MolDiagram new"
	^ SpTextPresenter new
		  text: 'to do';
		  beNotEditable;
		  yourself
]

{ #category : #TOREMOVE }
MolComponent >> componentTypeTab [
	"used to define the first tab of the window, which shows the interfaces of the component (events, parameters and services)"

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
						    usedServiceFrame
					    expand: false;
					    add: 'Provided' expand: false;
					    add: providedServiceFrame expand: false;
					    yourself)
			   expand: true;
			   add: SpBoxLayout newLeftToRight expand: false;
			   "second line, second column"add: (SpBoxLayout newVertical
					    add: 'Events' expand: false;
					    add: 'Consumed' expand: false;
					    add: consumedEventFrame expand: false;
					    add: 'Produced' expand: false;
					    add: producedEventFrame expand: false;
					    yourself)
			   expand: true;
			   add: SpBoxLayout newLeftToRight width: 5;
			   "second line, third column, is not shown by default except if a parameter interface is detected"
			   add: (parameterLayout
					    add: 'Parameters' expand: false;
					    add: parametersCheckBox expand: false;
					    add: usedParameterLabel expand: false;
					    add: usedParameterFrame expand: false;
					    add: providedParameterLabel expand: false;
					"providedParameterFrame"
					    add: providedParameterPresenter expand: false;
					    yourself)
			   expand: true;
			   yourself);
		  yourself
]

{ #category : #TOREMOVE }
MolComponent >> connectPresenters [

	parametersCheckBox whenChangedDo: [ self checkboxParameters ].
]

{ #category : #TOREMOVE }
MolComponent >> defaultLayout [
	"only defines the tabs, with each of them executing their code"

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
	self flag: 'plus possible d enlever et remettre paramètres'.
	self flag:
		'regarder comment spec examples est codé pour liste à gauche sppresenter collect'.

	^ SpBoxLayout newTopToBottom add: (SpTabLayout new
			   add: componentTypeText label: 'Component Type';
			   add: componentRepresentation label: 'Component Representation';
			   yourself)
]

{ #category : #'as yet unclassified' }
MolComponent >> deleteEventsServicesParameters: interface forFrame: interfaceFrame [
	"see addEventsServicesParameters: interface forFrame: interfaceFrame to know why the checked condition is fill ifFalse: "
	self flag: 'unused ?'.

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

	(consumedEventsBoolean or:
		 (usedParametersBoolean or: usedServicesBoolean))
		ifTrue: [ ^ roleOfferedInterface ]
		ifFalse: [ ^ roleRequiredInterface ]
]

{ #category : #TOREMOVE }
MolComponent >> initialExtent [

	self flag: 'dynamique ?'.

	^ 600 @ 450
]

{ #category : #TOREMOVE }
MolComponent >> initializeParameters [
	"shows used and provided parameter interfaces if a parameter interface is detected upon opening the window"

	(usedParameters isNotEmpty or: providedParameters isNotEmpty)
		ifTrue: [ parametersCheckBox state: true ]
]

{ #category : #TOREMOVE }
MolComponent >> initializePresenters [

	self flag: 'to clean'.

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
	usedParameterLabel := self newLabel label: ''.
	providedParameterLabel := self newLabel label: ''.

	consumedEventFrame := SpBoxLayout newVertical.
	producedEventFrame := SpBoxLayout newVertical.
	usedServiceFrame := SpBoxLayout newVertical.
	providedServiceFrame := SpBoxLayout newVertical.
	usedParameterFrame := SpBoxLayout newVertical.
	providedParameterFrame := SpBoxLayout newVertical.

	scrollableUsedServicesPresenter := SpPresenter new.

	parameterLayout := SpBoxLayout newVertical.
	providedParameterPresenter := self newPresenter.
	providedParameterPresenter layout: providedParameterFrame.
	usedParameterPresenter := self newPresenter.
	usedParameterPresenter layout: usedParameterFrame.

	parameterCheckboxRechecked := false
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
	self flag: 'children ont même children methodDict'.
	self flag: 'trait ou implem icone pour service individuel'.
	self flag:
		'chaque interface est son arbre (impossible de scroller quand beaucoup d interfaces pour une partie required ou offered), voir scrollable layout spec2 demo, ajouter une super-classe temporaire par le code? à rajouter dans sppresenter, pas de add: layout, pas un problème car Interface required by en dessous de chaque, section entière (usedServices...)?'.
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
			                 children: [ :i | "interface methodDict keys
					                 ifEmpty: [  ]
					                 ifNotEmpty: ["
				                 interface methodDict keys "]" ];
			                 displayIcon: [ :aClass |
				                 self iconNamed: aClass systemIconName ];
			                 roots: { interface };
			                 expandRoots;
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

		self flag: 'bug paramètres check, voir discord'.
		interfaceLayout := SpBoxLayout newLeftToRight.
		interfaceUsedBoolean ifTrue: [
			interfaceLayout add: warningIcon width: 30 ].
		"height property is only applied for vertical layouts, so nesting this one is needed"
		interfaceLayout add: (SpBoxLayout newTopToBottom
				 add: interfaceTree
				 height: interface methodDict keys size + spacingNumber * 20).

		"(interface asString includesSubstring: 'Parameter')
			ifTrue: ["
		"attributes the layout to the presenter if it's a Parameter interface (done this way in order since layouts can't be added dynamically and it needs to be removed when the checkbox is unchecked""interfaceFrame layout: interfaceLayout ]""ifFalse: [""adds the interface to the designated frame if it's an Event or Service interface"
		interfaceFrame add: interfaceLayout expand: false. "]"

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

	| typesInPackage browsableType typesUsingInterface implementationTable typeUsingInterface spacingNumber browsableTypeLabel |
	self flag: 'évolution Molecule implem a interfaces (changer texte)'.
	self flag: 'cherche uniquement dans même package'.
	self flag:
		'voir issue Molecule pour changer comment récupérer services'.
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

	browsableTypeLabel := 'Interface ' , roleInterface , 'ed by '.
	"used so that it doesn't show a text like Interface offered by 0 Trait"
	typesUsingInterface isEmpty ifTrue: [ ^ self ].

	browsableTypeLabel := browsableTypeLabel
	                      , typesUsingInterface size asString , ' Trait'.

	typesUsingInterface size = 1 ifFalse: [
		browsableTypeLabel := browsableTypeLabel , 's' ].
	browsableType := SpBoxLayout newVertical add:
		                 (self newLink label: browsableTypeLabel).

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

	typesUsingInterface size < 3
		ifTrue: [ spacingNumber := 1 ]
		ifFalse: [ spacingNumber := 0 ].

	interfaceFrame add: browsableType expand: false.

	interfaceFrame
		add: implementationTable
		height: typesUsingInterface size + spacingNumber * 20.

	"marks a separation between implementationTable and the next interface"
	interfaceFrame add: SpBoxLayout newVertical height: 10
]

{ #category : #TOREMOVE }
MolComponent >> setEmptyParameters [
	"removes the parameters shown on screen when the checkbox is unchecked"

	| children |
	self flag: 'clean'.
	providedParameterLabel label: ''.
	usedParameterLabel label: ''.

	parameterCheckboxRechecked := true.

	providedParameterChildren ifNil: [
		providedParameterChildren := providedParameterFrame children ].
	"self halt."
	"deleting the child elements of providedParameterFrame also delete the ones of providedParameterFrameCopy. As such, it's necessary to copy them and add them after the deletion'"
	"childLayouts"
	"providedParameterFrame removeAll."
	providedParameterPresenter layout removeAll.
	"self halt."
	usedParameterFrame removeAll
]

{ #category : #TOREMOVE }
MolComponent >> setEvents [
	"sets the Event interfaces related to the Type"

	self
		interfaceTreeAdd: consumedEvents
		forFrame: consumedEventFrame
		roleInterface: roleOfferedInterface.

	self
		interfaceTreeAdd: producedEvents
		forFrame: producedEventFrame
		roleInterface: roleRequiredInterface
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

	providedParameterLabel label: 'Provided'.

	parameterCheckboxRechecked
		ifTrue: [
			self
				addBackLayouts: providedParameterChildren
				forPresenter: providedParameterPresenter ]
		ifFalse: [
			self
				interfaceTreeAdd: providedParameters
				forFrame: providedParameterFrame
				roleInterface: roleRequiredInterface ]
]

{ #category : #TOREMOVE }
MolComponent >> setServices [
	"sets the Service interfaces related to the Type"
 self
		                   interfaceTreeAdd: usedServices
		                   forFrame: usedServiceFrame
		                   roleInterface: roleOfferedInterface.
	"scrollableUsedServicesPresenter layout: usedServicesTree."
	self
		                       interfaceTreeAdd: providedServices
		                       forFrame: providedServiceFrame
		                       roleInterface: roleRequiredInterface
	"providedServicesFrame add: providedServicesTree"
]

{ #category : #TOREMOVE }
MolComponent >> setTabs [

	componentTypeText := self componentTypeTab.

	componentRepresentation := self componentRepresentationTab.
	componentRepresentation beNotEditable
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
	
self setTabs
]

{ #category : #TOREMOVE }
MolComponent >> setUsedParameters [
	"shows used parameter interfaces if the checkbox is checked"

	usedParameterLabel label: 'Used'.

	parameterCheckboxRechecked
		ifTrue: [
			self
				addBackLayouts: usedParameterChildren
				forPresenter: usedParameterPresenter ]
		ifFalse: [
			self
				                     interfaceTreeAdd: usedParameters
				                     forFrame: usedParameterFrame
				                     roleInterface: roleOfferedInterface ]
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
