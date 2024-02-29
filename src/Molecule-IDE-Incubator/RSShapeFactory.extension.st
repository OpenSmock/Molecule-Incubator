Extension { #name : #RSShapeFactory }

{ #category : #'*Molecule-IDE-Incubator' }
RSShapeFactory class >> fork [

	| t t1 |
	self flag: 'relie tous points'.
	t := 2 / 6 asFloat.
	t1 := t negated.
	^ self polygonWithPoints: {
			  (-1 @ 0).
			  (-4 @ 0).
			  (-4 @ 1).
			  (2 @ 0).
			  (2 @ 1) }
]

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

	^ self polygonWithPoints: {
			  (-2 @ 2).
			  (-2 @ 1.5).
			  (-1.5 @ 1).
			  (-2 @ 0.5).
			  (-2 @ 0).
			  (-1 @ 1) }
]