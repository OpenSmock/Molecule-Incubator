"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I am used so that the more complex shapes of the component's contract (its required part) can be correctly highlighted

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #ShapeIcon,
	#superclass : #Object,
	#instVars : [
		'icons'
	],
	#classInstVars : [
		'icons'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #accessing }
ShapeIcon class >> icons [

	<script: 'self icons inspect'>
	icons ifNil: [ icons := Dictionary new ].
	^ icons
]

{ #category : #accessing }
ShapeIcon class >> usedServiceIcon [

	<script: 'self usedServiceIcon inspect'>
	^ self icons at: #usedService ifAbsentPut: [
		  Form fromBinaryStream:
			  self usedServiceIconEncoding base64Decoded readStream ]
]

{ #category : #accessing }
ShapeIcon class >> usedServiceIconEncoding [

	^ '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'
]
