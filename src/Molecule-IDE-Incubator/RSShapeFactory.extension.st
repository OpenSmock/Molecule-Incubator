Extension { #name : #RSShapeFactory }

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> fork [

	self flag: 'unused'.
	^ MolFork new "self forkWithPoints: {
			  (-1 @ 0).
			  (0 @ 0).
			  (1 @ 0.1) }"
]

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> forkWithPoints: points [
	"make it so that its superclass isn't RSPolygon and thus can create the shape to be compared to other interface shapes"
	self flag: 'unused'.

	^ MolFork new
		  privatePoints: points;
		  yourself
]

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> halfEmptyRightCircle [

	| mValue |
	mValue := 100.

	^ self polygonWithPoints: {
			  (-2 * mValue @ (2 * mValue)).
			  (-2 * mValue @ (1.5 * mValue)).
			  (-1 @ 1).
			  (-2 * mValue @ (0.5 * mValue)).
			  (-2 * mValue @ 0).
			  (0 @ 1) }
	"(-2 @ 2).
			  (-2 @ 1.5).
			  (-1 @ 1).
			  (-2 @ 0.5).
			  (-2 @ 0).
			  (0 @ 1)"
]

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> rightArrow [

	| mValue |
	mValue := 100.

	^ self rightArrowWithPoints: {
			  (-2 * mValue @ (2 * mValue)).
			  (-2 * mValue @ 1).
			  (-1.5 * mValue @ 0).
			  (-2 * mValue @ -1).
			  (-2 * mValue @ (-2 * mValue)).
			  (-1 @ 0)
			  "(-2 @ 2).
			  (-2 @ 1).
			  (-1.5 @ 0).
			  (-2 @ -1).
			  (-2 @ -2).
			  (0 @ 0)" } "self polygonWithPoints: {
			  (-2 @ 2).
			  (-2 @ 1.5).
			  (-1.5 @ 1).
			  (-2 @ 0.5).
			  (-2 @ 0).
			  (-1 @ 1) }"
]

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> rightArrowWithPoints: points [
	"make it so that its superclass isn't RSPolygon and thus can create the shape to be compared to other interface shapes"

	^ MolRightArrowShape new
		  privatePoints: points;
		  yourself
]
