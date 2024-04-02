"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I am a subclass of RSLabel used for the labels at the center of each component (its implementation class + what name it was stared with if there is one). I am used to still show these labels even when a component is hovered on (so that they aren't highlighted)

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
	#name : #MolCenterLabel,
	#superclass : #RSLabel,
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}
