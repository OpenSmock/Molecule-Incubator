Extension { #name : #RSShapeFactory }

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> halfEmptyRightCircle [

	| t t1 |
	t := 2 / 6 asFloat.
	t1 := t negated.
	^ self polygonWithPoints: {
			  (-2 @ 2).
			  (-2 @ 1.5).
			  (-1 @ 1).
			  (-2 @ 0.5).
			  (-2 @ 0).
			  (0 @ 1) }
]

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> rightArrow [

	^ self rightArrowWithPoints: {
			  (-2 @ 2).
			  (-2 @ 1).
			  (-1.5 @ 0).
			  (-2 @ -1).
			  (-2 @ -2).
			  (0 @ 0) } "self polygonWithPoints: {
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

	^ RightArrowShape new
		  privatePoints: points;
		  yourself
]
