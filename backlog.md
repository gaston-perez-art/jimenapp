# Backlog por área

> Vista del proyecto agrupada por área, no por owner ni por fecha. Los pendientes salen de `memory.md`, que sigue siendo la fuente de verdad: si algo de acá lo contradice, gana `memory.md`. Para ver quién hace qué y cuándo, la vista complementaria es `gantt.md`.
>
> Criterio de agrupación: "ajustar la web" es una tarea de producto (cambiar algo que ya existe en `docs/index.html`). Growth y Negocio son decisiones que después *se reflejan* en la web, pero no son en sí mismas un cambio de código — son la razón por la que el código va a cambiar.
>
> **Desde el 17/08/2026 hay una fecha de lanzamiento: el 23/08 el sitio tiene que estar en vivo con dominio propio.** Eso parte este backlog en dos sin cambiarlo de lugar: antes del 23 entra solo lo que impide publicar, el resto sale después sobre la página ya viva. Qué cae de cada lado está en `gantt.md`.
>
> Última actualización: 18/08/2026.

## Producto — Web

Ajustes directos sobre `docs/index.html`, sin decisión de negocio pendiente detrás.

- [x] 🔴 **Reemplazar el número de WhatsApp de ejemplo por el real** (15/08/2026). Link con mensaje pre-cargado, en los dos botones (hero y contacto). Ver `memory.md`.
- [x] 🔴 **Agregar el enlace real de Instagram** (15/08/2026): `instagram.com/pf.jimenaibanez`, en el footer y en la nota de contacto.
- [x] **Ícono de WhatsApp roto (de nuevo, 15/08/2026).** No era el mismo bug del 14/08: esta vez el `path` completo igual se deformaba a 18px porque era un dibujo hecho a mano. Reemplazado por el glifo estándar de la marca.
- [x] **Microcopy del hero desencajado** (pedido de Gastón, 15/08/2026): estaba al lado del botón y en mono, así que flotaba y leía como etiqueta técnica. Ahora va debajo del CTA, en Archivo, con un check en bronce.
- [ ] 🟡 Decidir si el CTA del nav ("Escribime") va directo a WhatsApp o sigue scrolleando a `#contacto` — hoy es lo único que agrega un paso, contra el criterio del 14/08
- [x] Sacar los eyebrows ("Mujeres +35", "Sobre mí", "Testimonios", "Cómo trabajo", "Programa") que no aportaban valor — pedido de Jimena (14/08/2026). Se limpió también el CSS asociado (`.eyebrow`, animación de entrada del hero, override mobile) que quedó sin uso.
- [x] **Bug: botón "Quiero mi cambio" del hero.** Funcionaba (scrolleaba a la sección de contacto), pero eso era un paso de más para convertir — ahora abre WhatsApp directo, igual que el botón de la sección de contacto (14/08/2026, decisión de Gastón).
- [x] **Bug: ícono de WhatsApp roto en el botón de "Escribime y arrancamos".** El `path` del SVG estaba cortado a la mitad, faltaba el detalle del teléfono adentro de la burbuja. Se corrigió copiando el `path` completo que ya se usaba en el botón del hero (14/08/2026).
- [x] **Bug encontrado sin estar pedido: el menú hamburguesa de mobile no aparecía entre 401px y 720px de ancho** (celulares grandes, iPhone Pro Max incluido) — el nav de escritorio se pisaba con el logo en ese rango. El breakpoint del hamburguesa estaba mal alineado (max-width:400px) contra el resto de las reglas de mobile (max-width:720px). Corregido moviendo las reglas al breakpoint de 720px (14/08/2026).
- [x] **Bug de la animación del claim del hero, arreglado (14/08/2026).** La causa real no era el `clip-path` (ese margen alcanza). Era que `opacity` y `transform` cambiaban al mismo tiempo en la transición: a mitad de camino la palabra quedaba medio transparente y medio desplazada, y ese "fantasma" pisaba el texto de arriba. Se desacoplaron los tiempos dentro de `@keyframes rotWord` (paradas nuevas en 4% y 33%) para que el desplazamiento grande pase siempre en `opacity:0`. Verificado con la Web Animations API y visualmente, en varios anchos. Mismo timing global, misma duración, mismo `cubic-bezier` — no cambió la sincronización entre palabras.
- [ ] 🟡 Decidir dónde va la foto real de Jimena en el hero (el espacio "signature" ya lo ocupa el video de alumnas)
- [x] 🟡 **Hacer más armónica la sección "Sobre mí"** (15/08/2026). Layout resuelto: foto de cuadrada a retrato 4:5 (el desbalance entre columnas pasó de 124px a 28px), título de 4 líneas a 2, cita con más presencia, y corregido el recorte apaisado que aplastaba el retrato en tablet y mobile. Ver `memory.md`.
- [ ] 🔴 **Foto nueva de Jimena para "Sobre mí" — pedírsela a ella.** El layout ya está resuelto, pero la foto actual es una toma casual en la vereda (ropa de calle, auto y portón de fondo, sin contexto de entrenamiento) y contradice el posicionamiento profesional del resto de la página. Ningún ajuste de CSS lo arregla. Pedir: foto entrenando o en el gimnasio, vertical, con ella ocupando buena parte del cuadro. **Al reemplazarla hay que recalibrar el `transform:scale` y el `object-position` de `.foto-ph img`, que están ajustados a mano para la foto actual.**
- [ ] 🟢 Nueva sección antes de "En qué me especializo" con logos animados (marquee) de las empresas de prestigio donde trabajó Jimena — **necesita que Jimena pase los logos/autorización**
- [ ] 🟡 Reescribir "En qué me especializo" — hoy es una lista de tags que no cuenta nada (pedido de Jimena, 14/08/2026)
- [x] 🟡 Testimonios: sumar fotos de las alumnas y hacerlos menos genéricos — benchmark pasado por Jimena: Coderhouse, reseñas de Airbnb, sariadnapascual.com. **Rediseñada y publicada (18/08/2026):** la grilla de tres tarjetas pasó a ser una cinta horizontal que se desplaza sola, se relentece al pasar el mouse y se puede arrastrar. **Segunda pasada (19/08/2026), con las cinco citas que pasó Gastón:** la tarjeta tomó la forma de la referencia de Coderhouse — foto redonda, nombre, edad y país con bandera en SVG — y la cinta pasó de 2 citas a 4 (duración 22s→45s, grupos 6→4). Ver `memory.md`. Las fotos entraron el 19/08 (falta `daiana.jpg`), recortadas a la cara y bajadas a 256px: 192 KB → 60 KB. **Cerrada.**
- [x] 🔴 **Datos concretos de las alumnas** — llegaron el 19/08/2026. Silvia mandó su historia completa (2020 sola con videos → 2023 clases en vivo → hace 2 años una a una con Jimena) y con eso el destacado dejó de ser un diseño esperando contenido: la franja de abajo pasó de tres hechos del programa a la línea de tiempo real de ella. El dato fisiológico del 1-2% de masa muscular queda libre para la sección Programa, y **sigue sin fuente citada**.
- [x] 🔴 **Autorización de las cinco alumnas** — confirmada por Gastón el 19/08/2026. Queda registrada por cita (campo `autorizacion` en `herramientas/build-testimonios.py`) y la regla de `CLAUDE.md` se reescribió para que diga lo que de verdad se hace. **No van al sitio ni en una página de legales:** exponerlas publica más datos de las alumnas, que es lo contrario de lo que se busca.
- [ ] 🟢 **Falta `daiana.jpg`** en `docs/img/testimonios/`. Su tarjeta muestra las iniciales mientras tanto, así que no bloquea nada.
- [ ] 🟢 **Propuesta sin implementar: una línea en el footer** — "Los testimonios son textuales y se publican con autorización de sus autoras". Es la parte de las autorizaciones que le sirve a quien lee. Sin hacer porque no se toca el sitio sin que Gastón lo mire primero.
- [x] 🟡 **Proceso de carga de testimonios** (19/08/2026): `testimonios.md` en la raíz con los cinco campos que hay que pedir, y `herramientas/build-testimonios.py`, que genera la cinta desde una única lista y recalcula solo los tres números que se rompen al sumar una tarjeta. Gastón está esperando más citas, así que era lo que faltaba para que sumarlas no sea un riesgo cada vez.
- [~] 🟡 Sumar más animación en general y jugar más con contraste de color — Jimena sugiere empezar por el botón de WhatsApp. **En curso (15/08/2026):** botones y CTAs pasaron a gradiente wine→bronze con desplazamiento en hover, el CTA del hero suma un pulso de entrada, y la sección de contacto es el primer bloque de color fuerte del sitio (antes todo alternaba entre dos crema casi iguales). Benchmark: Coderhouse (AI Builders Program) y entrenadoranoeliarodriguezfit.com. Ver `memory.md`. **Segunda pasada (15/08/2026):** "Cómo trabajo" pasó a ser la única sección oscura del sitio (gradiente wine-950→wine-900), que era la causa de fondo del "parece de juguete" — antes todas las secciones alternaban entre dos crema casi iguales. El recorrido ahora tiene ritmo: crema → crema-dim → oscuro → crema-dim → crema con CTA oscuro. Además el recorrido de la animación de aparición pasó de 16px a 34px, que es la diferencia entre "tiene animaciones" y "se nota". Falta: la pasada de "Sobre mí" / gráficos / mobile siguen abajo en la lista.
- [x] **Bug encontrado sin estar pedido (15/08/2026): las animaciones de scroll ya programadas casi nunca se veían.** La red de seguridad del script revelaba todo el contenido a los 2 segundos de cargar la página, sin importar el scroll — cualquier persona real tarda más que eso en llegar a una sección de abajo, así que la transición ya había pasado antes de que la vieran. Subido a 8000ms y verificado que el `IntersectionObserver` real dispara en ~400ms. De paso se sumó animación en cascada a dos listas que aparecían de golpe sin ninguna transición (`esp-lista`, `programa-feats`). Ver `memory.md`.
- [ ] 🟡 Mejorar todos los gráficos del sitio (pedido de Jimena, 14/08/2026 — sin especificar cuáles; a definir con ella qué gráficos hay hoy y qué se espera)
- [x] 🔴 **Pasada de sistema visual: clean, premium, salud** (18/08/2026). Blanco como superficie dominante en vez de dos cremas, títulos de peso 700 a 500 con escala bastante más grande, botones en píldora, una sola curva de easing y header en vidrio esmerilado. Salió de medir los tokens de `joinmidi.com` y `superpower.com`. Ver `memory.md`
- [x] 🟡 **Testimonios: cinta arrastrable con hover que la relentece** (18/08/2026). Ver `memory.md` para los dos bugs que costaron (el salto de `animation-duration` y la animación CSS pisando el `style` inline)
- [ ] 🟡 Mejorar la sección de contacto "Escribime y arrancamos"
- [ ] 🟡 **Revisar el resto del sitio con el sistema visual nuevo.** La pasada del 18/08 cambió los tokens de todo el sitio, pero solo se rediseñó Testimonios con ellos en mente. Hero, Sobre mí, Cómo trabajo y Programa funcionan pero no fueron repensados para la escala y el blanco nuevos
- [x] 🔴 **Pasada completa de mobile** (15/08/2026), hecha con viewport real de 390px vía harness con iframe. Encontró y arregló: el hero sin padding vertical en pantallas ≤400px (el shorthand de `.wrap` pisaba el de `.hero`, que lleva las dos clases), el mismo bug al revés en desktop entre 1180-1236px, un hueco de ~0,4s por relevo en la animación del claim donde no se veía ninguna palabra, Instagram con 15px de área táctil en la caja de contacto, y la comilla de los testimonios con 26px de aire muerto por heredar el line-height del body. Verificado: cero overflow horizontal y cero áreas táctiles bajo 44px. Ver `memory.md`.
- [ ] 🟢 Sección de descalificación: "esto no es para vos si..." (idea del benchmark)
- [ ] 🟢 Reordenar la web para arrancar por el problema de la clienta, no por la oferta (idea del benchmark)
- [ ] 🟢 Reemplazar el CTA "Escribime por WhatsApp" por una sesión de valoración gratuita por videollamada (idea del benchmark)
- [ ] 🟢 Mostrar las planillas de `herramientas/` como argumento de venta en la web

