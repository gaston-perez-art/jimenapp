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

## Cómo tienen que estar las fotos

- **Cuadradas** (1:1). Se muestran recortadas en círculo con `object-fit:cover`, así que
  lo que quede fuera del círculo se pierde. La cara, centrada.
- **256×256 px alcanza y sobra.** En la cinta se ven a 54px y en el destacado a 64px.
  Subir un archivo de 3000px de la cámara solo hace más lenta la página.
- **JPG, y por debajo de 60 KB cada una.** Son 5 imágenes que cargan en la misma
  sección; juntas no deberían pasar de 300 KB.

Para redimensionar sin instalar nada (viene con macOS):

```bash
sips -Z 256 original.jpg --out silvia.jpg
```

## Si una foto todavía no está

No pasa nada y no hay que comentar código: el avatar tiene detrás las iniciales sobre
el degradé de marca, y el `<img>` que falla se saca solo. La tarjeta se ve completa.

## Antes de publicar una foto

Es la cara de una persona real en un repositorio público. Cada archivo de esta carpeta
necesita la autorización de esa alumna, pedida por Jimena, y registrada en `memory.md`
junto con la de su testimonio.
