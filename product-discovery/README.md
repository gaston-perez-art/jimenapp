# Product discovery

Carpeta donde se documenta **cómo se llegó a cada decisión de producto**, no solo cuál fue.

## Por qué existe

`memory.md` registra las decisiones tomadas. Esta carpeta registra el proceso que las produjo: qué problema se detectó, qué evidencia se juntó, qué opciones se evaluaron y por qué ganó una.

La diferencia importa cuando alguien quiere revisar una decisión seis meses después. Sin el proceso documentado, revisar significa volver a discutir desde cero. Con el proceso documentado, se puede atacar el punto exacto que ya no aplica: un dato que envejeció, un supuesto que resultó falso, un criterio que cambió.

También sirve para lo contrario. Cuando alguien propone volver atrás con algo ya decidido, el discovery muestra si el argumento es nuevo o si es uno que ya se evaluó y se descartó.

## Cómo se organiza

Una carpeta numerada por cada discovery, en orden cronológico:

| Carpeta | Qué se investigó | Estado |
|---|---|---|
| `01-tipografia/` | Qué tipografía usan los sitios de entrenamiento de referencia y cuál conviene adoptar | **Cerrado**, decisión tomada el 11/08/2026 |
| `02-benchmark-sitios/` | Cómo estructuran su página los sitios de referencia: secciones, conversión, prueba social y oferta | **Abierto**, con ideas sin decidir |

## Qué entra acá y qué no

Entra el trabajo de investigación: relevamientos, entrevistas, pruebas con usuarias, análisis de competencia, comparaciones de opciones.

No entra el resultado operativo. Si un discovery termina en una decisión, la decisión se escribe en `memory.md` y el código se cambia donde corresponda. Esta carpeta guarda el razonamiento, no reemplaza a los otros archivos.

## Estructura de cada discovery

Cada carpeta tiene como mínimo un `README.md` con cinco partes:

• **Problema**: qué se detectó y por qué valía investigarlo
• **Método**: cómo se juntó la evidencia, de forma que otro lo pueda repetir
• **Hallazgos**: qué salió, incluyendo lo que contradijo la hipótesis inicial
• **Decisión**: qué se eligió y por qué se descartó el resto
• **Límites**: qué no cubre esta investigación

Si el discovery incluyó un benchmark, va en una subcarpeta propia con sus datos y su método.
