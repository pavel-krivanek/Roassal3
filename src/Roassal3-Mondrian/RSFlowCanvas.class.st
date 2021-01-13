Class {
	#name : #RSFlowCanvas,
	#superclass : #Object,
	#instVars : [
		'breadcrumbs',
		'breadcrumbsLabels',
		'canvas',
		'mapping',
		'breadcrumbsLabel'
	],
	#category : #'Roassal3-Mondrian-Flow'
}

{ #category : #accessing }
RSFlowCanvas >> breadcrumbs [
	^ breadcrumbs asArray
]

{ #category : #accessing }
RSFlowCanvas >> canvas [
	^ canvas
]

{ #category : #initialization }
RSFlowCanvas >> clickOnModel: aModel [

	"relevantSelectors := aModel class selectors select: [ :sel | sel beginsWith: 'visualize' ]."
	
	(mapping includesKey: aModel class) 
		ifTrue: [
			canvas shapes do: #remove.
			(mapping at: aModel class) value: canvas value: aModel.
			self setOnCanvas: canvas.
			
			 ].
	canvas signalUpdate.
	
	breadcrumbs add: aModel.
	self updateBreadcrumbs
]

{ #category : #initialization }
RSFlowCanvas >> initialize [

	super initialize.
	self initializeCanvas.
	mapping := Dictionary new.
	breadcrumbsLabels := RSGroup new.
	breadcrumbs := OrderedCollection new
]

{ #category : #initialization }
RSFlowCanvas >> initializeCanvas [

	canvas := RSCanvas new.
	breadcrumbsLabel := RSLabel new.
	canvas add: breadcrumbsLabel.
	breadcrumbsLabel setAsFixed.
"	self setBreadcrumbsLabel: '/'
"	

]

{ #category : #'instance creation' }
RSFlowCanvas >> open [
	^ canvas open
]

{ #category : #initialization }
RSFlowCanvas >> setBreadcrumbsLabel: aString [
	breadcrumbsLabel text: aString.
	breadcrumbsLabel translateTopLeftTo: 0 @ 0.
]

{ #category : #initialization }
RSFlowCanvas >> setOnCanvas: aCanvas [

	| relevantShapes |
	canvas := aCanvas.
	relevantShapes := aCanvas nodes select: [ :s | s model notNil ].
	relevantShapes when: RSMouseClick do: [ :evt |
		self clickOnModel: evt shape model ].
	

]

{ #category : #initialization }
RSFlowCanvas >> updateBreadcrumbs [

   breadcrumbsLabels do: #remove.
   breadcrumbsLabels := RSGroup new.
   breadcrumbs do: [ :obj |
	   | lbl |
	   lbl := RSLabel text: obj asString, '/ ' model: obj.
		breadcrumbsLabels add: lbl.
		lbl @ RSHighlightable red. 
		lbl when: RSMouseClick do: [ :evt | 
			| i |
			i := breadcrumbsLabels indexOf: lbl.
			breadcrumbs := breadcrumbs first: i - 1.
			
			self clickOnModel: lbl model ].
	].
   canvas addAll: breadcrumbsLabels.
   breadcrumbsLabels do: #setAsFixed.
   RSHorizontalLineLayout on: breadcrumbsLabels.

	breadcrumbsLabel translateTopLeftTo: 0 @ 0.
]

{ #category : #initialization }
RSFlowCanvas >> when: aClass visualize: twoArgsBlock [
	"twoArgsBlock follows [ :canvas :object | ... ]"
	mapping at: aClass put: twoArgsBlock
]