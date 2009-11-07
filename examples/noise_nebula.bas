#Include "../libNoise.bas"
' The Perlin-function is called with x and y coordinates
' and the size of the area.
' Last two parameter are the size of features (related to
' octaves, or how many frequencies are summed up) and the 
' index number of differently seeded noises.
' For best results, use power of two numbers for all three
' sizes (e.g. 64, 128, 512, ... etc).


' Macro for multiplication blending, also defined in miscfb/def.bi
#Define blendMul(a,b) (((a) * (b)) Shr 8)

' Build 4 noise tables, seeded by Timer
BuildNoiseTables(Timer,4)

' Dimensions
Const xres = 512
Const yres = 512
Screenres xres, yres, 32

' Color noise feature size, use power of 2 values
#Define csize 64

Dim As Uinteger Ptr buffer = Screenptr()
Dim As Ubyte r,g,b,w
Screenlock
' Loop through the screen pixels
For x As Integer = 0 To xres - 1
	For y As Integer = 0 To yres - 1
		' Get the "blackness"
		w = Perlin(x,y,xres,yres,128,1)
		' Exponent filter for nicer cloud shapes
		w = ExpFilter(w, 128, 0.99)
		' Get colors and blend them with the blackness factor
		r = BlendMul(Perlin(x,y,xres,yres,csize,2), w)
		g = BlendMul(Perlin(x,y,xres,yres,csize,3), w)
		b = BlendMul(Perlin(x,y,xres,yres,csize,4), w)
		' Apply to the buffer
		buffer[x + xres * y] = Rgb(r,g,b)
	Next
Next
ScreenUnLock
' Uncomment to save result image to disk
'BSave "perlin_nebulae.bmp",0
Sleep

