
#Ifdef _VECTOR_PRECISION_DOUBLE_
	#Define vectorPrec Double
#Else
	#Define vectorPrec Single 
#EndIf

''' 2d Vector '''

Type vec2
	x As vectorPrec
	y As vectorPrec
	Declare Constructor(x As vectorPrec=0, y As vectorPrec=0)
	Declare Constructor(x1 As vectorPrec, y1 As vectorPrec, x2 As vectorPrec, y2 As vectorPrec)
	Declare Function length() As vectorPrec
	Declare Function normalize() As vec2
	Declare Function dot(ByRef rhs As vec2) As vectorPrec
	Declare Function cross(ByRef rhs As vec2) As vectorPrec
	Declare Operator Cast() As String
	Declare Operator += (ByRef rhs As vec2)
	Declare Operator -= (ByRef rhs As vec2)
	Declare Operator *= (ByRef rhs As vectorPrec)
	Declare Operator /= (ByRef rhs As vectorPrec)
End Type
	Constructor vec2(x As vectorPrec=0, y As vectorPrec=0)
		this.x = x
		this.y = y
	End Constructor
	Constructor vec2(x1 As vectorPrec, y1 As vectorPrec, x2 As vectorPrec, y2 As vectorPrec)
		this.x = x2-x1
		this.y = y2-y1
	End Constructor
	Function vec2.length() As vectorPrec
		Return Sqr(x*x+y*y)
	End Function
	Function vec2.normalize() As vec2
		Dim As vectorPrec l = Sqr(x*x+y*y)
		Return Type<vec2>(x/l, y/l)
	End Function
	Function vec2.dot(ByRef rhs As vec2) As vectorPrec
		Return this.x*rhs.x + this.y*rhs.y
	End Function
	Function vec2.cross(ByRef rhs As vec2) As vectorPrec
		Return this.x*rhs.y - this.y*rhs.x
	End Function
	Operator vec2.Cast() As String
		Return "(" + Str(x) + ", " + Str(y) + ")"
	End Operator
	Operator vec2.+= (ByRef rhs As vec2)
		this.x += rhs.x
		this.y += rhs.y
	End Operator
	Operator vec2.-= (ByRef rhs As vec2)
		this.x -= rhs.x
		this.y -= rhs.y
	End Operator
	Operator vec2.*= (ByRef rhs As vectorPrec)
		this.x *= rhs
		this.y *= rhs
	End Operator
	Operator vec2./= (ByRef rhs As vectorPrec)
		this.x /= rhs
		this.y /= rhs
	End Operator


	Operator = (ByRef lhs As vec2, ByRef rhs As vec2) As Integer
		Return ( (lhs.x=rhs.x) And (lhs.y=rhs.y) )
	End Operator
	Operator + (ByRef lhs As vec2, ByRef rhs As vec2) As vec2
		Return Type<vec2>(lhs.x+rhs.x, lhs.y+rhs.y)
	End Operator
	Operator - (ByRef lhs As vec2, ByRef rhs As vec2) As vec2
		Return Type<vec2>(lhs.x-rhs.x, lhs.y-rhs.y)
	End Operator
	Operator * (ByRef lhs As vec2, ByRef rhs As vec2) As vectorPrec
		Return lhs.x*rhs.x + lhs.y*rhs.y
	End Operator
	Operator * (ByRef lhs As vectorPrec, ByRef rhs As vec2) As vec2
		Return Type<vec2>(lhs*rhs.x, lhs*rhs.y)
	End Operator
	Operator * (ByRef lhs As vec2, ByRef rhs As vectorPrec) As vec2
		Return Type<vec2>(lhs.x*rhs, lhs.y*rhs)
	End Operator
	Operator - (ByRef rhs As vec2) As vec2
		Return Type<vec2>(-rhs.x, -rhs.y)
	End Operator
	Operator Abs (ByRef rhs As vec2) As vectorPrec
		Return rhs.length
	End Operator


Function Vec2FromAngle(angle As vectorPrec, length As vectorPrec = 1.0) As vec2
	Return Type<vec2>(Cos(angle * 0.017453292519943), Sin(angle * 0.017453292519943))
End Function


''' 3d Vector '''

