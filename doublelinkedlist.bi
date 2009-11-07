''
'' Provides a generic (datatype Any Ptr) double linked list.
''
'' @author Tapio Vierros

	'' Internal list node.
	Type DoubleLinkedListNode
		nextNode 	As DoubleLinkedListNode Ptr 	= 0
		prevNode 	As DoubleLinkedListNode Ptr 	= 0
		nodeData 	As Any Ptr				= 0
	End Type

	'' Double linked list.
	Type DoubleLinkedList
		firstNode 		As DoubleLinkedListNode Ptr = 0
		lastNode 		As DoubleLinkedListNode Ptr = 0
		iteratorNode 	As DoubleLinkedListNode Ptr = 0
		
		itemCount		As UInteger
		
		Declare Destructor()
		Declare Sub add				(_item As Any Ptr)
		Declare Sub remove			(_item As Any Ptr)
		Declare Function contains	(_item As Any Ptr) As Integer
		
		Declare Function initIterator	() As Any Ptr
		Declare Function getNext		() As Any Ptr
		Declare Function getPrev		() As Any Ptr
	End Type

''	Destroys the list and its nodes, but not the contents of the data pointers.
	Destructor DoubleLinkedList()
		Var iterNode = this.firstNode
		While iterNode <> 0
			Var nextNode = iterNode->nextNode
			Delete iterNode
			iterNode = nextNode
		Wend
	End Destructor


''	Adds an item to the front of the list.
''	@param _item As Any Ptr - a pointer to the data-to-be-stored.
	Sub DoubleLinkedList.add(_item As Any Ptr)
		Var newNode = New DoubleLinkedListNode
		newNode->nodeData = _item
		newNode->nextNode = this.firstNode
		this.firstNode = newNode
		this.itemCount += 1
	End Sub


''	Removes an item from the list.
''	@param _item As Any Ptr - a pointer to the data-to-be-removed.
	Sub DoubleLinkedList.remove(_item As Any Ptr)
		Var iterNode = this.firstNode
		Dim prevNode As DoubleLinkedListNode Ptr = 0
		While iterNode <> 0
			If iterNode->nodeData = _item Then
				If prevNode <> 0 Then
					prevNode->nextNode = iterNode->nextNode
				Else
					this.firstNode = iterNode->nextNode
				EndIf
				Delete iterNode
				this.itemCount -= 1
				Return
			EndIf
			prevNode = iterNode
			iterNode = iterNode->nextNode
		Wend
	End Sub


''	Returns non-zero if the list contains the given item.
''	@param _item As Any Ptr a pointer to the data-to-be-searched-for.
	Function DoubleLinkedList.contains(_item As Any Ptr) As Integer
		Var iterNode = this.firstNode
		While iterNode <> 0
			If iterNode->nodeData = _item Then Return (Not 0)
			iterNode = iterNode->nextNode
		Wend
		Return 0
	End Function


''	Initializes iteration cycle and returns first node.
	Function DoubleLinkedList.initIterator() As Any Ptr
		this.iteratorNode = this.firstNode
		Return this.getNext()
	End Function


''	Gets the next node in list in the iteration started by initIterator.
	Function DoubleLinkedList.getNext() As Any Ptr
		If this.iteratorNode = 0 Then Return 0
		Function = this.iteratorNode->nodeData
		this.iteratorNode = this.iteratorNode->nextNode
	End Function
	
''	Gets the prev node in list in the iteration started by initIterator.
	Function DoubleLinkedList.getPrev() As Any Ptr
		If this.iteratorNode = 0 Then Return 0
		If this.iteratorNode->prevNode = 0 Then Return 0
		Function = this.iteratorNode->prevNode->nodeData
		If this.iteratorNode <> 0 Then this.iteratorNode = this.iteratorNode->nextNode
	End Function
