# Benchmark tipográfico

Relevamiento de las fuentes que usan 12 sitios de referencia, hecho el 11/08/2026.

Los datos están en [`relevamiento.md`](relevamiento.md). El script que los produce está en [`relevar-fuentes.sh`](relevar-fuentes.sh).

## Por qué esto es un benchmark y no otra cosa

Mirar sitios que nos gustan y sacar conclusiones no es un benchmark. Es un moodboard, y sirve para otra cosa. La diferencia no es el rigor del que mira: son cuatro condiciones concretas que este relevamiento cumple y un moodboard no.

### 1. El conjunto de comparación está definido antes de mirar, y justificado

Los 12 sitios no se eligieron por gustar. Se eligieron por cubrir tres funciones distintas dentro de la comparación:

| Grupo | Sitios | Para qué sirve en la comparación |
|---|---|---|
| **Competencia directa** | RP Strength, Stronger by Science, Girls Gone Strong, Barbell Medicine, Caliber | Muestra el lenguaje visual del entrenamiento basado en evidencia, que es donde juega Jimena |
| **Categoría premium** | Equinox, Ladder, Future, Tonal, Peloton | Muestra qué hacen las marcas que cobran caro, que es hacia donde apunta la decisión de precio |
| **Excelencia fuera del rubro** | Stripe, Linear | Control de calidad de oficio. Si un patrón aparece también acá, es de diseño y no de moda pasajera del fitness |

Un conjunto elegido por afinidad estética habría confirmado lo que ya pensábamos. Este está armado para poder contradecirnos, y de hecho lo hizo: la hipótesis de partida era que el problema era Fraunces, y el hallazgo fue que el problema era usar serif.

### 2. Se mide evidencia, no percepción

No se miró cómo se ven los sitios. Se leyó el CSS que sirven y los archivos `.woff2` que descargan, que es el dato duro de qué fuente usa cada uno.

Esto importa por algo que a ojo es invisible: no se puede distinguir una grotesca licenciada cara de una gratuita parecida. Y esa distinción es justamente la que define si una referencia es copiable. Saber que Tonal usa GT America, que cuesta cientos de dólares, cambia la conclusión respecto de creer que usa "una sans cualquiera".

### 3. El método es reproducible

`relevar-fuentes.sh` corre el relevamiento completo. Cualquiera puede ejecutarlo y obtener el mismo resultado, o correrlo dentro de un año para ver qué cambió.

Un moodboard no se puede repetir: depende de quién lo armó y de qué día. Un benchmark que no se puede repetir es una opinión con formato de tabla.

### 4. El criterio de comparación es explícito y el mismo para todos

Se registran tres variables por sitio, iguales en los 12 casos: fuente de títulos, fuente de texto, y si es gratuita, licenciada o hecha a medida.

Eso permite contar. "11 de 12 usan grotesca sans" es una afirmación verificable que se sostiene o se cae con los datos. "Los sitios de fitness se sienten más modernos" no se puede verificar ni refutar.

## Qué no es

**No es un análisis competitivo.** Solo mira tipografía. No cubre precios, propuesta de valor, canales ni funcionalidad de esos sitios.

**No es una encuesta de preferencia.** Mide qué hace la categoría, no qué prefieren las clientas de Jimena. Son dos preguntas distintas y esta responde la primera. La segunda sigue sin responderse.

**No es una recomendación por sí solo.** El benchmark aporta el dato de que 11 de 12 usan grotesca. La decisión de adoptar Archivo está en el [discovery](../README.md) y suma criterios que no salen de acá, como el presupuesto y el posicionamiento buscado.

## Límites conocidos

• **Dos sitios quedaron afuera.** Whoop devuelve 403 ante acceso automatizado y Gymshark carga las fuentes por una vía que el script no pudo inspeccionar. Son 2 ausencias sobre 14 intentos.
• **Es una foto de un día.** Las marcas rediseñan. Estos datos valen para agosto de 2026.
• **Solo se lee la home.** Una marca puede usar otra tipografía en su blog o en su aplicación.
• **La detección es del archivo, no del uso.** El script encuentra qué fuentes carga un sitio. Que Peloton cargue Inter no prueba que la use en todos los títulos, aunque en la práctica el dato es fiable cuando hay una sola familia.
