Extension { #name : #MolWorld }

{ #category : #'*Molecule-IDE-Incubator' }
MolWorld class >> menu15VisualizeRunningComponents: aBuilder [

	<worldMenu>
	| componentVisualizer canvas |
	(aBuilder item: #VisualizeRunningComponents)
		parent: #MoleculeStatus;
		order: 1.0;
		action: [
			MolComponentManager isRunningComponents
				ifTrue: [ "Visualize running components"
					componentVisualizer := MolComponentVisualizer new.
					canvas := componentVisualizer canvas.
					componentVisualizer window: canvas open ]
				ifFalse: [ "No components are running"
					self inform: 'No components are running' ] ];
		icon: MolIcon moleculeIcon;
		help:
			'Visualize through diagrams running components and their links';
		label: 'Visualize running Components'
]

{ #category : #'*Molecule-IDE-Incubator' }
MolWorld class >> menu211InspectOn: aBuilder [

	<worldMenu>
	(aBuilder item: #Inspect)
		parent: #MoleculeIncubator;
		label: 'Browse all Component classes';
		help:
			'Browse hierarchy Component classes (not from augmented class)';
		icon: (self iconNamed: 'glamorousInspect');
		action: [ 
			| spMolSearch |
			spMolSearch := SpMolInspect new.
			spMolSearch open ]
]

{ #category : #'*Molecule-IDE-Incubator' }
MolWorld class >> menu212SearchOn: aBuilder [

	<worldMenu>
	(aBuilder item: #Search)
		parent: #MoleculeIncubator;
		label: 'Search';
		help: 'Open tools to search Components';
		icon: (self iconNamed: 'glamorousSearch');
		action: [ 
			| spMolSearch |
			spMolSearch := MolSearchPresenter new.
			spMolSearch open ]
]

{ #category : #'*Molecule-IDE-Incubator' }
MolWorld class >> menu213CreateOn: aBuilder [

	<worldMenu>
	(aBuilder item: #Create)
		parent: #MoleculeIncubator;
		label: 'Component editor A';
		help: 'Open Component editor A to create new Components';
		icon: MolIcon moleculeIcon;
		action: [ 
			| spMolCreate |
			spMolCreate := SpMolCreateComponent new.
			spMolCreate open ]
]

{ #category : #'*Molecule-IDE-Incubator' }
MolWorld class >> menu214EditorBOn: aBuilder [

	<worldMenu>
	(aBuilder item: #Editor)
		parent: #MoleculeIncubator;
		label: 'Component editor B';
		help: 'Open Component editor B to create new Components';
		icon: MolIcon moleculeIcon;
		action: [MolViewSpace openTest]
]

{ #category : #'*Molecule-IDE-Incubator' }
MolWorld class >> menu21IncubatorOn: aBuilder [
	<worldMenu>
	(aBuilder item: #MoleculeIncubator)
		parent: #MoleculeTools;
		order: 3.0;
		label: 'Incubator tools';
		help: 'Find tools for component in development';
		icon: MolIcon moleculeIncubatorIcon 
]

{ #category : #'*Molecule-IDE-Incubator' }
MolWorld class >> toolsMenu120NewComponent: aBuilder [

	<worldMenu>
	(aBuilder item: #MoleculeClearComponent)
		parent: #MoleculeDebug;
		order: 12.0;
		icon: (self iconNamed: #smallUpdate);
		action: [ MolNewComponentLibraryPresenter new open ];
		label: 'New Component';
		help:
			'Define a new Molecule Component by selecting a package and its (optional) tag'
]
