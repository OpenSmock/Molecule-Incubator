"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I am a subclass of RSBox used to know which component I pertain to. This is used when hovering over a component's main box (the big one) in order to highlight ever yinterface shape and label it has (see highlightComponent)

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	componentNumber:		<Object>


    Implementation Points
"
Class {
	#name : #MolBoxComponent,
	#superclass : #RSBox,
	#instVars : [
		'componentNumber'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #accessing }
MolBoxComponent >> componentNumber [

	^ componentNumber
]

{ #category : #accessing }
MolBoxComponent >> componentNumber: numberedComponent [

	componentNumber := numberedComponent
]
