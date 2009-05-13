'' Utilities '' 

Declare Function Rand OverLoad (first As Double, last As Double) As Double
Declare Function Rand OverLoad (first As Integer, last As Integer) As Integer
Declare Function middle(a As Double, b As Double, c As Double) As Double
Declare Function min(a As Double, b As Double) As Double
Declare Function max(a As Double, b As Double) As Double
Declare Function clip(value As Double, lo As Double, hi As Double) As Double
Declare Function rgb_limit(value As Integer) As Integer
Declare Function blendRGB(col1 As UInteger, col2 As UInteger, factor As Single) As UInteger

'Declare Function in2DArray(array() As Any, a As Integer, b As Integer) As Byte


'' Math Functions ''

Function Rand OverLoad (first As Double, last As Double) As Double
    Return Rnd * (last - first) + first
End Function

Function Rand OverLoad (first As Integer, last As Integer) As Integer
    Return Int(Rnd * (last - first + 1)) + first
End Function

Function Min(a As Double, b As Double) As Double
    If a > b Then Return b Else Return a
End Function

Function Max(a As Double, b As Double) As Double
    If a > b Then Return a Else Return b
End Function


Function Clip(value As Double, lo As Double, hi As Double) As Double
    If value < lo Then Return lo
    If value > hi Then Return hi
    Return value
End Function

Function rgb_limit(value As Integer) As Integer
    If value < 0 Then Return 0
    If value > 255 Then Return 255
    Return value
End Function

Function blendRGB(col1 As UInteger, col2 As UInteger, factor As Single) As UInteger'
	''requires def.bi
	Dim As UByte r,g,b
	r = blend(rgb_r(col1), rgb_r(col2), factor)
	g = blend(rgb_g(col1), rgb_g(col2), factor)
	b = blend(rgb_b(col1), rgb_b(col2), factor)
	Return RGB(r,g,b)
End Function

Function Middle(a As Double, b As Double, c As Double) As Double
    Dim As Double minval = min(a ,min(b,c))
    Dim As Double maxval = max(a ,max(b,c))
    If minval < a And maxval > a Then Return a
    If minval < b And maxval > b Then Return b
    Return c 
End Function

Declare Function Distance Overload (x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Double
Declare Function Distance Overload (x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer) As Integer

Function Distance Overload (x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Double
	Return Sqr( (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) )
End Function 

Function Distance Overload (x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer) As Integer
	Return Sqr( CSng((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)) )
End Function 



Sub TextCenterScreen(_txt As String, _y As Integer, r As Short = -1, g As Short = -1, b As Short = -1)
	Dim As Integer _w
	ScreenInfo _w
	Dim As UInteger _col
	If r <> -1 And g <> -1 And b <> -1 Then _col = RGB(r,g,b) Else _col = Color()
	Draw String ( (_w-Len(_txt)*8)*.5, _y ), _txt, _col
End Sub

Sub PrintCenterScreen(_txt As String, _y As Integer, r As Short = -1, g As Short = -1, b As Short = -1)
	Dim As Short _w = LoWord(Width())
	Dim As UInteger _col
	If r <> -1 And g <> -1 And b <> -1 Then Color RGB(r,g,b)
	Locate _y, ( _w-Len(_txt) ) \ 2
	Print _txt
End Sub

'' Useful timers ''

Type DelayTimer
    delay As Double
    record As Double
    running As Byte
    Declare Constructor(delay As Double, running As Byte = -1)
    Declare Function hasExpired() As Byte
    Declare Sub start()
    Declare Sub pause()
End Type
    Constructor DelayTimer(delay As Double, running As Byte = -1)
        this.delay = delay
        this.running = running
        this.record = Timer
    End Constructor 
    Function DelayTimer.hasExpired() As Byte
        If this.running = 0 Or  Timer > this.record + this.delay Then
            'this.record = Timer
            this.running = 0
            Return Not 0
        EndIf
        Return 0
    End Function
    Sub DelayTimer.Start()
        this.running = Not 0
        this.record = Timer
    End Sub
    Sub DelayTimer.Pause()
        this.running = 0
    End Sub


Type FrameTimer
    prevTime As Double
    frameTime As Double
    Declare Constructor()
    Declare Sub Update()
    Declare Function getFPS() As Integer
    Declare Function getFrameTime As Double
End Type
    Constructor FrameTimer()
        this.prevTime = Timer
    End Constructor
    Sub FrameTimer.Update()
        this.frameTime = (Timer - this.prevTime)
        this.prevTime = Timer
    End Sub
    Function FrameTimer.getFPS As Integer
        Return Int(1.0 / this.frameTime)
    End Function
    Function FrameTimer.getFrameTime As Double
        Return this.frameTime
    End Function
        
'MISC

Sub AddLog(logstr As String, filename As String = "log.txt")
	Var f = FreeFile
	Open filename For Append As #f
		Print #f, logstr
    Close #f
End Sub

