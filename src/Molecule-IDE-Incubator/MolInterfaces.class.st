Class {
	#name : #MolInterfaces,
	#superclass : #MolOptions,
	#instVars : [
		'selectedInterface',
		'requiredList',
		'offeredList',
		'dropList',
		'typeInterface',
		'servicesProvidedList',
		'eventsConsumedList',
		'parametersUsedList',
		'servicesUsedList',
		'eventsProducedList',
		'parametersProvidedList',
		'listImplementationBoth',
		'eventsConsumed',
		'parametersUsed',
		'servicesUsed',
		'eventsProduced',
		'parametersProvided',
		'servicesProvided',
		'implemList',
		'menuList'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #initialization }
MolInterfaces >> addTrait: trait IfInterfaceCorrespondsIn: interfaceList forList: interfaceForScreenList [
	"adds the interfaces that appear in the relevant parts of the component contract to lists in order to show them after using requiredList and offeredList"

	interfaceList ifNotNil: [
		interfaceList do: [ :interface |
			interface = selectedInterface ifTrue: [
				interfaceForScreenList add: trait ] ] ]
]

{ #category : #adding }
MolInterfaces >> addTypesInInterfaceLists [
	"Add the implementations in the lists corresponding to the different parts of their component contract"

	| trait |
	selectedInterface = '' ifFalse: [ "if the Trait is using the selected interface, adds it to the corresponding column"
		implemList do: [ :implem | "only way to get the Types are by getting their implementations"
			trait := (implem asString withoutSuffix: 'Impl') asClass.
			"self halt."
			self flag:
				'code à changer avec nouvelle méthode Molecule Interface -> Trait, implem ne finissent pas par Impl'.

			typeInterface = 'Events' ifTrue: [
				eventsConsumed := trait allConsumedEvents.
				self
					addTrait: trait
					IfInterfaceCorrespondsIn: eventsConsumed
					forList: eventsConsumedList.

				eventsProduced := trait allProducedEvents.
				self
					addTrait: trait
					IfInterfaceCorrespondsIn: eventsProduced
					forList: eventsProducedList ].

			typeInterface = 'Parameters' ifTrue: [
				parametersUsed := trait allUsedParameters.
				self
					addTrait: trait
					IfInterfaceCorrespondsIn: parametersUsed
					forList: parametersUsedList.

				parametersProvided := trait allProvidedParameters.
				self
					addTrait: trait
					IfInterfaceCorrespondsIn: parametersProvided
					forList: parametersProvidedList ].

			typeInterface = 'Services' ifTrue: [
				servicesUsed := trait allUsedServices.
				self
					addTrait: trait
					IfInterfaceCorrespondsIn: servicesUsed
					forList: servicesUsedList.

				servicesProvided := trait allProvidedServices.
				self
					addTrait: trait
					IfInterfaceCorrespondsIn: servicesProvided
					forList: servicesProvidedList ] ] ]
]

{ #category : #'as yet unclassified' }
MolInterfaces >> andMode [
	"if a Type appears in both columns (is both required and offered), show it in both columns"
	"doesn't show it in either if it only appears once"

	self emptyLists.

	self addTypesInInterfaceLists.

	self require: eventsConsumedList andOffer: eventsProducedList.
	self require: parametersUsedList andOffer: parametersProvidedList.
	self require: servicesUsedList andOffer: servicesProvidedList.

	self fillRequiredAndOfferedLists.

	self applyFilter
]

{ #category : #initialization }
MolInterfaces >> applyFilter [
	"used when changing boolean operator modes in order to conserve the filters typed, for both the required and offered interfaces"

	| requiredListFilter offeredListFilter |
	requiredList ifNotNil: [
		requiredListFilter := requiredList filterText.
		offeredListFilter := offeredList filterText.

		requiredList applyFilter: requiredListFilter.
		offeredList applyFilter: offeredListFilter ]
]

{ #category : #initialization }
MolInterfaces >> buttonBrowseAction [
	"an implementation needs to be selected in order to browse it. The last selected one (for both lists) being the one browsed"

	| item |
	item := implementationList selectedItem.
	item ifNotNil: [ item browse ]
]

{ #category : #initialization }
MolInterfaces >> connectPresenters [
	"enables the Browse button if a Type is selected, disables it if another mode is chosen since the lists are reset and the selection could point to nothing in particular"

	dropList whenSelectionChangedDo: [ buttonBrowse disable ].

	self enableBrowseButton: requiredList.
	self enableBrowseButton: offeredList
]

{ #category : #initialization }
MolInterfaces >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: 'Component Types which are using this interface:'
		  expand: false;
		  add: dropList expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: (SpBoxLayout newVertical
						    add: 'Required' expand: false;
						    add: requiredList;
						    yourself);
				   add: SpBoxLayout newLeftToRight width: 5 yourself;
				   add: (SpBoxLayout newVertical
						    add: 'Offered' expand: false;
						    add: offeredList;
						    yourself);
				   yourself);
		  addLast: actionBar;
		  yourself
]

{ #category : #initialization }
MolInterfaces >> determineTypeInterface [
	"determines the type of the selected interface (Events, Parameters or Services) using the relevant Molecule methods (isComponent[Events/Parameters/Services])"

	| events parameters services |
	events := 'Events'.
	parameters := 'Parameters'.
	services := 'Services'.

	selectedInterface isComponentEvents ifTrue: [
		typeInterface := events ].
	selectedInterface isComponentParameters ifTrue: [
		typeInterface := parameters ].
	selectedInterface isComponentServices ifTrue: [
		typeInterface := services ]
]

{ #category : #initialization }
MolInterfaces >> emptyLists [
	"since the implementations change when switching from one boolean operator to another, the lists of implementations need to be reset"

	"is also used to initialize them since this method is called at the start of required[And/Or/Xor]OfferedMode"

	eventsConsumedList := OrderedCollection new.
	parametersUsedList := OrderedCollection new.
	servicesUsedList := OrderedCollection new.

	eventsProducedList := OrderedCollection new.
	parametersProvidedList := OrderedCollection new.
	servicesProvidedList := OrderedCollection new.

	listImplementationBoth := OrderedCollection new
]

{ #category : #initialization }
MolInterfaces >> enableBrowseButton: listOnScreen [
	"determines which list was the last one selected, necessary for using the Browse button"

	listOnScreen whenSelectionChangedDo: [
		implementationList := listOnScreen.
		listOnScreen selectedItem ifNotNil: [ buttonBrowse enable ] ]
]

{ #category : #'as yet unclassified' }
MolInterfaces >> fillRequiredAndOfferedLists [

	requiredList items: listImplementationBoth.
	offeredList items: listImplementationBoth
]

{ #category : #initialization }
MolInterfaces >> initializePresenters [

	"Required OR Offered selected by default in the drop down list"

	super initializePresenters.

		"set to a placeholder value since the name of the interface is given after in execute: in the contextual menu side of things (MolInspectInterfaceImplementationsCmdCommand)"
	selectedInterface := ''.

	eventsConsumedList := OrderedCollection new.
	parametersUsedList := OrderedCollection new.
	servicesUsedList := OrderedCollection new.

	eventsProducedList := OrderedCollection new.
	parametersProvidedList := OrderedCollection new.
	servicesProvidedList := OrderedCollection new.

	"drop list, no width property"
	dropList := self newDropList
		            help: 'Component Types which are using this interface:';
		            addItemLabeled: 'Required OR Offered'
		            do: [ self orMode ];
		            addItemLabeled: 'Required AND Offered'
		            do: [ self andMode ];
		            addItemLabeled: 'Required XOR Offered'
		            do: [ self xorMode ].

	requiredList := SpFilteringListDoubleClickPresenter new.
	requiredList
		displayIcon: [ :elem | self iconNamed: elem systemIconName ];
		contextMenu: [ self listMenu ].

	offeredList := SpFilteringListDoubleClickPresenter new.
	offeredList
		displayIcon: [ :elem | self iconNamed: elem systemIconName ];
		contextMenu: [ self listMenu ]
]

{ #category : #initialization }
MolInterfaces >> interface: anInterface [
	"when an interface is given, loads the filtering lists"

	"only one interface can be selected at a time"

	selectedInterface := anInterface.
	self determineTypeInterface.
	implemList := self listImplementations: anInterface.

	self orMode
]

{ #category : #initialization }
MolInterfaces >> interfaceListAssignment: interfaceList for: listOnScreen [
	"adds the Types to a list if they are required or offered by the selected interface"

	listOnScreen ifNotNil: [
		interfaceList = OrderedCollection new ifFalse: [
			listOnScreen items: interfaceList ] ]
]

{ #category : #initialization }
MolInterfaces >> listMenu [

	^ self newMenu addItem: [ :item |
		  item
			  name: 'See Component Implementations';
			  icon: (self iconNamed: #package);
			  help: 'Shows implementations of this Molecule Type';
			  action: [ self seeComponentImplementations ] ]
]

{ #category : #'as yet unclassified' }
MolInterfaces >> orMode [
	"if an implementation requires or provides the selected interface, make it appear in the correct column"

	"is selected by default"

	self emptyLists.

	self addTypesInInterfaceLists.

	self requireOrOffer.

	self applyFilter
]

{ #category : #'as yet unclassified' }
MolInterfaces >> require: listRequired andOffer: listOffered [
		"adds the items in the lists shown on screen if the interface is both required and offered by an implementation"

	listRequired do: [ :interfaceRequired |
		listOffered do: [ :interfaceOffered |
			interfaceRequired = interfaceOffered ifTrue: [
				listImplementationBoth add: interfaceRequired ] ] ]
]

{ #category : #'as yet unclassified' }
MolInterfaces >> require: listRequired xorOffer: listOffered [
	"removes the items in the lists shown on screen if the interface is both required and offered by an implementation"

	listRequired do: [ :interfaceRequired |
		listOffered do: [ :interfaceOffered |
			interfaceRequired = interfaceOffered ifTrue: [
				listRequired remove: interfaceRequired.
				listOffered remove: interfaceRequired ] ] ]
]

{ #category : #'as yet unclassified' }
MolInterfaces >> requireOrOffer [
	"adds the items in the lists shown on screen if the interface is required or offered by a Type"

	self interfaceListAssignment: eventsConsumedList for: requiredList.
	self interfaceListAssignment: parametersUsedList for: requiredList.
	self interfaceListAssignment: servicesUsedList for: requiredList.

	self interfaceListAssignment: eventsProducedList for: offeredList.
	self interfaceListAssignment: parametersProvidedList for: offeredList.
	self interfaceListAssignment: servicesProvidedList for: offeredList
]

{ #category : #initialization }
MolInterfaces >> seeComponentImplementations [
	"code based on the execute method in MolInspectTypeImplementationsCmdCommand without the multiple selection part since multiple elements can't be chosen at the same time in requiredList and offeredList"

	| selectedType implem |
	selectedType := implementationList selectedItem.
	implem := MolImplementations new.

	selectedType isComponentType ifTrue: [
		implem type: selectedType.
		implem open ]
]

{ #category : #initialization }
MolInterfaces >> title [

	^ selectedInterface asString , ' ' , typeInterface asLowercase
]

{ #category : #'as yet unclassified' }
MolInterfaces >> xorMode [
	"OR minus AND, show a Type only if it exists and doesn't appear in both columns (requires or offers the interface, but not both)"

	self emptyLists.

	"adds the interfaces"
	self addTypesInInterfaceLists.

	"removes implementations that both require and offer this interface"
	self require: eventsConsumedList xorOffer: eventsProducedList.
	self require: servicesUsedList xorOffer: servicesProvidedList.
	self require: parametersUsedList xorOffer: parametersProvidedList.

	"adds the interfaces in requiredList and offeredList"
	self requireOrOffer.

	self applyFilter
]