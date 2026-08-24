# Fotos de las alumnas

Las tarjetas de la sección Testimonios buscan la foto por **nombre de archivo fijo**.
Para cambiar una foto no hay que tocar el HTML: se reemplaza el archivo y listo.

| Archivo | Alumna | Dónde aparece |
|---|---|---|
| `silvia.jpg` | Silvia Rodríguez | destacado (panel oscuro) |
| `daiana.jpg` | Daiana Gillese Urueña | cinta |
| `margarita.jpg` | Margarita Izurieta López | cinta |
| `veronica.jpg` | Verónica Vázquez | cinta |
| `lorena.jpg` | Lorena Mariel Agout | cinta |
| `carolina.jpg` | Carolina Ibañez | cinta |

## Cómo tienen que estar las fotos

- **Cuadradas** (1:1). Se muestran recortadas en círculo con `object-fit:cover`, así que
  lo que quede fuera del círculo se pierde. La cara, centrada.
- **256×256 px alcanza y sobra.** En la cinta se ven a 54px y en el destacado a 64px.
  Subir un archivo de 3000px de la cámara solo hace más lenta la página.
- **JPG, y por debajo de 60 KB cada una.** Son 6 imágenes que cargan en la misma
  sección; juntas no deberían pasar de 300 KB.

Para redimensionar sin instalar nada (viene con macOS):

```bash
sips -Z 256 original.jpg --out silvia.jpg
```

**En Windows** (que es donde trabaja Jimena, y donde no hay Python ni `sips`), con
PowerShell y `System.Drawing`. Ojo que `sips -Z` solo redimensiona: si la foto no es
cuadrada hay que **recortar** primero, y ahí es donde se decide el encuadre.

```powershell
Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("C:\ruta\original.jpg")
$x = 0; $y = 230; $lado = 360        # cuadrado a recortar del original
$bmp = New-Object System.Drawing.Bitmap(256,256)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = 'HighQualityBicubic'
$g.DrawImage($img, (New-Object System.Drawing.Rectangle(0,0,256,256)),
             (New-Object System.Drawing.Rectangle($x,$y,$lado,$lado)),
             [System.Drawing.GraphicsUnit]::Pixel)
$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | ? { $_.MimeType -eq 'image/jpeg' }
$p = New-Object System.Drawing.Imaging.EncoderParameters(1)
$p.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 82)
$bmp.Save("daiana.jpg", $enc, $p)
```

**Cómo elegir el recorte, que es lo que cuesta.** No estimar a ojo: abrir la foto en el
navegador con una grilla de 50px encima y leer las coordenadas de la cara. Después
generar dos o tres recortes candidatos y **compararlos en círculo, a 54px, al lado de
las fotos que ya están** — el encuadre tiene que parecerse al del resto (cabeza y algo
de hombros), y un recorte que se ve bien grande puede quedar apretado en el círculo
chico. Así se eligió el de Daiana el 23/08/2026.

Si la cara queda pegada a un borde del original, no hay recorte cuadrado que la deje
centrada: hay que elegir entre centrarla y perder parte de la cabeza, o abrir el
encuadre y aceptar que quede algo corrida. Para la foto de Daiana se abrió el encuadre.

## Si una foto todavía no está

No pasa nada y no hay que comentar código: el avatar tiene detrás las iniciales sobre
el degradé de marca, y el `<img>` que falla se saca solo. La tarjeta se ve completa.

## Antes de publicar una foto

Es la cara de una persona real en un repositorio público. Cada archivo de esta carpeta
necesita la autorización de esa alumna, pedida por Jimena, y registrada en `memory.md`
junto con la de su testimonio.
