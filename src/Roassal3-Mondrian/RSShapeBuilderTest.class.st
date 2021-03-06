Class {
	#name : #RSShapeBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'b'
	],
	#category : #'Roassal3-Mondrian-Tests'
}

{ #category : #running }
RSShapeBuilderTest >> setUp [
	super setUp.
	b := RSShapeBuilder new
]

{ #category : #tests }
RSShapeBuilderTest >> testBox [

	| result |
	b box.
	result := b shapesOn: #(1 2).
	self assert: result class equals: RSGroup.
	self assert: result size equals: 2.
	self assert: (result allSatisfy: [ :s | s class == RSBox ]).
	self assert: (result collect: #model) asArray equals: #(1 2)
]

{ #category : #tests }
RSShapeBuilderTest >> testCircle [

	| result |
	b circle.
	result := b shapesOn: #(1 2).
	self assert: result class equals: RSGroup.
	self assert: result size equals: 2.
	self assert: (result allSatisfy: [ :s | s class == RSEllipse ]).
	self assert: (result collect: #model) asArray equals: #(1 2)
]

{ #category : #tests }
RSShapeBuilderTest >> testLabel [

	| result |
	b label.
	result := b shapesOn: #(1 2).
	self assert: result class equals: RSGroup.
	self assert: result size equals: 2.
	self assert: (result allSatisfy: [ :s | s class == RSLabel ]).
	self assert: (result collect: #model) asArray equals: #(1 2)
]

{ #category : #tests }
RSShapeBuilderTest >> testLabel2 [

	| result |
	b label.
	self assert: b width isNil.
	self assert: b height isNil.
	
	result := b shapesOn: #(1 20000).
	
	self assert: b width isNil.
	self assert: b height isNil.
	
	self assert: result class equals: RSGroup.
	self assert: result size equals: 2.
	self assert: (result allSatisfy: [ :s | s class == RSLabel ]).
	self assert: (result collect: #model) asArray equals: #(1 20000).
	
	self assert: result first width < result second width
]

{ #category : #tests }
RSShapeBuilderTest >> testWithBorder [

	| result shape |
	self assert: b borderColor isNil.
	self assert: b borderWidth isNil.
	
	b circle withBorder.
	self assert: b borderColor equals: Color black.
	self assert: b borderWidth equals: 3.
	
	result := b shapesOn: #(1).
	
	self assert: b borderColor equals: Color black.
	self assert: b borderWidth equals: 3.
	
	self assert: result class equals: RSGroup.
	self assert: result size equals: 1.
	
	self assert: (result allSatisfy: [ :s | s class == RSEllipse ]).
	self assert: (result collect: #model) asArray equals: #(1).
	
	shape := result first.
	self assert: shape border notNil.
]
