# Discovery 01 — Tipografía

> **Estado: cerrado e implementado.** Decisión tomada el 11/08/2026 por Gastón, aplicada en `docs/index.html` el mismo día.

## Problema

La tipografía del sitio no convencía, y el motivo no estaba claro.

El sistema original era Fraunces para títulos, Work Sans para cuerpo e IBM Plex Mono para etiquetas y datos. Ninguna de las tres es una mala fuente. El malestar era difuso: "no nos convence", sin un diagnóstico detrás.

Un malestar difuso con el diseño suele ser una de dos cosas. O es cuestión de gusto, y entonces se resuelve eligiendo otra cosa que guste más. O hay una contradicción real entre lo que la forma comunica y lo que el contenido promete, y entonces cambiar de fuente sin entender la causa produce el mismo malestar con otra tipografía.

La hipótesis a verificar era la segunda.

## Método

Se relevó el código fuente de 12 sitios de referencia y se extrajeron las fuentes que efectivamente sirven, leyendo sus declaraciones CSS y los archivos `.woff2` que descargan.

El detalle del método, los criterios de selección de los sitios y los datos completos están en [`benchmark/`](benchmark/).

La decisión de leer el código en vez de mirar los sitios fue deliberada. A ojo se puede confundir una grotesca con otra, y sobre todo no se distingue una fuente licenciada cara de una gratuita parecida, que es justamente la información que define si una referencia es copiable o no.

## Hallazgos

**1. El serif de display no es el lenguaje de la categoría.**

De 12 sitios, 11 usan una grotesca sans para los títulos. El único que usa serif es Girls Gone Strong, que es el más parecido a un blog de contenidos y el menos parecido a un servicio de entrenamiento. No es una tendencia marginal: es prácticamente unánime.

**2. Las marcas premium invierten en una grotesca con carácter, no en un serif decorativo.**

Equinox se mandó a hacer una fuente propia, Equinox Sans. Ladder licencia EK Modena Extended, Future licencia Season Sans, Tonal licencia GT America. Ninguna es gratuita, así que no son copiables de forma directa. Pero el patrón sí lo es: **el carácter viene de una sans ancha y pesada en los títulos**, no de un serif con personalidad.

**3. La mono es el recurso de las marcas técnicas.**

Equinox usa Messina Sans Mono y Stripe usa Source Code Pro, en ambos casos para datos y etiquetas. Es lo que hace que un número se lea como una medición y no como decoración.

Este hallazgo confirmó una decisión previa en vez de contradecirla: el uso de IBM Plex Mono para eyebrows y datos ya estaba alineado con el patrón de las marcas más creíbles del relevamiento. Se mantiene sin cambios.

## Diagnóstico

La hipótesis se confirmó. El problema no era de gusto.

Fraunces es un serif cálido de formas blandas, característico de la categoría *wellness artesanal*: cosmética natural, estudios de yoga, marcas de té. Es excelente en ese territorio. Pero debajo de ese título el sitio habla de periodización por bloques, autorregulación por RPE y fórmula de Mifflin-St Jeor.

**El título prometía un spa y el contenido entregaba una entrenadora que mide cargas.** Esa disonancia era la causa del malestar, y explica por qué no se resolvía probando otro serif.

Hay además una consecuencia comercial directa. El posicionamiento hacia la especialización en salud hormonal, que es la palanca de precio identificada en [`../../estrategia/business-case.md`](../../estrategia/business-case.md), depende de leerse como profesional de la salud aplicada. La tipografía empujaba en la dirección contraria.

## Opciones evaluadas

Las tres candidatas están en Google Fonts, con licencia de uso comercial libre. Se descartó de entrada cualquier fuente licenciada: GT America y las de su categoría cuestan varios cientos de dólares y no se justifican en esta etapa del proyecto.

| Opción | Referencia del benchmark | Por qué sí | Por qué no |
|---|---|---|---|
| **A. Archivo** | Equivalente libre de GT America (Tonal) y de Equinox Sans | Grotesca ancha y sólida. Lee estructura y método | Sola puede resultar fría |
| B. Bricolage Grotesque | Equivalente libre de EK Modena (Ladder) | Más personalidad, más memorable | Envejece más rápido por lo mismo |
| C. Instrument Serif | Territorio Girls Gone Strong, más filoso | Conserva el serif sin la blandura. Cambio mínimo | Sigue fuera del lenguaje de la categoría |

## Decisión

**Se adopta Archivo** para títulos y cuerpo. Se mantiene IBM Plex Mono para etiquetas y datos.

El razonamiento es comercial antes que estético. Cobrar por encima de una entrenadora genérica exige leerse como profesional de la salud aplicada, y 11 de los 12 sitios relevados construyen esa credibilidad con una grotesca ancha. Archivo es la opción gratuita más cercana a GT America y a Equinox Sans, que son las fuentes de las marcas que efectivamente cobran caro.

Sobre el riesgo de frialdad: la paleta vino y bronce ya definida en `memory.md` aporta la calidez que la fuente no da. El sistema completo no queda frío, queda sobrio.

## Límites de esta investigación

• **La tipografía es una parte del sistema, no el sistema.** Este discovery no evaluó paleta, espaciado, fotografía ni jerarquía. Cambiar la fuente no arregla otros problemas de diseño si los hay.
• **El relevamiento es una foto del 11/08/2026.** Las marcas rediseñan. En dos años estos datos pueden estar viejos, y el script de `benchmark/` está justamente para poder repetirlo.
• **No se validó con usuarias.** La decisión se apoya en el patrón de la categoría y en coherencia con el posicionamiento, no en preferencia medida de mujeres de más de 30. Un test con 5 o 10 alumnas actuales sería barato y podría contradecir esto.
• **Depende de una decisión que sigue abierta.** Archivo es la respuesta correcta si el posicionamiento va hacia la especialización hormonal. Si se opta por el público general de más de 30, la elección es bastante más libre y las tres opciones sirven.

## Implementación

Aplicado en `docs/index.html` el 11/08/2026:

• Se reemplazó el `link` de Google Fonts: salieron Fraunces y Work Sans, entró Archivo en pesos 400, 500, 600 y 700. IBM Plex Mono quedó igual.
• Las 7 declaraciones de `font-family` que usaban Fraunces o Work Sans pasaron a Archivo.
• Se subió el peso de los títulos de 600 a 700 y se agregó `letter-spacing:-.025em`. Una grotesca necesita más peso y tracking más ajustado que un serif para sostener el mismo tamaño de display, y el patrón relevado es de sans anchas y pesadas.

Verificado renderizando la página en el navegador antes de publicar.