## Growth — Captación y comunidad

Todo lo que hace crecer la base de alumnas o sostiene a las que ya están, más allá del sitio.

- [ ] 🔴 Reglas de la comunidad de WhatsApp para alumnas activas: cuándo se abre el grupo, quién modera. Urgente porque ya se promociona como feature 06 del programa en el sitio en vivo y todavía no existe operativamente
- [ ] 🟡 Ponerle nombre al método de Jimena — hoy la metodología está documentada y no tiene nombre; sostiene precio y da identidad de marca
- [ ] 🟢 Capturar emails con una guía descargable de perimenopausia (idea del benchmark)
- [x] Primeros testimonios reales sumados: Silvia Rodríguez y Verónica Vázquez (13/08/2026)

## Negocio — Estrategia y pricing

Decisiones económicas y de posicionamiento. Viven en `estrategia/`.

- [ ] 🔴 Actualizar `estrategia/business-case.md` al programa único — hoy está escrito sobre los tres planes que ya no existen, y su hallazgo central (el techo del negocio lo fija el precio) depende de esa estructura
- [ ] 🟡 Medir las horas reales que consume al mes una alumna del programa, para confirmar si el precio único de USD 35/mes se sostiene
- [ ] 🟢 Descuento del 10% para docentes: falta definir alcance (¿Educación Física o docentes en general?) y si es permanente o de lanzamiento
- [ ] 🟡 Misión, visión y propósito
- [ ] 🟡 Business Model Canvas
- [ ] 🟡 FODA con competencia directa
- [x] Posicionamiento definido: especialización en salud hormonal femenina, +35 años (12/08/2026)
- [x] Precio único USD 35/mes confirmado, programa único reemplaza a los tres planes (13/08/2026)

