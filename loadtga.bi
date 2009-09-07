' TGA Loader v0.5 by yetifoot
' PUBLIC DOMAIN
'
' NOTE:  This is a very rough program, please check it over well if you plan to actually use it as is!!!!  I am not very happy with this code as it stands!
'
' This program loads 16/24/32 bit Targa images, in uncompressed, or RLE format.
'
' The important function is TGA_Load
'   Passing a filename to this function will return a pointer to a 32bit FB GFX compatible
'   buffer.  Failure will result in a NULL pointer.
'
' Credit is due to NeHe
'   http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=33
' Also to Paul Bourke
'   http://astronomy.swin.edu.au/~pbourke/dataformats/tga/

#include once "crt.bi"
#include once "fbgfx.bi"

#define DEFAULT_ALPHA_VALUE 255

#define R_SHIFT 0
#define G_SHIFT 8
#define B_SHIFT 16
#define A_SHIFT 24

#define R_MASK555 31
#define G_MASK555 992
#define B_MASK555 31744

#define CRACKR555(c)  ((((c) And R_MASK555)         * 255) \ 31)
#define CRACKG555(c) (((((c) And G_MASK555) Shr  5) * 255) \ 31)
#define CRACKB555(c) (((((c) And B_MASK555) Shr 10) * 255) \ 31)

#define COLOUR_16TO32_555(c) ((CRACKR555(c) Shl R_SHIFT) Or (CRACKG555(c) Shl G_SHIFT) Or (CRACKB555(c) Shl B_SHIFT) Or (DEFAULT_ALPHA_VALUE Shl A_SHIFT))


Type TGA_HEADER Field = 1
        idlength        As Ubyte
        colourmaptype   As Ubyte
        datatypecode    As Ubyte
        colourmaporigin As Ushort
        colourmaplength As Ushort
        colourmapdepth  As Ubyte
        x_origin        As Ushort
        y_origin        As Ushort
        Width           As Ushort
        height          As Ushort
        bitsperpixel    As Ubyte
        imagedescriptor As Ubyte
End Type

Function vertical_flip _
        ( _
                Byval img As fb.image Ptr _
        ) As Any Ptr

        Dim As fb.image Ptr temp_img
        Dim As Ubyte Ptr    p1
        Dim As Ubyte Ptr    p2

        temp_img = imagecreate( img->width, img->height )

        p1 = cptr( Ubyte Ptr, img ) + sizeof( fb.image ) + ((img->height - 1) * img->pitch)
        p2 = cptr( Ubyte Ptr, temp_img ) + sizeof( fb.image )

        For y As Integer = 0 To img->height - 1
                memcpy( p2, p1, img->pitch )
                p1 -= img->pitch
                p2 += img->pitch
        Next y

        imagedestroy( img )

        Function = temp_img

End Function

Function loadTGA _
        ( _
                Byval file_name As Zstring Ptr _
        ) As fb.image Ptr

        Dim As TGA_HEADER tga_info
        Dim As FILE Ptr   hFile
        Dim As Ubyte Ptr  tga_id
        Dim As Ubyte Ptr  data_buf
       
        hFile = fopen( file_name, "rb" )
        If hFile = NULL Then
                Return NULL
        End If
       
        If fread( @tga_info, 1, sizeof( TGA_HEADER ), hFile) <> sizeof( TGA_HEADER ) Then
                fclose( hFile )
                Return NULL
        End If
       
        If tga_info.idlength <> 0 Then
                tga_id = allocate( tga_info.idlength )
                If fread( @tga_id, 1, tga_info.idlength, hFile ) <> tga_info.idlength Then
                        deallocate( tga_id )
                        fclose( hFile )
                        Return NULL
                End If
                deallocate( tga_id )
        End If
       
        Dim As Integer w = tga_info.width
        Dim As Integer h = tga_info.height
        Dim As Integer bpp = tga_info.bitsperpixel \ 8
        Dim As Integer file_data_size

        Scope
                Dim As Integer t_pos = ftell( hFile )
                fseek( hFile, 0, SEEK_END )
                file_data_size = ftell( hFile ) - t_pos
                fseek( hFile, t_pos, SEEK_SET )
        End Scope

        data_buf = allocate( file_data_size )

        If fread( data_buf, 1, file_data_size, hFile ) <> file_data_size Then
                deallocate( data_buf )
                fclose( hFile )
                Return NULL
        End If

        fclose( hFile )

        Select Case As Const tga_info.datatypecode
                Case 2
                        If file_data_size <> w * h * bpp Then
                                ' TODO
                                'DEBUGPRINT( "checksize" )
                                'deallocate( data_buf )
                                'return NULL
                        End If
                Case 10
                        Dim As Uinteger  data_buf_pos
                        Dim As Ubyte Ptr colorbuffer
                        Dim As Uinteger  currentpixel
                        Dim As Uinteger  currentbyte
                        Dim As Ubyte     chunkheader
                        Dim As Integer   numpixels
                        Dim As Integer   temp_buf_size
                        Dim As Ubyte Ptr temp_buf
                       
                        numpixels = w * h
                        temp_buf_size = (numpixels * bpp)
                        temp_buf = malloc(temp_buf_size)
                       
                        While currentpixel < numpixels
                                chunkheader = data_buf[data_buf_pos]
                                data_buf_pos += 1
                                If chunkheader < 128 Then
                                        chunkheader += 1
                                        For counter As Integer = 0 To chunkheader - 1
                                                colorbuffer = @data_buf[data_buf_pos]
                                                data_buf_pos += bpp
                                                For i As Integer = 0 To bpp - 1
                                                        temp_buf[currentbyte + i] = colorbuffer[i]
                                                Next i
                                                currentbyte += bpp
                                                currentpixel += 1
                                        Next counter
                                Else
                                        chunkheader -= 127
                                        colorbuffer = @data_buf[data_buf_pos]
                                        data_buf_pos += bpp 
                                        For counter As Integer = 0 To chunkheader - 1
                                                For i As Integer = 0 To bpp - 1
                                                        temp_buf[currentbyte + i] = colorbuffer[i]
                                                Next i           
                                                currentbyte += bpp
                                                currentpixel += 1
                                        Next counter
                                End If
                        Wend
                       
                        deallocate( data_buf )
                        data_buf = temp_buf
                Case Else
                        deallocate( data_buf )
                        Return NULL
        End Select

        Dim As fb.image Ptr img
        Dim As Ubyte Ptr p1, p2
        Dim As Integer ofs

        img = imagecreate( w, h )

        p1 = data_buf
        p2 = cptr( Ubyte Ptr, img ) + sizeof( fb.image )

        ofs = img->pitch - (img->width * 4)

        For y As Integer = 0 To h - 1
                For x As Integer = 0 To w - 1
                        Select Case As Const bpp
                                Case 2
                                        *cptr( Uinteger Ptr, p2 ) = COLOUR_16TO32_555( *cptr( Ushort Ptr, p1 ) )
                                        p1 += 2
                                Case 3
                                        *cptr( Uinteger Ptr, p2 ) = rgba( p1[2], p1[1], p1[0], DEFAULT_ALPHA_VALUE )
                                        p1 += 3
                                Case 4
                                        *cptr( Uinteger Ptr, p2 ) = *cptr( Uinteger Ptr, p1 )
                                        p1 += 4
                        End Select
                        p2 += 4
                Next x
                p2 += ofs
        Next y

        deallocate( data_buf )

        If ((tga_info.imagedescriptor And 32) Shr 5) = 0 Then
                img = vertical_flip( img )
        End If

        Return img

End Function
