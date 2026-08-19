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
• **No se publican datos de alumnas sin autorización de ellas.** Nunca, ni con autorización: condiciones de salud, mediciones y datos de contacto. Con autorización explícita pedida por Jimena, y solo eso: nombre, edad, país, foto y la cita. Son datos de terceros y el repositorio es público, así que la autorización queda registrada junto a cada cita (campo `autorizacion` en `herramientas/build-testimonios.py`).

• **Un testimonio se carga siguiendo `testimonios.md`**, que está en la raíz. Lo primero es pedir los cinco campos —texto, nombre, edad, país, foto— y la autorización. La cinta se genera con `python3 herramientas/build-testimonios.py`: no se edita a mano, porque al sumar una tarjeta hay tres números que se recalculan y que ya rompieron la sección en producción.

## Cómo verificar un cambio

El sitio es un solo archivo, `docs/index.html`. Para verlo:

```bash
python3 qa-local.py          # http://localhost:8899/index.html
```

Ese script sirve `docs/` con `Cache-Control: no-store` y **recarga la pestaña sola** al guardar. Las dos cosas importan: el CSS va inline en el HTML, así que sin el no-store se termina mirando estilos viejos sin darse cuenta.

**No pushear para revisar.** GitHub Pages sirve `main/docs`, así que todo lo que se pushea queda publicado en un minuto. El acuerdo del 18/08/2026 es: editar → mirar en `localhost:8899` → recién con el visto bueno, commit y push.

**Medir en vez de mirar**: varios errores de esta etapa (una palabra desalineada 5px, un botón de 43px, un hueco de la cinta que solo aparecía en monitores anchos) eran invisibles a ojo y aparecieron midiendo el DOM. Y medir en *un solo* caso no alcanza: el hueco de la cinta se dio por bueno midiendo a 1280px, que era justo el ancho donde la condición se cumplía.

## Dónde está cada cosa

| Carpeta | Qué hay |
|---|---|
| `docs/` | El sitio. GitHub Pages publica desde acá, así que todo lo que se pushea está en vivo en un minuto |
| `estrategia/` | Propuesta de valor y business case |
| `product-discovery/` | Cómo se llegó a cada decisión: investigaciones, benchmarks y opciones descartadas |
| `herramientas/` | Planillas Excel de uso interno con las alumnas, y el generador de la cinta de testimonios |