## Operaciones — Infraestructura y herramientas internas

Lo que sostiene el negocio por detrás, sin ser ni web pública ni estrategia.

- [x] ✅ **Apuntar el dominio propio: hecho el 19/08/2026**, cuatro días antes de la fecha límite. **El sitio está en vivo en https://entrenaconjime.com**, con HTTPS y candado en el navegador. El `CNAME` quedó versionado dentro de `docs/`, los registros DNS en Cloudflare en *DNS only*, y el certificado se emitió en menos de un minuto en lugar de las 24h que se temían. La URL vieja de `github.io` redirige sola. Configuración completa en `memory.md`
- [x] ✅ **Instalar analytics: hecho el 19/08/2026.** Google Analytics 4 (`G-CNR32WF83Z`), midiendo visitas y además los clics a WhatsApp e Instagram, con el dato de si el clic pasó en el hero o al final del scroll. Sin banner de cookies (ley 25.326, no GDPR). Detalle y advertencia para cuando se toquen los CTA, en `memory.md`
- [ ] 🟢 Sumar planillas de seguimiento de progreso (medidas, fotos, hábitos, fuerza) a `herramientas/`

## Cómo leer las prioridades

🔴 bloqueante hoy · 🟡 importante, sin apuro fijo · 🟢 idea evaluada, sin decidir si entra

La única dependencia dura entre áreas: el business case (Negocio) no se puede cerrar bien hasta no tener las horas reales de una alumna (también Negocio), y el nombre del método (Growth) conviene resolverlo antes de tocar mucho más copy de la web (Producto), para no reescribir dos veces.
