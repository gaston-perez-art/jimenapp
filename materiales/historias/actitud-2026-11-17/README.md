# Historias del 17/11/2026 · "Con qué actitud vas a empezar el día"

Secuencia de historias de bastidores con un mensaje de autocuidado. No vende nada directamente: es contenido de cercanía, para que las seguidoras se identifiquen con Jimena y empiecen a responderle.

## La secuencia

| # | Tipo | Contenido |
|---|---|---|
| 1 | Foto | Selfie en el gimnasio, de buen humor: "Buen día mis reinas 💜 ¿Con qué actitud ganadora vas a empezar el día hoy???" |
| 2 y 3 | Videos | "Ahora, les cuento la verdad… 😂" Contó cómo fue de verdad la mañana: una mala noche con Izan, que se despertó varias veces, muchas cosas para organizar antes de dar la clase virtual temprano, y que arrancó cansada y estresada. Pero decidió no quedarse enganchada en el mal humor. Cierra con: "No siempre arrancamos con toda la actitud… a veces también hay que buscarla. 💪🏼✨" |
| 4 | Placa | `historia-actitud-algo-lindo-por-vos.jpg` (ver abajo) |
| 5 | Sticker de preguntas | "¿Qué vas a hacer hoy por vos? 💗" |

## La placa

1080×1920, tipografía Archivo y la paleta del sitio: degradé `--wine-900` → `--wine-950`, halo `--wine-600` arriba a la derecha y acento `--bronze-light`. Es la misma familia visual que las placas de `lanzamiento-semana-1/`.

Texto final:

> Y a veces, buscar esa actitud es **hacer algo lindo por vos** 💗
>
> 💪🏼 Mover el cuerpo, aunque sean 20 min
> ☕ Un café tranquila
> 🥗 Comer rico y nutrirte bien
> 💗 Ponerte primera un ratito
>
> No hace falta todo. Con un gesto alcanza ✨

Se genera con `build-placa.py`, que se corre desde la raíz del repo. Para correrlo hace falta la fuente Archivo, que no está en el repo; la ruta se configura en `FONT`.

## Decisiones

• **La placa abre con "Y a veces…"** para retomar la frase con la que terminan los videos. Así se lee como el cierre del video y no como una publicación suelta.
• **Se pasó de 6 ítems a 4.** El texto original tenía 6 ítems, y una historia dura pocos segundos. Se sacaron "Dedicarte un ratito sin culpa" y "Aprender a decir que no", y quedaron movimiento y nutrición, que son el terreno de Jimena.
• **La placa no lleva foto.** La secuencia ya abre con una selfie; una placa de texto marca el cierre. Además, las fotos de Jimena que hay en el repo ya se usaron en placas anteriores.
• **Para la pregunta va el sticker de preguntas, no solo texto.** Con texto suelto casi nadie responde, porque hay que abrir un mensaje directo. Las respuestas que lleguen se pueden compartir al día siguiente en historias, sin el nombre de quien escribió.
• **Si responden poco**, la alternativa es una encuesta, que se contesta con un solo toque: "¿Hoy hiciste algo por vos?" → "Sí 🙌🏼" / "Todavía no 😅".
• **Sugerencias para subirla:** música suave, con el fragmento más largo para que dé tiempo a leer. El sticker va en el espacio libre entre el cierre y la web.

## Opción descartada

Hubo una opción 2, más corta, que Jimena no eligió:

> Días como hoy no se arreglan con fuerza de voluntad, se arreglan cuidándote un poquito 💗
> 💪🏼 20 minutos de movimiento · 🥗 Una comida que te nutra · 🧘🏼‍♀️ Un "no" a tiempo
> Un pequeño gesto ya cambia el día ✨
