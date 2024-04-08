"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I am a subclass of RSBitmap (Roassal class that can display Forms, which are how images are imported into Pharo from the exterior) that is used to memorize the index of the component in the canvas I am located in.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	canvasIndex:		<Object>
	componentNumber:		<Object>


    Implementation Points
"
Class {
	#name : #MolFormShape,
	#superclass : #RSBitmap,
	#instVars : [
		'componentNumber',
		'canvasIndex'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #accessing }
MolFormShape >> componentNumber [

	^ componentNumber
]

{ #category : #accessing }
MolFormShape >> componentNumber: numberedComponent [

	componentNumber := numberedComponent
]
