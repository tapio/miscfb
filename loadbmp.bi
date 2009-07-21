
Function LoadBMP(filename As String) As Any Ptr
	Dim As String*2 magic
	Dim As Integer h,w,f
	Dim As Any Ptr img

	If Not FileExists(filename) Then Return 0
	f = FreeFile
	Open filename For Binary As #f
		Get #f,,head
		If head = "BM" Then	'BM header
			Seek #f,&h13		'find width
			Get  #f,,w			'get width
			Seek #f,&h17		'find height
			Get  #f,,h			'get height
			img = ImageCreate(w,h)
			BLoad filename, img
	 	End If
	Close #f
	
	Return img
End Function
