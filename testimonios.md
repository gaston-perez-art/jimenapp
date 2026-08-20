# Cómo se carga un testimonio

Proceso acordado el 19/08/2026. Sirve para las dos personas y para un asistente de IA:
si alguien dice *"voy a cargar un testimonio"*, lo primero es **pedir los campos de esta
lista**, no empezar a escribir HTML.

## 1. Los campos que hay que pedir

Son cinco y **no se inventa ninguno**. Si falta uno, se pide antes de tocar el sitio.

| Campo | Para qué | Si falta |
|---|---|---|
| **Texto** | La cita | No hay testimonio. Se espera |
| **Nombre y apellido** | La firma | No hay testimonio. Un testimonio anónimo no suma confianza, resta |
| **Edad** | Va abajo del nombre. Es lo que hace que la visitante de 45 se reconozca, y el nicho es +35 | Se puede publicar sin ella, pero se pierde lo que más aporta. Preguntar primero |
| **País** | La pastilla del pie, con bandera. Dice que se entrena a distancia | Se puede publicar sin ella (queda el pie vacío), pero preguntar primero |
| **Foto** | El avatar redondo | **Se publica igual**: quedan las iniciales sobre el degradé de marca. Se suma después sin tocar código |

Y una sexta cosa que no es un campo pero es obligatoria:

**La autorización de la alumna, pedida por Jimena**, diciendo qué alcanza: solo el texto,
o también la foto. Sin eso no se publica. Son datos de una persona real en un repositorio
público. Queda registrada en el campo `autorizacion` de la cita, en el script.

## 2. Bandera nueva, si el país no está

Están Argentina, Puerto Rico y Estados Unidos. Para sumar otro país van dos cosas:
un `<symbol id="fl-xx">` en el sprite del principio del `<body>` de `docs/index.html`,
y una línea en el diccionario `BANDERAS` del script.

**Son SVG y no emoji a propósito:** Windows no dibuja los emoji de bandera, muestra las
dos letras del país. Se dibujan simplificadas — a 22×15px el detalle exacto es ruido.

## 3. La foto

Va en `docs/img/testimonios/` con **nombre de archivo fijo** (`nombre.jpg`, en minúscula
y sin apellido). Cuadrada, la cara centrada, 256px alcanza, JPG liviano:

```bash
sips -Z 256 original.jpg --out daiana.jpg
```

Está todo, con más detalle, en el README de esa carpeta.

## 4. Cargarlo

1. Sumar un diccionario a `CITAS`, en `herramientas/build-testimonios.py`, en la posición
   donde se quiera que aparezca.
2. Correr el script:

   ```bash
   python3 herramientas/build-testimonios.py
   ```

   Rehace la cinta entera y **recalcula solo** las tres cosas que se rompen al sumar una
   tarjeta: la duración de la vuelta (o la cinta se acelera), la cantidad de grupos y su
   recorrido en el keyframe (o el loop salta), y el divisor de `unGrupo()` en el script
   (o el arrastre va a otra velocidad que el dedo). También verifica la regla que dejó un
   hueco a la derecha en producción el 18/08: `(grupos − 1) × ancho_de_grupo ≥ 3840`.

3. Mirarlo en local, como cualquier cambio:

   ```bash
   python3 qa-local.py          # http://localhost:8899/index.html
   ```

4. Recién ahí, commit y push.

`python3 herramientas/build-testimonios.py --check` no escribe nada: avisa si el HTML
quedó desincronizado de la lista de citas.

## 5. Sobre el texto de la cita

**Es textual.** Lo único que se puede hacer:

- Cortar en el límite de una oración si no entra en la tarjeta.
- Corregir tipeos evidentes (`esilo`→`estilo`, `anios`→`años`).
- Sacar una oración que repite lo que ya dijo la anterior.

Lo que no: completar una frase que quedó cortada, reordenar, "mejorar" la redacción ni
mezclar dos mensajes en una cita. Una cita arreglada suena a cita inventada, y lo único
que esta sección tiene para ofrecer es que se le crea.

## 6. El destacado es aparte

El panel oscuro de arriba **no sale del script**: se edita a mano en `docs/index.html`.
No es una tarjeta más grande, es un relato — necesita que la alumna haya contado un
recorrido (qué probó antes, qué no le funcionó, qué cambió), y eso no entra en un campo.

Hoy es la historia de Silvia. Para cambiarlo hace falta otra alumna que haya contado algo
así, no simplemente una cita mejor.

**La alumna del destacado no se repite en la cinta.** Las dos cosas se ven juntas en la
misma pantalla y leer la misma cara dos veces achica la sección en vez de agrandarla.
