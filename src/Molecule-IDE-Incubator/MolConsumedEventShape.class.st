"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I'm a subclass of MolFormShape. I'm necessary since being a subclass allows me to know that the redConsumedEventIcon needs to be displayed whenever the cursor is on me or any other shape linked to me.

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
	#name : #MolConsumedEventShape,
	#superclass : #MolFormShape,
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}