Type vec3
	As vectorPrec x,y,z
	Declare Constructor(x As vectorPrec=0, y As vectorPrec=0, z As vectorPrec=0)
	Declare Constructor(x1 As vectorPrec, y1 As vectorPrec, _
						z1 As vectorPrec, x2 As vectorPrec, _
						y2 As vectorPrec, z2 As vectorPrec)
	Declare Function length() As vectorPrec
	Declare Function normalize() As vec3
	Declare Function dot(ByRef rhs As vec3) As vectorPrec
	Declare Function cross(ByRef rhs As vec3) As vectorPrec
	Declare Operator Cast() As String
	Declare Operator += (ByRef rhs As vec3)
	Declare Operator -= (ByRef rhs As vec3)
	Declare Operator *= (ByRef rhs As vectorPrec)
	Declare Operator /= (ByRef rhs As vectorPrec)
End Type
	Constructor vec3(x As vectorPrec=0, y As vectorPrec=0, z As vectorPrec=0)
		this.x = x
		this.y = y
		this.z = z
	End Constructor
	Constructor vec3(x1 As vectorPrec, y1 As vectorPrec, _
					z1 As vectorPrec, x2 As vectorPrec, _
					y2 As vectorPrec, z2 As vectorPrec)
		this.x = x2-x1
		this.y = y2-y1
		this.z = z2-z1
	End Constructor
	Function vec3.length() As vectorPrec
		Return Sqr(x*x+y*y+z*z)
	End Function
	Function vec3.normalize() As vec3
		Dim As vectorPrec l = Sqr(x*x+y*y+z*z)
		Return Type<vec3>(x/l, y/l, z/l)
	End Function
	Function vec3.dot(ByRef rhs As vec3) As vectorPrec
		Return this.x*rhs.x + this.y*rhs.y
	End Function
	Function vec3.cross(ByRef rhs As vec3) As vectorPrec
		Return this.x*rhs.y - this.y*rhs.x
	End Function
	Operator vec3.Cast() As String
		Return "(" + Str(x) + ", " + Str(y) + ", " + Str(z) + ")"
	End Operator
	Operator vec3.+= (ByRef rhs As vec3)
		this.x += rhs.x
		this.y += rhs.y
		this.z += rhs.z
	End Operator
	Operator vec3.-= (ByRef rhs As vec3)
		this.x -= rhs.x
		this.y -= rhs.y
		this.z -= rhs.z
	End Operator
	Operator vec3.*= (ByRef rhs As vectorPrec)
		this.x *= rhs
		this.y *= rhs
		this.z *= rhs
	End Operator
	Operator vec3./= (ByRef rhs As vectorPrec)
		this.x /= rhs
		this.y /= rhs
		this.z /= rhs
	End Operator
	
	
	Operator = (ByRef lhs As vec3, ByRef rhs As vec3) As Integer
		Return ( (lhs.x=rhs.x) And (lhs.y=rhs.y) And (lhs.z=rhs.z) )
	End Operator
	Operator + (ByRef lhs As vec3, ByRef rhs As vec3) As vec3
		Return Type<vec3>(lhs.x+rhs.x, lhs.y+rhs.y, lhs.z+rhs.z)
	End Operator
	Operator - (ByRef lhs As vec3, ByRef rhs As vec3) As vec3
		Return Type<vec3>(lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z)
	End Operator
	Operator * (ByRef lhs As vec3, ByRef rhs As vec3) As vectorPrec
		Return lhs.x*rhs.x + lhs.y*rhs.y + lhs.z*rhs.z
	End Operator
	Operator * (ByRef lhs As vectorPrec, ByRef rhs As vec3) As vec3
		Return Type<vec3>(lhs*rhs.x, lhs*rhs.y, lhs*rhs.z)
	End Operator
	Operator * (ByRef lhs As vec3, ByRef rhs As vectorPrec) As vec3
		Return Type<vec3>(lhs.x*rhs, lhs.y*rhs, lhs.z*rhs)
	End Operator
	Operator - (ByRef rhs As vec3) As vec3
		Return Type<vec3>(-rhs.x, -rhs.y, -rhs.z)
	End Operator
	Operator Abs (ByRef rhs As vec3) As vectorPrec
		Return rhs.length
	End Operator
