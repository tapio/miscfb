'' Trie Data Structure
''
'' Stores data that is accessed via string keys.
'' Can be used as a replacement for associative arrays.
'' Generic Any Ptr version is provided by default.
'' Use DeclareTrieType(_datatype) to create more.
'' E.g. 
''			DeclareTrieType(String)
'' Gives StringTrie -structure, which stores strings.
''
'' About trie-structure in general:
''  * Fast O(1) search, add and delete 
''		(more precicely O(m), where m is the length of the key)
''  * Similar string keys are stored efficiently
''
'' This implementation is NOT thread safe.
''
'' @author Tapio Vierros


#Define TRIE_CHAR_ARRAY_LBOUND 32
#Define TRIE_CHAR_ARRAY_RBOUND 126

Type TrieNode
	children(TRIE_CHAR_ARRAY_LBOUND To TRIE_CHAR_ARRAY_RBOUND) As TrieNode Ptr
	data As Any Ptr = 0
	
	Declare Destructor()
End Type

	Destructor TrieNode()
		For i As Integer = TRIE_CHAR_ARRAY_LBOUND To TRIE_CHAR_ARRAY_RBOUND
			Delete children(i)
		Next i
	End Destructor


Type Trie
	rootNode As TrieNode Ptr
	
	Declare Constructor()
	Declare Destructor()
	
	Declare Sub add(_key As String, _data As Any Ptr)
	Declare Sub remove(_key As String)
	Declare Function get(_key As String) As Any Ptr
	Declare Function getString(_key As String) As String
	Declare Function contains(_key As String) As Integer
End Type

	Constructor Trie()
		this.rootNode = New TrieNode
	End Constructor
	
	
	Destructor Trie()
		Delete this.rootNode
	End Destructor

	'' METHOD: add
	Sub Trie.add(_key As String, _data As Any Ptr)
		Var iNode = this.rootNode
		Dim As UInteger stlen = Len(_key)
		For i As UInteger = 1 To stlen
			If iNode->children(_key[i]) = 0 Then 
				iNode->children(_key[i]) = New TrieNode
			EndIf
			iNode = iNode->children(_key[i])
		Next i	
		iNode->data = _data
	End Sub
	
	'' METHOD: remove
	Sub Trie.remove(_key As String)
		Var iNode = this.rootNode
		Dim As UInteger stlen = Len(_key)
		For i As UInteger = 1 To stlen
			iNode = iNode->children(_key[i])
			If iNode = 0 Then Return
		Next i
		iNode->data = 0
	End Sub
	
	'' METHOD: get
	Function Trie.get(_key As String) As Any Ptr
		Var iNode = this.rootNode
		Dim As UInteger stlen = Len(_key)
		For i As UInteger = 1 To stlen
			iNode = iNode->children(_key[i])
			If iNode = 0 Then Return 0
		Next i
		Return iNode->data
	End Function
	
	'' METHOD: getString
	Function Trie.getString(_key As String) As String
		Return *CPtr(String Ptr, this.get(_key))
	End Function
	
	'' METHOD: contains
	Function Trie.contains(_key As String) As Integer
		Return this.get(_key) <> 0
	End Function


'' CLASS: Trie
#Macro DeclareTrieType(_TRIE_DATA_TYPE_)

	#IfNDef __##_TRIE_DATA_TYPE_##_TRIE
	
	#Define __##_TRIE_DATA_TYPE_##_TRIE
	
	Dim Shared _TRIE_DATA_TYPE_##_TRIE_DEFAULT_VALUE As _TRIE_DATA_TYPE_

	Type _TRIE_DATA_TYPE_##TrieNode
		children(TRIE_CHAR_ARRAY_LBOUND To TRIE_CHAR_ARRAY_RBOUND) As _TRIE_DATA_TYPE_##TrieNode Ptr
		data As _TRIE_DATA_TYPE_
		
		Declare Destructor()
	End Type

		Destructor _TRIE_DATA_TYPE_##TrieNode()
			For i As Integer = TRIE_CHAR_ARRAY_LBOUND To TRIE_CHAR_ARRAY_RBOUND
				Delete children(i)
			Next i
		End Destructor


	Type _TRIE_DATA_TYPE_##Trie
		rootNode As _TRIE_DATA_TYPE_##TrieNode Ptr
		
		Declare Constructor()
		Declare Destructor()
		
		Declare Sub add(_key As String, _data As _TRIE_DATA_TYPE_)
		Declare Sub remove(_key As String)
		Declare Function get(_key As String) As _TRIE_DATA_TYPE_
		Declare Function contains(_key As String) As Integer
	End Type

		Constructor _TRIE_DATA_TYPE_##Trie()
			this.rootNode = New _TRIE_DATA_TYPE_##TrieNode
		End Constructor
		
		
		Destructor _TRIE_DATA_TYPE_##Trie()
			Delete this.rootNode
		End Destructor

		'' METHOD: add
		Sub _TRIE_DATA_TYPE_##Trie.add(_key As String, _data As _TRIE_DATA_TYPE_)
			Var iNode = this.rootNode
			Dim As UInteger stlen = Len(_key)
			For i As UInteger = 1 To stlen
				If iNode->children(_key[i]) = 0 Then 
					iNode->children(_key[i]) = New _TRIE_DATA_TYPE_##TrieNode
				EndIf
				iNode = iNode->children(_key[i])
			Next i	
			iNode->data = _data
		End Sub
		
		'' METHOD: remove
		Sub _TRIE_DATA_TYPE_##Trie.remove(_key As String)
			Var iNode = this.rootNode
			Dim As UInteger stlen = Len(_key)
			For i As UInteger = 1 To stlen
				iNode = iNode->children(_key[i])
				If iNode = 0 Then Return
			Next i
			iNode->data = _TRIE_DATA_TYPE_##_TRIE_DEFAULT_VALUE
		End Sub
		
		'' METHOD: get
		Function _TRIE_DATA_TYPE_##Trie.get(_key As String) As _TRIE_DATA_TYPE_
			Var iNode = this.rootNode
			Dim As UInteger stlen = Len(_key)
			For i As UInteger = 1 To stlen
				iNode = iNode->children(_key[i])
				If iNode = 0 Then Return _TRIE_DATA_TYPE_##_TRIE_DEFAULT_VALUE
			Next i
			Return iNode->data
		End Function

		
		'' METHOD: contains
		Function _TRIE_DATA_TYPE_##Trie.contains(_key As String) As Integer
			Return this.get(_key) <> _TRIE_DATA_TYPE_##_TRIE_DEFAULT_VALUE
		End Function
		
	#Endif
#EndMacro
