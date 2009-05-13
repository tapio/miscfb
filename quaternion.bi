Type Quaternion
	As Double w,x,y,z
	Declare Constructor(w As Double = 0, As Double = 0, y As Double = 0, z As Double = 0)
	Declare Constructor(ByVal angle As Single, ByVal xcomp As Single, ByVal ycomp As Single, ByVal zcomp As Single)
	Declare Operator *= (rhs As Quaternion)
	Declare Operator Cast() As String
	Declare Function Length() As Double
	Declare Sub Conjugate()
	Declare Sub Normalize()
End Type
	Constructor Quaternion (w As Double = 0, x As Double = 0, y As Double = 0, z As Double = 0)
		this.w = w
		this.x = x
		this.y = y
		this.z = z
	End Constructor 
	Constructor Quaternion (ByVal angle As Single, ByVal xcomp As Single, ByVal ycomp As Single, ByVal zcomp As Single)
		Dim As Double _d = Sqr(xcomp*xcomp + ycomp*ycomp + zcomp*zcomp)
		xcomp /= _d : ycomp /= _d : zcomp /= _d
		Dim As Double _sin_ang = Sin(angle/2.0)
		this.x = xcomp * _sin_ang
		this.y = ycomp * _sin_ang
		this.z = zcomp * _sin_ang
		this.w = Cos(angle/2.0)
		this.Normalize
	End Constructor
	Operator Quaternion.*= (rhs As Quaternion)
		Dim _w As Double = this.w*rhs.w - this.x*rhs.x - this.y*rhs.y - this.z-rhs.z
		Dim _x As Double = this.w*rhs.x + this.x*rhs.w + this.y*rhs.z - this.z-rhs.y
		Dim _y As Double = this.w*rhs.y + this.y*rhs.w + this.z*rhs.x - this.x-rhs.z
		Dim _z As Double = this.w*rhs.z + this.z*rhs.w + this.x*rhs.y - this.y-rhs.x
		this.w = _w : this.x = _x : this.y = _y : this.z = _z
	End Operator
	Sub Quaternion.Conjugate()
		this.x = -this.x
		this.y = -this.y
		this.z = -this.z
	End Sub
	Function Quaternion.Length() As Double
		Return Sqr(this.w*this.w + this.x*this.x + this.y*this.y + this.z*this.z)
	End Function
	Sub Quaternion.Normalize()
		Dim As Double _mag = this.Length()
		this.w /= _mag
		this.x /= _mag
		this.y /= _mag
		this.z /= _mag 
	End Sub
	Operator Quaternion.Cast() As String
		Return Str(this.w)+" "+Str(this.x)+" "+Str(this.y)+" "+Str(this.z)
	End Operator

Operator * (lhs As Quaternion, rhs As Quaternion) As Quaternion
	Return Type( 	lhs.w*rhs.w - lhs.x*rhs.x - lhs.y*rhs.y - lhs.z*rhs.z, _
					lhs.w*rhs.x + lhs.x*rhs.w + lhs.y*rhs.z - lhs.z*rhs.y, _
					lhs.w*rhs.y + lhs.y*rhs.w + lhs.z*rhs.x - lhs.x*rhs.z, _
					lhs.w*rhs.z + lhs.z*rhs.w + lhs.x*rhs.y - lhs.y*rhs.x   )
End Operator

Operator + (lhs As Quaternion, rhs As Quaternion) As Quaternion
	Return Type (lhs.w+rhs.w, lhs.x+rhs.x, lhs.y+rhs.y, lhs.z+rhs.z)
End Operator

Operator - (lhs As Quaternion, rhs As Quaternion) As Quaternion
	Return Type (lhs.w-rhs.w, lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z)
End Operator
