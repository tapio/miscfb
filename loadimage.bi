#Include Once "loadbmp.bi"
#Include Once "loadtga.bi"
#Include Once "loadpng.bi"

'' FUNCTION: LoadImage
''	Loads an image.
''	Supported formats: bmp, tga, png
''	Format auto-detection can be overridden by specifying
''	the format file extension as the second parameter.
Function LoadImage(_filepath As String, _format As String = "") As Any Ptr
	If _format = "" Then _format = Right(_filepath, 3)
	_format = LCase(_format)
	Select Case _format
		Case "png":			Return loadPNG(_filepath)
		Case "tga":			Return loadTGA(_filepath)
		Case "bmp":			Return loadBMP(_filepath)
		Case "jpg","peg":	Return 0
	End Select
	Return 0
End Function
