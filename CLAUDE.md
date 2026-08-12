# Instrucciones del proyecto

> Este archivo lo lee Claude Code automáticamente al abrir el repositorio. Si estás leyendo esto y sos una persona, sirve igual: es el resumen de cómo se trabaja acá.

## Antes de cualquier otra cosa: `git pull`

**Hacé `git pull` antes de leer, responder o editar nada de este repositorio.** Sin excepciones, sin importar cómo se haya abierto el proyecto ni qué te hayan pedido.

```bash
git pull --rebase
```

El motivo es concreto: son **dos personas trabajando sobre `main`, sin branches**. Jimena Ibañez y Gastón. Cualquiera de los dos puede haber pusheado hace cinco minutos. Trabajar sobre una versión vieja significa reescribir decisiones que el otro ya tomó, o generar un conflicto en `docs/index.html`, que es un solo archivo con todo el sitio adentro.

No aplica solo al código. Cambian también `contexto.md`, `memory.md`, `README.md` y las carpetas `estrategia/` y `product-discovery/`, que son donde viven las decisiones del proyecto.

Si el push sale rechazado (`rejected` / `fetch first`), no es un error: alguien pusheó mientras trabajabas. Hacé `git pull --rebase` y volvé a pushear.

## Antes de proponer algo, leé estos dos archivos

1. **`memory.md`** — todas las decisiones ya tomadas: paleta, tipografía, criterio de animación, radios, reglas de mobile, metodología de entrenamiento y los pendientes abiertos.
2. **`contexto.md`** — quién es Jimena, a qué público le habla y cuál es el objetivo del proyecto.

Buena parte de lo que parece una mejora obvia ya se evaluó y se descartó por un motivo escrito. Revisar antes de proponer evita repetir esa conversación.

## Reglas que no se negocian

• **El contenido tiene que ser visible sin JavaScript.** Las animaciones son mejora progresiva. El `opacity:0` nunca va en una regla base, solo dentro de un `@keyframe`. Hay una red de seguridad de 2 segundos en el script que revela todo aunque el observador falle.
• **CSS antes que JavaScript** para cualquier animación o interacción. El toggle de planes, por ejemplo, son dos radios y `:checked`, sin una línea de JS.
• **Respetar `prefers-reduced-motion`** en todo lo que se anime.
• **Nada tocable por debajo de 44px de alto** en mobile, y probar desde 360px de ancho.
• **No se publican datos de alumnas**: nombres completos, condiciones de salud, mediciones ni contacto. Son datos de terceros y el repositorio es público.

## Cómo verificar un cambio

El sitio es un solo archivo, `docs/index.html`. Para verlo:

```bash
cd docs && python3 -m http.server 8899
```

Y abrir `http://localhost:8899/index.html`. **Medir en vez de mirar**: varios errores de esta etapa (una palabra desalineada 5px, un botón de 43px, una sección 19px más alta en un estado del toggle) eran invisibles a ojo y aparecieron midiendo el DOM.

## Dónde está cada cosa

| Carpeta | Qué hay |
|---|---|
| `docs/` | El sitio. GitHub Pages publica desde acá, así que todo lo que se pushea está en vivo en un minuto |
| `estrategia/` | Propuesta de valor y business case |
| `product-discovery/` | Cómo se llegó a cada decisión: investigaciones, benchmarks y opciones descartadas |
| `herramientas/` | Planillas Excel de uso interno con las alumnas |
