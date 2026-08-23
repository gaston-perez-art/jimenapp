# Memoria del proyecto

Registro vivo de decisiones ya tomadas, para no repetir trabajo ni contradecir cosas definidas. Se actualiza a medida que el proyecto avanza.

## Antes de empezar a trabajar: `git pull`

**Siempre hacer `git pull` antes de tocar cualquier archivo.** Vale también para un asistente de IA que esté leyendo este archivo: si estás por editar algo de este repo, hacé el pull primero.

La misma regla está en **`CLAUDE.md`**, en la raíz del repositorio, que Claude Code carga solo cada vez que se abre el proyecto. Es el mecanismo que hace que la regla se cumpla sin que nadie tenga que acordarse de pedirla.

No es solo por la web. Cambian también `contexto.md`, este mismo `memory.md` y el `README.md`, y trabajar sobre una versión vieja de cualquiera de ellos significa reescribir decisiones que el otro ya tomó.

## Cómo trabajamos los dos

Somos dos personas (Jimena y Gastón) y trabajamos **directo sobre `main`**, sin branches ni pull requests. La decisión es deliberada: para un proyecto de este tamaño el flujo de branches agrega más ceremonia que valor.

Lo que sostiene ese acuerdo:

• **Nos avisamos antes de empezar.** No editar en paralelo — sobre todo `docs/index.html`, que es un solo archivo con todo el HTML, CSS y JS adentro. Dos ediciones simultáneas ahí generan un conflicto que git no puede resolver solo.
• **Pull al empezar, push al terminar.** Sesiones cortas y cerradas. Acumular cambios sin pushear durante días es lo que rompe el acuerdo.
• **`main` es lo que está publicado.** GitHub Pages sirve `main/docs`, así que todo lo que se pushea está en vivo un minuto después. No pushear cosas a medio hacer.

**Si el push sale rechazado** (`rejected` / `fetch first`), significa que el otro pusheó algo mientras trabajabas. No es un error: hacé `git pull` y volvé a pushear.

Para que el pull no genere commits de merge innecesarios, conviene configurar una vez por máquina:

```
git config pull.rebase true
```

## Ver los cambios antes de publicar: `qa-local.py`

**Decisión de Gastón del 18/08/2026, y cambia cómo se trabaja.** Hasta ese día cada cambio se commiteaba y pusheaba para poder mirarlo, y como GitHub Pages sirve `main/docs`, eso significaba **publicar para revisar**. Varias iteraciones de diseño salieron en vivo a medio hacer por ese motivo.

Ahora hay un servidor de QA local en la raíz del repo:

```bash
python3 qa-local.py          # http://localhost:8899/index.html
```

Hace dos cosas que `python3 -m http.server` no hace:

• **Manda `Cache-Control: no-store`.** Sin esto el navegador se queda con la versión vieja — todo el CSS va inline en `index.html`, así que uno termina mirando estilos de hace dos ediciones sin enterarse. Es el mismo problema que ya estaba anotado para el harness de mobile.
• **Recarga la pestaña sola** cuando cambia cualquier archivo de `docs/`. Inyecta un script chico en la respuesta HTML que consulta `/__cambios` una vez por segundo. **La inyección pasa solo en la respuesta del servidor: el archivo en disco no se toca**, así que no hay forma de que se cuele en lo que se publica (verificado: `grep "__cambios" docs/index.html` da 0).

**El flujo acordado:** editar → Gastón mira en `localhost:8899` → recién cuando aprueba, commit y push.

**Límite que hay que respetar:** `main` es compartido con Jimena y `docs/index.html` es un solo archivo con todo adentro. Guardarse cambios locales durante días y que ella pushee mientras tanto genera un conflicto feo. La regla práctica es **guardar local mientras se QA'ea, pushear el mismo día**, y `git pull --rebase` antes de retomar.

## Decisiones de diseño (página web)

**Paleta de colores:**
- `--wine-900: #5C1F32` — texto de énfasis, títulos
- `--wine-600: #9D3A57` — color de marca principal (botones, acentos)
- `--wine-100: #F3E4E9` — fondos suaves
- `--bronze: #A9824A` — acento secundario (detalle "metal de disco de pesa")
- `--ink: #241F26` — texto de cuerpo
- `--paper: #FAF6F2` / `--paper-dim: #F1E9E1` — fondos alternados por sección

**Tipografía:** decidida y aplicada el 11/08/2026.

- Display (títulos): **Archivo** (grotesca ancha, Google Fonts)
- Cuerpo: **Archivo**
- Detalles/datos (eyebrows, labels): IBM Plex Mono. Se mantiene sin cambios: refuerza el posicionamiento "basado en evidencia" y es lo que hacen Equinox y Stripe.

Reemplaza a Fraunces + Work Sans. El motivo no fue estético: de 12 sitios de referencia relevados, 11 usan grotesca sans en los títulos, y Fraunces empujaba la lectura hacia *wellness artesanal* cuando el contenido habla de periodización y RPE. El proceso completo, con el benchmark y las opciones descartadas, está en `product-discovery/01-tipografia/`.

**Pasada de sistema visual: "clean, premium, salud" (18/08/2026, decisión de Gastón).** Después de cuatro iteraciones sobre la sección de testimonios que Gastón siguió rechazando, quedó claro que **el problema nunca fue la sección: era el sistema de tokens.** Cualquier sección construida sobre crema cálido con títulos en peso 700 a 36px se lee igual de genérica por más que se reordene.

Se relevaron **de verdad** (mirando el diseño, no leyendo el contenido) las dos referencias que marcó Gastón, `joinmidi.com` y `superpower.com`, extrayendo los tokens computados del DOM. Lo que se midió:

| | Midi | Superpower | jimenapp antes |
|---|---|---|---|
| Display | 154px | 56px | 36px |
| Peso del display | 900 condensada | **400** | **700** |
| line-height display | 0.78 | 1.00 | 1.08 |
| Familias | 4 con roles | **1 sola** | 2 |
| Superficie dominante | blanco + `#F7F7F1` | blanco + `#FAFAFA` | crema `#FAF6F2`/`#F1E9E1` |
| Cuerpo | 19px / 1.5 | 15-17px / 1.4 | 16px / 1.6 |
| Botones | píldora 999px | píldora 999px | 10px |
| Easing | — | `cubic-bezier(.16,1,.3,1)` | `cubic-bezier(.22,.61,.36,1)` |

**Tres hallazgos que cambian criterios ya escritos acá:**

1. **Superpower no usa una sola animación ligada al scroll.** Cero: 26 animaciones, todas en `DocumentTimeline`, y el navegador soporta `view()`. Lo premium ahí no viene de más movimiento sino de restricción — una sola curva de easing, y solo `opacity` y `transform`. Esto respalda haber revertido el scroll-driven de testimonios.
2. **El peso 700 era el enemigo.** Los dos caminos premium son opuestos y ninguno pasaba por donde estábamos: Superpower usa **peso 400 a 56px**, Midi **900 condensada a 154px**. El 700 a 36px es el default de cualquier landing. **Se eligió el camino Superpower** (decisión de Gastón): liviano y grande. El contraste lo da el tamaño, no la negrita. Ventaja práctica: Archivo ya está cargada en 400/500/600/700, así que no costó una familia nueva.
3. **El blanco no era un detalle, era la base.** Las dos referencias son blanco-dominante con un segundo neutro casi indistinguible. El sitio no tenía **ninguna** superficie blanca salvo las tarjetas: alternaba dos cremas cálidos y cercanos. Es la misma causa raíz que ya se había diagnosticado el 15/08 ("el sitio se lee monocromático") y que en su momento se atacó solo con la sección oscura, dejando el crema intacto.

**Los seis cambios aplicados, todos de token:**

• `--paper` de `#FAF6F2` a **`#FFFFFF`**, `--paper-dim` de `#F1E9E1` a **`#FAF8F6`**. El calor de la marca ahora lo aportan el vino y el bronce, no el fondo.
• `--line` de `#E3D7C9` a `#E9E4DE`: sobre blanco el anterior tiraba a amarillo. Los SVG del panel de "Cómo trabajo" tenían ese color hardcodeado y se actualizaron también.
• `h1,h2,h3` de peso **700 a 500**, `letter-spacing` de `-.025em` a `-.02em`, `line-height` de `1.08` a `1.02`.
• Escala más agresiva: `.section-head h2` de `clamp(26,3vw,36)` a `clamp(32,4.4vw,60)`; hero `h1` a `clamp(38,5vw,68)`; `.sobre-texto h2` a `clamp(27,3vw,40)`; `.pin-slide h3` a `clamp(30,3.6vw,50)`; la cita del destacado a `clamp(26,3vw,42)` en peso 400.
• **Botones en píldora**: token nuevo `--r-pill:999px` en `.navcta`, `.btn-primary`, `.btn-ghost` y `.programa-cta`.
• Easing único `cubic-bezier(.16,1,.3,1)` (expo-out) reemplazando las 11 apariciones de `cubic-bezier(.22,.61,.36,1)`, e interlineado del cuerpo de 1.6 a 1.5.

**Restos de la paleta crema, encontrados despues (18/08/2026).** Cambiar los tokens `--paper` y `--paper-dim` no alcanzo: habia **tres superficies con el degrade viejo hardcodeado**, `linear-gradient(160deg, var(--wine-100), var(--bronze-soft))`, o sea rosa a beige. Sobre el sitio ya blanco se leian como una mancha de otro color.

• **`.programa-top`** (la franja del precio) era la unica que se veia, y quedaba como una banda crema en el medio de una tarjeta blanca. Ahora es `var(--card)` y la separacion la hace la linea de abajo, no un fondo: es como resuelven el bloque de precio las dos referencias.
• **`.hero-video`** y **`.foto-ph`** solo asoman mientras carga el video y la foto. Pasaron a `var(--paper-dim)`.

**Como quedo el mapa de superficies, medido en el DOM:** body/hero, `#sobre` y `#contacto` en **blanco puro**; `#testimonios` y `#servicios` en `#FAF8F6`; todas las tarjetas y la franja del precio en blanco; el header en blanco al 93%. Las dos unicas superficies de color son el panel oscuro de la cita y `#proceso`. **Leccion: al cambiar tokens de color hay que buscar ademas los valores hardcodeados y los degrades, que no se mueven solos.**

**Dos bugs de esa misma pasada, encontrados al revisar despues de pushear (y corregidos):**

• **El header se volvia una banda malva sobre `#proceso`, con el logo casi ilegible.** A `rgba(255,255,255,.72)` con `saturate(180%)`, el vidrio **toma el color de lo que tiene detras**: sobre la unica seccion oscura del sitio, el blanco se teñia de vino y el logo en `--wine-900` perdia contraste. El header anterior no tenia el problema porque estaba al 92% de opacidad. Corregido a `.93` y sin `saturate`. **Si alguna vez se baja de `.9`, hay que revisar SIEMPRE el header sobre `#proceso`.**
• **Los labels en mono daban 3.51:1 de contraste**, debajo del minimo de 4.5 para texto chico, y estan a 11-13px que es el peor caso. No lo introdujo la pasada — `--bronze` (#A9824A) sobre fondo claro ya fallaba antes, sobre crema tambien — pero se arreglo ahora: token nuevo **`--bronze-text:#8A6636`** (5.2:1) para texto chico sobre fondo claro. El `--bronze` normal se sigue usando para lo que no es texto: iconos, lineas, el punto del logo.

Ademas el precio (`.programa-top .n`) era el unico peso 700 que quedaba desentonando con el sistema nuevo: paso a 500 y de 42 a 52px, que es como se compensa el peso con tamaño en todo el resto.

**Verificacion de esta pasada (la que faltaba hacer antes de pushear):** contraste medido en 10 pares de texto/fondo, todos por encima del minimo; cero overflow horizontal y cero areas tactiles bajo 44px a 390px; ningun titulo desbordado; y la invariante de "contenido visible sin JS" chequeada estaticamente sobre el CSS — los unicos `opacity:0` fuera de `@keyframes` y fuera de `.has-js` son `.rot-w` y `.pin-slide`, y los dos tienen respaldo explicito (`.rot-3{opacity:1}` en reduced-motion, y la primera `.pin-slide` viene con `.on` en el HTML).

**El header pasó a vidrio esmerilado:** era `rgba(250,246,242,.92)` hardcodeado, o sea una banda de crema opaco sobre un sitio ya blanco. Ahora es `rgba(255,255,255,.72)` con `backdrop-filter:blur(24px) saturate(180%)`, que es como lo resuelven las dos referencias.

Verificado a 390px después de la pasada: cero overflow horizontal, nada se sale del viewport y ningún área táctil por debajo de 44px.

**Header:** 66px de alto, sticky. Achicado desde los 78px originales para que el hero y las secciones entren en una pantalla. Si se toca, hay que actualizar también el `top` del menú desplegable de mobile y el `top` del panel fijo del proceso, que dependen de ese número.

**Hero:** tiene `min-height` igual a la pantalla útil (`100svh` menos el header), para que la sección siguiente no asome en el primer scroll. Se usa `svh` y no `vh` porque en mobile `vh` no descuenta la barra de direcciones.

**Hero, lista de bullets (12/08/2026):** debajo del `p.lead` hay un `ul.hero-bullets` de tres ítems cortos ("Sin pasar hambre...", "Sin entrenar todos los días", "Adaptado a tus hormonas..."), con el mismo punto redondo que `esp-lista`. Entra en la secuencia de animación del hero entre el lead (`.30s`) y los botones (`.42s`), en `.36s`. Si se agregan o sacan bullets, no hace falta tocar la animación — es una sola regla para toda la lista, no una por ítem.

**Radios y profundidad (decisión de Gastón, 11/08/2026):** el sitio pasó de esquinas casi rectas (`--radius: 2px`) a un sistema redondeado y más suave, en la línea de Airbnb sin exagerar. Escala de tres valores:

• `--r-sm: 10px` — botones y CTA del nav
• `--r-md: 14px` — tarjetas y cajas, y todas las superficies en mobile
• `--r-lg: 20px` — superficies grandes en desktop (gráfico de progresión, caja de contacto)
• Chips y etiquetas van en pastilla completa (`999px`)

La suavidad la aportan dos sombras muy bajas (`--shadow-sm` y `--shadow-md`), no bordes más gruesos ni colores más claros. La sombra grande aparece solo en hover de tarjeta.

**Botón "Quiero mi cambio" del hero (cambiado 14/08/2026, pedido de Jimena):** antes scrolleaba a `#contacto` (funcionaba, pero era un paso de más). Ahora abre WhatsApp directo, igual que el botón de la sección de contacto — mismo número de ejemplo, mismo `target="_blank"`.

**Bug arreglado (14/08/2026): ícono de WhatsApp roto en el botón de "Escribime y arrancamos".** El `path` del SVG estaba cortado a la mitad — le faltaba el tramo que dibuja el detalle del teléfono adentro de la burbuja, así que se veía como una burbuja vacía. El botón del hero tenía el `path` completo; se copió de ahí.

**Elemento distintivo (signature), actualizado 13/08/2026 por pedido de Jimena:** antes era un gráfico de barras ascendente mostrando una progresión de carga en sentadilla semana a semana. Se descartó porque la etiqueta ("PROGRESIÓN REAL DE UNA ALUMNA") afirmaba un resultado real que todavía no existía — Jimena está pre-lanzamiento, sin alumnas en ese momento (ver más abajo, ahora sí las tiene y dio autorización). Se reemplazó por un `<video>` (clase `.hero-video`, formato vertical 3:4, 720x960, `max-width:340px` — pedido explícito de Jimena de que la caja sea chica, no ocupa toda la columna) con tres alumnas reales entrenando, autorizadas por ellas a aparecer en el sitio. Archivo final: `docs/video/alumnas-entrenando.mp4` + poster `docs/img/alumnas-entrenando-poster.jpg` — ver el pendiente resuelto más abajo para el detalle de edición. Hasta que un video cargue, se ve un placeholder "Video próximamente" (`#videoPh`) que se oculta solo por script en cuanto el `<video>` dispara `loadeddata`. Autoplay respeta `prefers-reduced-motion` (si el usuario lo pidió, el video queda pausado en el poster).

**Principio técnico importante:** todo el contenido de la página es visible por defecto en el HTML/CSS. Las animaciones (aparición al hacer scroll, barras que crecen) son una mejora progresiva que se agrega solo si el JavaScript corre correctamente, con un timeout de seguridad — así un fallo de JavaScript nunca deja la página en blanco.

**Animación: criterio del proyecto (decisión de Gastón, 11/08/2026).** Se anima sin timidez, la animación es parte de la identidad del sitio y no un adorno opcional. Lo que se mantiene firme, porque es correctitud y no cautela:

• Preferir CSS puro sobre JavaScript. Una animación CSS no tiene el modo de falla que tiene el JS.
• El `opacity:0` nunca va en una regla base, solo dentro de un `@keyframe` con `fill-mode: both`. Si las animaciones no corren, el contenido queda visible igual.
• Todo lo que se anima respeta `prefers-reduced-motion`.
• Si un texto rota o se reemplaza, el texto completo vive en un `.sr-only` y la parte animada va con `aria-hidden`. Sin eso se rompen el SEO y los lectores de pantalla.

**Animaciones vigentes:** claim del hero rotando (fuerte → segura → vos, CSS puro, ciclo de 8,4s), entrada escalonada del hero al cargar, `.stagger` para que los hijos de una grilla entren uno detrás de otro y reveals al hacer scroll. *(Las barras del gráfico que crecían se sacaron el 13/08/2026 junto con el gráfico de barras — ver "Elemento distintivo" arriba.)*

**Claim del hero, detalle de diseño.** "Más" queda recto y fijo; la palabra que cambia va en **cursiva**, para separar tipográficamente lo constante de lo variable. La salida es un **rodillo vertical**: la palabra sube y se va, la siguiente entra desde abajo. Se evaluaron y descartaron el borrado letra por letra (con `steps()` corta los glifos al medio porque Archivo es proporcional, y lee "terminal" en vez de "entrenadora") y el barrido horizontal. Se eligió el rodillo porque empuja hacia arriba igual que el gráfico de progresión que está al lado.

**Bug arreglado (14/08/2026, a pedido de Jimena de "la animación quedó media rara").** La causa real no era el `clip-path` (ese margen de ~3-4px alcanza: a la posición final de salida, -105%, casi toda la palabra ya está clippeada). El problema era que `opacity` y `transform` cambiaban **al mismo tiempo** en el tramo de transición (31%→37% del ciclo): a mitad de camino la palabra quedaba medio transparente y medio desplazada, y ese "fantasma" semitransparente se veía pisando el texto de arriba durante ~0,3s de cada ciclo. Arreglado desacoplando los tiempos dentro del mismo `@keyframes rotWord`: se agregaron paradas intermedias (4% y 33%) para que el tramo largo del recorrido (de 28%/-28% a 105%/-105%) pase siempre en `opacity:0`, y el fundido solo cubra el tramo corto cerca del centro, donde la palabra todavía está casi en su lugar. Verificado programáticamente con la Web Animations API (`element.getAnimations()`, sampleando `currentTime` cada 50ms) y visualmente: ya no hay ningún instante con opacidad y desplazamiento grande a la vez. Se mantiene el mismo timing global (0/6/31/37/100%), la misma duración (8,4s) y el mismo `cubic-bezier`, así que el resto de la sincronización entre `rot-1/2/3` no cambió.

**Botones y bloque de contacto: sale el flat wine-600, entra gradiente wine→bronze (15/08/2026, sesión de "sitio muy estático y monocromático").** Benchmark de referencia: `entrenadoranoeliarodriguezfit.com` (bloque de color fuerte que corta la página, no solo variación de tono) y el AI Builders Program de Coderhouse (CTA en gradiente con desplazamiento en hover). Cambios:
- `.btn-primary` y `.programa-cta` pasan de `background:var(--wine-600)` sólido a `linear-gradient(135deg, var(--wine-600), var(--bronze))` con `background-position` animado en hover (el gradiente se desplaza, no solo oscurece) y sombra de color en vez de solo oscurecer.
- El CTA del hero suma un pulso de entrada (`ctaPulse`, dos iteraciones, arranca 1.5s después de que termina `heroIn`) para llamar la atención una sola vez, no en loop. Deshabilitado en el bloque de `prefers-reduced-motion` existente, mismo criterio que el resto del sitio.
- `.contact-box` ("Escribime y arrancamos") pasa de tarjeta blanca a un bloque con gradiente `wine-900 → wine-600 → bronze`, texto blanco y el botón invertido (fondo blanco, texto wine-900) para que siga siendo el elemento de mayor contraste ahí adentro. Es el primer bloque de color fuerte de todo el sitio — hasta ahora todas las secciones alternaban entre `--paper` y `--paper-dim`, dos crema casi iguales, que es la raíz técnica de por qué el sitio se leía monocromático aunque la paleta definida no lo fuera.
- Ningún cambio toca layout, `width`, `padding` ni las reglas del breakpoint de 720px — solo `background`, `color` y `box-shadow`, así que el mobile queda intacto sin necesidad de retocarlo.
- Continuación de esta línea, resuelta más tarde el mismo día: `#proceso` pasó a ser la única sección oscura del sitio (ver más abajo), así que el contraste ya no queda concentrado solo en el CTA final. `#servicios` y `#testimonios` siguen en paper/paper-dim y se decidió dejarlos así.

**Pasada completa de mobile (15/08/2026).** Se hizo con viewport real de 390px, no redimensionando la ventana: Chrome no baja de ~600px de ancho, así que se usó un harness temporal (`docs/_mobile-test.html`, un iframe de 390x844 apuntando a `index.html`, borrado al terminar). Al ser del mismo origen se puede medir por dentro con `contentWindow`, que es lo que permitió encontrar los bugs midiendo en vez de mirando. **Si hace falta repetir la pasada, conviene rearmar ese harness.** Ojo con el caché: el CSS va inline en el HTML, así que hay que recargar el iframe con un query string (`index.html?v=Date.now()`) o se siguen midiendo los estilos viejos.

**Bug importante encontrado en esa pasada: en pantallas ≤400px el hero se quedaba sin padding vertical.** El título terminaba pegado al header sticky, sin aire. La causa es de sistema, no del hero: `.wrap` definía su padding horizontal con el **shorthand** (`padding:0 16px`), y el hero es `<section class="hero wrap">` — lleva las dos clases. Como la regla de `.wrap` del breakpoint de 400px viene después en el archivo y tiene la misma especificidad, el shorthand pisaba el `padding:36px 0 48px` de `.hero` y le ponía el vertical en cero. **Arreglado pasando `.wrap` a longhand** (`padding-left`/`padding-right`) en los tres breakpoints, y `.hero` a longhand vertical (`padding-top`/`padding-bottom`). Ahora cada clase es dueña de un eje y no se pisan.
- El mismo bug existía al revés en desktop: el shorthand de `.hero` le comía el padding horizontal de `.wrap`. No se veía a 1440px porque `.wrap` tiene `max-width:1180px` y sobra margen, pero entre 1180px y ~1236px de viewport el texto tocaba los bordes. Resuelto con el mismo cambio.
- **Regla para el futuro: `.wrap` es dueña del eje horizontal y nunca debe usar el shorthand `padding`.** Hay al menos dos elementos que la combinan con otra clase (`section.hero.wrap` y `div.wrap.sobre-grid`).

**Hueco en la animación del claim del hero, corregido (15/08/2026).** Medido escrubeando la animación con la Web Animations API (`getAnimations()`, `pause()` y `currentTime`, sin esperas reales). Las tres palabras entran cada 1/3 del ciclo (delays 0 / 2.8 / 5.6s sobre 8.4s = 33.33%), pero las paradas del keyframe estaban en 4% y 33%: la cuenta daba 29% en vez de 33.33%, así que **cada relevo dejaba ~0,4s en que ninguna palabra estaba visible y el título se leía solo "Más"** — tres veces por ciclo, ~19% del tiempo. Era un efecto colateral del arreglo del fantasma del 14/08, no un problema nuevo. Corregido moviendo las paradas a 1% y 34.33%, que es exactamente `33.33% + 1%`: el instante en que una termina de desaparecer coincide con el que arranca la siguiente. Verificado: el tiempo sin ninguna palabra visible bajó de ~400ms a ~75ms por relevo (un parpadeo de 3-4 frames, que es el pulso normal del rodillo) **y se comprobó que no volvió el fantasma** (cero instantes con opacidad intermedia y desplazamiento grande). Se mantiene el principio del 14/08: el desplazamiento grande siempre en `opacity:0`.

**Otros arreglos de la misma pasada:**
- **Instagram en la caja de contacto pasó de link suelto a botón secundario** (`.btn-ghost`, outline blanco sobre el gradiente). Como link inline dentro de una frase medía 15px de alto tocable, muy por debajo del mínimo de 44px del proyecto; ahora mide 51px. De paso deja de esconder el canal público principal de Jimena en medio de una oración.
- **La comilla de las tarjetas de testimonio (`.testimonial-card .num`) heredaba el `line-height:1.6` del body.** Con `font-size:44px` la caja del glifo medía 70px para una comilla que ocupa la mitad, dejando un hueco muerto antes de la cita. Con `line-height:1` la caja bajó a 44px y cada tarjeta se acortó 27px. Se nota sobre todo en mobile, donde van apiladas.
- Verificado además: **cero overflow horizontal** a 390px y **cero áreas táctiles por debajo de 44px** en toda la página.

**"Sobre mí" reacomodada (15/08/2026, pedido de Jimena del 14/08 de hacerla "más armónica").** Se atacaron cuatro cosas concretas, todas medidas y no a ojo:
- **La foto pasa de cuadrada a retrato 4:5.** El original es 3:4 vertical (960x1280) y el cuadrado descartaba el 25% del alto. Esto además emparejó las columnas: el desbalance entre la columna de foto y la de texto pasó de **124px a ~28px**, que era la causa técnica de que la sección se viera "desarmada" (la foto terminaba mucho antes que el texto y dejaba un hueco).
- **El título pasa de 4 líneas a 2**, subiendo su `max-width` de 24ch a 32ch. Con 24ch, "Profesora Nacional de Educación Física, especializada en fuerza femenina" se partía en cuatro y leía como un muro de credencial en vez de como una frase.
- **La cita gana presencia** (15.5px → 16.5px): es la línea emocional de la sección y estaba compitiendo hacia abajo con la credencial en mono.
- **Se corrige el recorte en tablet y mobile.** La foto vertical se estaba aplastando a 4:3 (≤960px) y a 16:11 (≤720px) — para un retrato de cuerpo entero eso deja una banda horizontal con la persona cortada. Ahora mantiene el 4:5 en todos los breakpoints y se le pone techo de ancho (340px) para que al apilarse no ocupe todo el ancho de la columna (en tablet serían ~900px de alto).

**Límite conocido: la foto de "Sobre mí" no acompaña el posicionamiento.** El recorte y el layout ya están resueltos, pero la foto en sí es una toma casual en la vereda/entrada de una casa — ropa de calle, pose de foto social, auto y portón de fondo, sin ningún contexto de entrenamiento. Al lado de un título que dice "Profesora Nacional de Educación Física, especializada en fuerza femenina" y de una página que habla de periodización, RPE y Mifflin-St Jeor, resta credibilidad en vez de sumarla. **Es el techo de esta sección: ningún ajuste de CSS lo arregla.** Es el mismo motivo por el que ya se descartó una primera foto (selfie de espejo) el 13/08. Lo que hay que pedirle a Jimena es una foto con contexto de entrenamiento (gimnasio o entrenando), vertical, con ella ocupando buena parte del cuadro. Mientras tanto, los valores de `transform:scale(1.14)` y `object-position:50% 6%` de `.foto-ph img` están calibrados a mano **para esta foto puntual** y hay que recalibrarlos (o sacarlos) cuando se cambie.

**Datos de contacto reales puestos en el sitio (15/08/2026) — se cierran los dos bloqueantes de captación.** Los pasó Gastón:
- WhatsApp: `https://api.whatsapp.com/send?phone=541135863879&text=...`, con mensaje pre-cargado "🏋️‍♀️ Hola, me interesa entrenar con vos...". Va en los dos botones (hero y contacto). Ojo al editar: el `&` va escrito como `&amp;` en el HTML, y el texto va URL-encodeado.
- Instagram: `https://www.instagram.com/pf.jimenaibanez/`, en el footer y en la nota de la sección de contacto.
- Se sacó el cartel `placeholder-flag` ("Reemplazar por tu número real") y su CSS, que quedó sin uso.
- **Queda una decisión abierta:** el CTA del nav ("Escribime") sigue apuntando a `#contacto` en vez de a WhatsApp directo. Es deliberado por ahora (es un link de navegación), pero contradice en parte el criterio del 14/08 de que el CTA no debe agregar un paso. Revisar si conviene unificarlo.

**Ícono de WhatsApp: se reemplaza el `path` dibujado a mano por el glifo estándar (15/08/2026).** El `path` que había era una aproximación hecha a mano que a 18px se deformaba: la burbuja quedaba con trazo finito y el auricular de adentro mal resuelto, y se leía como una burbuja vacía y rota. Se reemplazó por el glifo estándar de la marca (viewBox 0 0 24 24, `fill="currentColor"`, sólido), que es el mismo que usa todo el mundo y aguanta bien el tamaño chico. Está en los dos botones. Nota: hereda `currentColor`, así que funciona igual en el botón con gradiente (blanco) y en el botón invertido de la caja de contacto (wine-900), sin reglas extra.

**Microcopy del hero ("Respondo personalmente cada consulta"), reacomodado (15/08/2026, pedido de Gastón: "quedó medio raro, desencajado").** Eran dos problemas juntos:
- Estaba **al lado** del botón en un flex horizontal con `gap:20px`. Al no tener relación visual con el CTA ni con nada más, quedaba flotando en el aire a media altura.
- Estaba en **IBM Plex Mono**. El mono en el proyecto es para datos y labels (`.pn`, `.esp-label`, `.credential`) y ahí refuerza el posicionamiento "basado en evidencia"; pero aplicado a una frase corrida la hacía leer como etiqueta técnica o texto de placeholder, no como la promesa humana que es.
Solución: `.herobtns` pasa a `flex-direction:column`, el microcopy va **debajo** del botón, en Archivo 13.5px, con un check chico en `--bronze` que lo ancla visualmente al CTA. En mobile se centra (`align-items:center`) para acompañar al botón, que ahí va a ancho completo. Verificado en desktop y en viewport chico.

**"Cómo trabajo" pasa a ser la única sección oscura del sitio (15/08/2026).** Es el cambio de mayor impacto visual de esta sesión y ataca la causa de fondo del "parece de juguete": hasta ahora **todas** las secciones alternaban entre `--paper` (#FAF6F2) y `--paper-dim` (#F1E9E1), dos crema casi idénticos, así que por más animación que se sumara la página se leía plana. Ahora el recorrido tiene ritmo real: crema → crema-dim → **oscuro** → crema-dim → crema con el bloque oscuro del CTA final.
- `#proceso` va con `linear-gradient(170deg, var(--wine-950), var(--wine-900))`. Token nuevo `--wine-950:#3E1422`.
- Token nuevo `--bronze-light:#DCBA84`, que es el acento sobre fondo oscuro. `--bronze` (#A9824A) no tiene contraste suficiente contra el wine oscuro; se usa el claro para el paso activo, el indicador de progreso y las etiquetas `.pn`.
- Las tarjetas blancas `.pin-viz` y sus SVG **no se tocaron**: sobre el fondo oscuro pasan a ser el elemento de mayor contraste de la sección, que es exactamente el efecto buscado (mismo recurso que usa Coderhouse con el mockup de browser sobre fondo oscuro). Si alguna vez se editan esos SVG, tener en cuenta que sus colores están hardcodeados y asumen fondo blanco.
- Las inversiones de color van todas scopeadas bajo `#proceso ...`, sin tocar las reglas base de `.paso`/`.pin-prog`, para no afectar nada fuera de la sección.
- Verificado en desktop y en mobile (bajo el breakpoint de 720px, donde `.pin` se oculta y los pasos se leen como lista): el contraste se mantiene y no hubo que retocar el bloque de mobile.
- Queda pendiente evaluado y **descartado por ahora**: hacer también `#testimonios` oscuro. Dos secciones oscuras seguidas anularían el contraste que se acaba de ganar.

**Animación de aparición: 16px → 34px de recorrido (15/08/2026).** El `translateY` de `.reveal` era de 16px con easing lineal (`ease`), prácticamente imperceptible — el elemento llegaba a su lugar antes de que el ojo registrara que se había movido. Se subió a 34px con el mismo `cubic-bezier(.22,.61,.36,1)` que ya usa el resto del sitio, y la duración a .8s. Es la diferencia entre "tiene animaciones" y "se nota que tiene animaciones".

**Bug real encontrado y arreglado (15/08/2026): las animaciones de aparición al scrollear casi nunca se veían.** Gastón reportó que el sitio "sigue pareciendo de juguete" y que no notaba ninguna animación al scrollear, a pesar de que el sistema `.reveal`/`.reveal.stagger` ya estaba implementado (ver "Principio técnico importante" y el bloque de reveal más abajo). La causa no era falta de animación: era que la red de seguridad del script (`setTimeout(revealAll, 2000)`, pensada para revelar todo si el `IntersectionObserver` fallaba) disparaba a los **2 segundos de cargar la página**, sin importar el scroll. Cualquier persona real tarda más de 2s en llegar scrolleando a una sección de abajo — para cuando llegaba, esa sección ya estaba marcada `in-view` de antemano por el timeout, y la transición ya había pasado sin que nadie la viera. El sitio nunca mostraba lo que sí tenía programado. Arreglado subiendo el timeout a 8000ms (verificado: el observer real dispara en ~400ms al entrar en viewport, muy por debajo de eso, así que ahora gana la transición real casi siempre).

De paso se sumó `reveal stagger` a dos listas que hasta ahora aparecían de golpe sin ninguna animación, ninguna de las dos la tenía antes: `.esp-lista` (En qué me especializo, 8 ítems) y `.programa-feats` (las 6 features del programa, hoy aparecía como un solo bloque dentro de `.programa-card` en vez de cascada por ítem). Se extendió la tabla de `transition-delay` de `.reveal.stagger > *` de 6 a 8 hijos para cubrir `.esp-lista`. Nota técnica: ambas quedaron anidadas dentro de otro `.reveal` (`.sobre-grid` y `.programa-card` respectivamente) — funciona bien porque `opacity:0` del padre ya oculta visualmente al hijo aunque el hijo tenga su propio `opacity:1`, y el `IntersectionObserver` mide posición en el layout (no opacidad), así que ambos disparan casi al mismo tiempo sin conflicto.

**Eyebrows sacados del sitio (14/08/2026, pedido de Jimena).** Las etiquetas superiores ("Mujeres +35", "Sobre mí", "Testimonios", "Cómo trabajo", "Programa") no aportaban valor y se sacaron de las cinco secciones que las tenían. Se limpió también el CSS que quedó sin uso (`.eyebrow`, su animación de entrada en el hero, el override de mobile). Los `<h2>` de cada sección quedan como único encabezado.

**Testimonios: de grilla de tres tarjetas a cinta en movimiento (18/08/2026).** Gastón reportó que era la sección que menos le gustaba, que "no parece world class" y que no le hacía confiar en Jimena. El diagnóstico encontró tres problemas, ninguno estético de superficie:

- **Las tarjetas tenían borde punteado.** La clase se llamaba `.testimonial-card` y el comentario del CSS decía literalmente "placeholder cards": los dos testimonios **reales** se mostraban con el recurso visual universal de "acá todavía no hay nada".
- **La tercera tarjeta era un testimonio falso** ("Tu lugar está reservado acá") en el mismo contenedor que los dos verdaderos. Le decía a la visitante "solo tenemos dos" y contagiaba sospecha sobre los reales.
- **El `<h2>` prometía lo que la sección no mostraba:** "Mujeres reales, cambios reales" y debajo no había un solo cambio. Ahora dice "Lo que dicen las que ya entrenan conmigo", **sin subtítulo**: el que había ("Dos alumnas, sus palabras textuales") repetía el título con otras palabras y Gastón lo rechazó. Cualquier subtítulo que agregue algo necesita datos que todavía no existen, así que por ahora no va ninguno.

La forma nueva es una **cinta horizontal a todo el ancho de la pantalla** (`.t-mas` > `.t-cinta` > dos `.t-grupo`) que se desplaza sola hacia la izquierda. Detalles que hay que conocer antes de tocarla:

- **El loop no tiene salto porque hay seis grupos idénticos** y el recorrido es exactamente el ancho de uno, o sea `calc(-100% / 6)`. La separación entre tarjetas va como `gap` adentro del grupo y la separación **entre** grupos como `margin-right` del grupo: así cada grupo ocupa siempre (ancho + separación), la pista mide exactamente seis veces eso, y el recorrido es un porcentaje exacto sin ningún número mágico en píxeles.
- **Bug del 18/08/2026, encontrado por Gastón en su monitor: la cinta dejaba un hueco vacío a la derecha al llegar al final.** Con dos grupos la pista medía 1614px, y en cualquier pantalla más ancha que eso la cinta terminaba antes que el viewport. **La causa de fondo fue de verificación, no de CSS: se había medido solo a 1280px, que es justo el ancho donde la condición se cumplía.** La regla que hay que respetar al cambiar la cantidad de tarjetas es: `(grupos − 1) × ancho_de_grupo ≥ la pantalla más ancha donde se vaya a ver` — al correrse un grupo entero, lo que queda tiene que seguir tapando toda la pantalla. Con 6 grupos de dos citas eso da 4460px y cubre 4K (3840); con 5 daba 3568 y volvía a fallar en 4K por 272px. Verificado a 390, 1280, 1920, 2560, 3440 y 3840.
- El arreglo eliminó de paso el `calc(-50% - 13px)` anterior, que dependía del valor del `gap` y obligaba a un segundo keyframe (`marqueeMobile`) solo porque en mobile el gap es 16 y no 26. Ahora mobile solo cambia el `gap` y el `margin-right`, y el keyframe es uno solo.
- **La velocidad depende de cuántas tarjetas hay**, porque la duración es fija y el recorrido es el ancho del grupo. Con las dos citas de hoy, 30s dan ~27 px/s. Con 62s daban 13 px/s y no se leía como movimiento. **Al sumar testimonios hay que subir la duración en proporción o la cinta se acelera sola.**
- **Se frena con click o tap, no con hover.** Frenar al pasar el mouse convierte cualquier paso del cursor por la sección en un arranque y frenado que nadie pidió (decisión de Gastón, 18/08). Es la única interacción de la sección que necesita JavaScript: en CSS puro habría que abusar de un checkbox con un `<label>` tapando las tarjetas, y eso rompe la selección de texto de las citas. Si el JS no corre, la cinta sigue girando y no se pierde nada.
- **La cinta sigue andando en mobile.** Se evaluó apagarla y se descartó: al no depender del scroll no pelea contra el dedo, y resuelve que varios testimonios apilados sean varias pantallas de alto.
- **`prefers-reduced-motion` va último en la hoja de estilos, a propósito.** El marquee no depende de `animation-timeline`, así que queda fuera del bloque de reduced-motion de más arriba, y además se redefine en el breakpoint de 720px: si la regla fuera antes, cualquiera de las dos lo volvería a prender. Ahí no alcanza con frenar la cinta — una pista detenida deja la mitad de las tarjetas fuera de pantalla sin forma de llegar a ellas — así que además se esconde el grupo duplicado y las tarjetas se envuelven en varias filas.
- Se borraron las reglas `.cards`, `.card`, `.card:hover`, `.card .num/h3/p/.tag`, `.testimonial-card*` y `.testimonial-quote`, más sus overrides de mobile: ninguna otra sección las usaba (`.programa-card` es otra clase y no matchea `.card`).

**Interacción de la cinta (18/08/2026, tres iteraciones con Gastón mirando en local).** Referencia: la cinta de `coderhouse.com`. Quedó así:

• **El hover NO la frena, la relentece.** Baja a `0.28×` con una rampa de 450ms y vuelve a `1×` al salir. **No se puede hacer en CSS:** cambiar `animation-duration` en `:hover` produce un salto, porque el progreso es `currentTime / duration` y al cambiar la duración el mismo instante cae en otro punto del recorrido. Medido en esta cinta, el tirón habría sido del **73% del recorrido**. `updatePlaybackRate()` conserva la posición — medido: 0 ms y 0 px de salto.
• **Se arrastra con el mouse y con el dedo.** La primera versión falló de una forma engañosa: durante el gesto no se movía nada y recién al soltar aparecía en la posición nueva. **La causa es la cascada: una animación CSS le gana al `style` inline, también estando en pausa**, así que el `transform` de la animación pisaba el que escribía el arrastre. La solución fue dejar de tocar el `transform`: como la animación es lineal y recorre exactamente un grupo, arrastrar N píxeles equivale a mover el reloj, `dt = -dx × DUR / G`. **Se arrastra el tiempo, no la posición**, y al soltar no hace falta ninguna conversión porque la animación ya está en el momento correcto. El tiempo se envuelve en `[0, DUR)` para que arrastrar de más nunca llegue a un tope.
• **El cursor es flecha, no `grab` ni `pointer`** (pedido explícito de Gastón). La manito sugiere "esto se toca" y convierte la sección en algo para jugar; la flecha la deja como algo para leer. Se arrastra igual. Lo único que se mantiene es `user-select:none` mientras se arrastra, para que el gesto no termine pintando la cita de azul.
• **No hay pausa por click.** Se implementó y se sacó: agregaba un estado que nadie iba a descubrir y dejaba la cinta detenida sin aviso.
• **Las tarjetas no se resaltan en hover.** Se sacó el cambio de color del borde: la cinta entera ya responde al hover relentándose, y subrayar además la tarjeta de abajo del cursor es un segundo feedback para el mismo gesto, y sugiere que la tarjeta es clickeable cuando no lo es.
• **`touch-action: pan-y`** en la pista: el dedo vertical scrollea la página y el horizontal queda para la cinta. Sin eso, en mobile arrastrar la cinta scrollea la página y la cinta no se mueve.

**Velocidad: 22s por vuelta = ~41 px/s en desktop, ~28 en mobile** (el grupo es más angosto ahí). Se probaron 62s (13 px/s, no se leía como movimiento) y 30s (30 px/s, quedaba lento contra la referencia).

**Límite conocido de la sección: con dos testimonios la cinta se ve repetida.** La pista mide 1614px contra 1280px de pantalla, así que a cualquier altura se ven las dos citas y el arranque de la repetición. No es un bug del loop (cierra exacto, medido) sino falta de contenido. Se resuelve solo cuando Jimena pase más citas: se agregan al primer `.t-grupo` y se copian idénticas al segundo.

**Bloque destacado, publicado el 18/08/2026.** Arriba de la cinta va la cita de Verónica en grande, que aparece **línea por línea**, después la autoría, y después la franja de datos. La cita está cortada en líneas a mano pero es **textual**, no se editó.

**El destacado pasó a ser un panel oscuro (18/08/2026, segunda pasada).** Gastón miró la sección publicada y la rechazó entera. Dos causas concretas, las dos mías:

- **Un error de oficio en la alineación.** El `<h2>` arrancaba en x=205 y la cita en x=370, 165px más adentro y sin ningún motivo. Era un `margin:0 auto` sobre un bloque de 900px dentro de un contenedor de 1180 — resto del layout de dos columnas que existía cuando había una foto al lado, y que quedó vivo cuando saqué la foto. Ahora el panel arranca en el mismo borde que el título (medido: 158 y 158).
- **La sección era la única del sitio sin una sola masa visual.** Todas las demás tienen tarjetas, video o fondo oscuro; esta era texto flotando en crema, sobre un `--paper-dim` casi idéntico al de las secciones vecinas. Por eso se leía vacía por más que el copy y la animación estuvieran bien.

La solución fue meter la cita en un **panel oscuro** (`linear-gradient(150deg, wine-950, wine-900)`, radio `--r-lg`) con una comilla gigante de fondo en `--bronze-light` al 14% de opacidad, decorativa y con `aria-hidden` + `user-select:none` para que no ensucie el texto que se copia. La franja de datos vive adentro del panel y va invertida entera: separadores en `rgba(255,255,255,.16)` y acento en `--bronze-light`, porque `--bronze` no tiene contraste suficiente contra el wine oscuro (mismo criterio que ya se había aplicado en `#proceso`).

Dos detalles que costaron y conviene no repetir: la cita **no lleva `max-width` en `ch`** — los cortes de línea los define cada `<span class="ln">`, y con un `max-width` encima cada span se partía además por su cuenta, dejando la cita en cinco líneas cortas contra el borde izquierdo con media caja vacía. Y el énfasis en bronce pasó de "me manda videos y me exige mandarle todo" a "para revisar que esté haciéndolo bien": la primera versión ponía en el tamaño más grande de la sección una frase que suena a carga, cuando lo que vende es que Jimena corrige.

**Se evaluó y se descartó hacer oscura la sección entera:** `#testimonios` está justo antes de `#proceso`, que es la única sección oscura del sitio, y dos oscuras seguidas anulan el contraste que se ganó el 15/08. Un panel contenido sobre fondo claro da la masa sin romper el ritmo del recorrido.

**Se probó ligarlo al scroll y se revirtió el mismo día. Vale como criterio general, no solo para esta sección.** Durante unas horas la cita usó `animation-timeline: view()`, con un tramo de scroll distinto por línea. Gastón lo reportó así: *"me preocupa un poco esa animación porque cuando subo parece borrada"*. No era una impresión: si el avance lo maneja la posición del scroll, al subir la animación **retrocede** y el texto se desvanece. Para una decoración da igual; para una cita que hay que leer está mal, porque el contenido desaparece justo cuando la persona vuelve sobre él para releerlo. **Regla que queda: animación ligada al scroll sí para adorno, nunca para contenido que hay que leer.** Ahora usa el mismo `.reveal.stagger` que el resto del sitio — `IntersectionObserver` con `unobserve` al revelar, o sea de ida y sin vuelta — que además escalona a los hijos, así que se conserva el efecto de aparición por línea y se hereda la red de seguridad de 8s del script.

**La franja de datos: ninguno de los tres es un resultado de alumna.** Dice "1 a 2% por año / de masa muscular, si no entrenás fuerza" (después de los 50), "2 sesiones / por semana, en casa o en el gimnasio" y "Jimena, siempre / no hay un equipo detrás".

El primero es el **dato fisiológico publicado** que el benchmark 03 recomienda explícitamente usar como "número con plazo" mientras no haya datos propios: da urgencia sin prometer nada que dependa de Jimena. **Pendiente: que Jimena confirme y cite la fuente de ese 1-2% antes de que quede fijo.** Los otros dos son hechos del programa ya publicados más abajo en la página, así que son verificables. El tercero además dice por primera vez en el sitio la ventaja de que atiende una sola persona, que el benchmark marcó como lo único que ninguno de los 18 sitios relevados puede copiar.

**Gastón pidió (18/08/2026) algo del estilo "+100 alumnas" en esa franja y no se puso: Jimena tiene dos alumnas.** Un número de escala inventado es la única cosa capaz de romper el principio de marca que sostiene todo lo demás, y además contradice el hero, que a propósito no afirma trayectoria previa. El reemplazo honesto para el mismo efecto es el dato fisiológico. Cuando haya alumnas de verdad, el número va y es el mejor dato de la página.

**Lo que sigue bloqueado por falta de datos:** la foto de la alumna en el destacado y las métricas reales (hace cuánto entrena, de dónde arrancó, qué cambió medible). Cuando Jimena las pase, reemplazan a los tres datos del programa y la sección pasa a ser un caso de éxito de verdad. La versión con foto en retrato 4:5 está diseñada y verificada en `docs/_testimonios-preview.html` (archivo local sin commitear, porque tiene datos inventados y el sitio está en vivo).

**19/08/2026: llegaron cinco testimonios reales y la sección se rehizo con contenido en vez de con diseño.** Es exactamente lo que la advertencia de más arriba decía que había que esperar: no faltaba una quinta iteración de la forma, faltaba material. Con el material, la sección se resolvió en una sola pasada.

**Las citas.** Cinco, pasadas por Gastón: Daiana Gillese Urueña (34, Argentina), Margarita Izurieta López (49, Puerto Rico), Verónica Vázquez (39, Estados Unidos), Lorena Mariel Agout (49, Argentina) y Silvia Rodríguez (41, Estados Unidos). Cuatro van en la cinta y Silvia en el destacado. Criterio de edición, el mismo de siempre: **son textuales**. Lo único que se hizo fue cortar en el límite de una oración cuando la cita no entraba en la tarjeta, y corregir tipeos evidentes del mensaje original (`ganada`→`ganaba`, `contante`→`constante`, `esilo`→`estilo`, `anios`→`años`). No se completó ninguna frase ni se reordenó nada. A Daiana se le sacó la última oración porque repetía la primera, y a Lorena y Margarita las dos últimas por largo.

**La tarjeta de la cinta pasó a la forma de la referencia que pasó Gastón** (tarjetas de testimonio de coderhouse.com): foto redonda + nombre + una línea de contexto arriba, la cita en el medio, un dato en el pie. Antes era comilla decorativa + cita + iniciales abajo. La diferencia de fondo es el orden: **primero quién habla, después qué dijo.** Dos traducciones al caso de Jimena, las dos pedidas por Gastón:

- **Donde la referencia pone el curso, va la edad.** Es el dato que hace que la visitante de 45 se reconozca, y el nicho del sitio es +35. Funciona como el "Top 10" del ejemplo: ubica a la persona sin ocupar una línea entera.
- **Donde la referencia pone "Ver en LinkedIn", va el país con su bandera.** No hay perfil público que linkear, y el país dice algo que el sitio necesitaba decir y no decía: se entrena a distancia y ya hay alumnas en tres países. Argentina, Puerto Rico y Estados Unidos, dos de las cinco a distancia real.
- **Las banderas son SVG inline, no emoji.** Un sprite de tres `<symbol>` al principio del `<body>` y cada tarjeta lo referencia con `<use>`, así que las cuatro copias de la cinta no repiten los trazados. **Windows no dibuja los emoji de bandera: muestra las dos letras del país** (🇦🇷 se ve "AR"), y este sitio se mira mucho desde desktop. Son versiones simplificadas a propósito — a 22×15px las 50 estrellas de Estados Unidos son ruido, van ocho puntos.
- Se sacó la comilla decorativa de estas tarjetas: con foto, nombre y pie la cita ya se lee como cita, y el glifo competía con el comillón del panel de arriba. Con eso se fue también el bug de `line-height` que había obligado a documentarla.

**Las fotos van en `docs/img/testimonios/`, con nombre de archivo fijo** (`silvia.jpg`, `daiana.jpg`, `margarita.jpg`, `veronica.jpg`, `lorena.jpg`). Hay un README en esa carpeta con el formato. Lo que importa del mecanismo: **el degradé de marca con las iniciales no es un placeholder que se saca cuando llega la foto, es el fondo del avatar.** La foto va encima como `<img>` absoluto con `alt=""` y `onerror="this.remove()"`, así que mientras el archivo no esté la tarjeta se ve entera y nunca aparece el ícono de imagen rota. Verificado en local con las cinco fotos faltando. Cuando lleguen, se copian con ese nombre y no se toca una línea de HTML.

**El destacado pasó de Verónica a Silvia, y de cita a relato.** Silvia mandó su historia completa y es el único testimonio con **recorrido**: 2020 empezó sola con videos y caminatas, no le alcanzó; 2023 encontró clases en vivo y ahí apareció la disciplina; hace 2 años entrena una a una con Jimena. Un destacado tiene que hacer eso — que las otras cuatro citas digan que Jimena es atenta y corrige ya está cubierto. La cita grande es el cierre de su mensaje, textual, cortada en cuatro `<span class="ln">`.

**Y con eso la franja de datos dejó de ser un préstamo.** Eran tres hechos del programa (el 1-2% de masa muscular, las 2 sesiones semanales, "Jimena siempre") puestos ahí justamente hasta que existiera un dato real de una alumna. Ahora es la línea de tiempo de Silvia: 2020 / 2023 / Hoy, con fragmentos textuales de ella en itálica y entre comillas para distinguir de un vistazo lo que dijo ella de lo que escribimos nosotros. **El dato del 1-2% no se perdió y sigue sin fuente citada: queda disponible para la sección Programa, que es donde ahora tiene más sentido.** También se cambió la autoría: la barrita de bronce era un adorno ocupando el lugar donde tiene que estar la cara, así que ahora va foto + nombre + edad + país.

**Lo que hubo que recalcular en la cinta al pasar de 2 citas a 4** — son las dos cosas que la propia sección ya avisaba que se rompen solas:

- **La velocidad.** El grupo pasó de ~810px a 1784px medidos, así que la duración subió de 22s a 45s para sostener los ~40 px/s de la referencia. Regla práctica: `segundos ≈ ancho_de_grupo / 40`.
- **La cantidad de grupos, que bajó de 6 a 4.** Con 4 citas, `(4−1) × 1784 = 5352px` y cubre 4K (3840) con margen. Con 3 grupos daba 3568 y volvía a fallar en 4K por 272px, que es **exactamente el error del 18/08** — por eso son 4 y no 3, aunque 3 "alcance" mirando a 1280. El `4` está en dos lugares y hay que cambiarlo en los dos: el `@keyframes marquee` (`-100%/4`) y el `unGrupo()` del script, que lo necesita para el arrastre. Está anotado en los dos comentarios.
- Verificado midiendo el DOM a 1440 y a 390 (viewport real vía iframe): alturas de tarjeta parejas (285 y 336), cero overflow horizontal, y la regla del hueco cumplida en los dos.

**Cierre del 19/08/2026: Gastón aprobó la sección, pasó las fotos y confirmó que las autorizaciones están.** Cuatro decisiones más de ese cierre:

**1. La carga de testimonios pasó a ser un proceso escrito, con una herramienta.** Está en `testimonios.md` (raíz) y en `herramientas/build-testimonios.py`. Motivo: Gastón está esperando más citas, y sumar una a mano significa pegar la misma tarjeta N veces y acordarse de tres números que ya rompieron la sección en producción. El script tiene la lista de citas como **única fuente**, regenera la cinta entera y **recalcula solo** la duración, la cantidad de grupos con su recorrido en el keyframe, y el divisor de `unGrupo()` en el JS. Además verifica la regla del hueco contra 4K y avisa si falta una foto o una autorización. Corre con `--check` para saber si el HTML quedó desincronizado. **El destacado no sale del script y se sigue editando a mano: es un relato, no una tarjeta, y no entra en campos.** Acordado con Gastón: cuando avise que va a cargar un testimonio, lo primero es **pedirle los cinco campos** (texto, nombre, edad, país, foto) más la autorización, antes de tocar nada.

**2. Las autorizaciones no se publican en el sitio, se registran en el repo.** Gastón preguntó si convenía exponerlas o hacer un `/legales`. No: una página de legales en un sitio de una sola página le da volumen institucional a algo que se sostiene por ser cercano, y publicar el detalle de quién autorizó qué expone más datos de las alumnas, que es justo lo que se quiere evitar. Quedan registradas en el campo `autorizacion` de cada cita en el script (fecha y alcance: texto, o texto y foto), que es donde sirven — al lado del dato que habilitan. **Queda propuesto y sin implementar** (no se toca el sitio sin que Gastón lo mire): una línea en el footer, *"Los testimonios son textuales y se publican con autorización de sus autoras"*, que es la parte que sí le sirve a quien lee.

**3. Silvia no se repite en la cinta.** Gastón lo planteó como duda. Se descartó: el destacado y la cinta se ven juntos en la misma pantalla, y leer la misma cara dos veces con menos palabras la segunda vez achica la sección en vez de agrandarla — es el mismo problema que tenía la cinta con dos citas repitiéndose. Si en algún momento el destacado rota a otra alumna, Silvia entra a la cinta con su cita corta y son dos líneas en el script.

**4. Las cuatro fotos que llegaron se recortaron antes del primer commit, a propósito.** Venían como las mandaron por WhatsApp: la de Silvia era una foto de pareja (a 64px no se sabía cuál de las dos era ella, y es la foto más importante de la sección), la de Margarita un plano entero donde la cara ocupaba un cuarto del cuadro, y la de Lorena una foto en la playa en bikini, que no es un problema de encuadre sino de tono para un sitio que se apoya en el posicionamiento profesional de Jimena. Las tres se recortaron a la cara con `sips` y las cuatro se bajaron a 256px: **de 192 KB a 60 KB en total**. Se hizo **antes de commitear** para que los originales no queden para siempre en el historial de un repositorio público — una foto de terceros no se borra con un commit que la reemplaza. Los originales quedaron fuera del repo. Efecto de fondo: las cuatro son ahora retratos de cara comparables, y esa consistencia es buena parte de lo que hace que la fila se lea profesional.

**Lo que queda abierto de esta pasada:**

- **Falta una sola foto: `daiana.jpg`.** Las otras cuatro entraron el 19/08. Mientras no esté, su tarjeta muestra "DG" sobre el degradé y no se rompe nada.
- **La autorización quedó resuelta:** Gastón confirmó el 19/08 que están las cinco. Con eso se reescribió la regla de `CLAUDE.md`, que decía "no se publican datos de alumnas: nombres completos…" y contradecía lo publicado desde el 13/08. Ahora dice lo que de verdad se hace: **nunca condiciones de salud, mediciones ni contacto; nombre, edad, país, foto y cita solo con autorización explícita pedida por Jimena, registrada junto a la cita.**
- **Ahora sí hay número honesto para la franja del hero.** El 18/08 se rechazó el "+100 alumnas" que pidió Gastón porque Jimena tenía dos alumnas. Con cinco testimonios de tres países y dos de ellos de gente que entrena hace dos años, hay algo verdadero que decir. Sigue sin ser "+100": es "cinco mujeres, tres países".

**Mobile.** Hay un bloque dedicado en el breakpoint de 720px, con tres reglas que conviene sostener al agregar secciones nuevas:

• Nada tocable por debajo de 44px de alto. Los links del nav y del footer llevan padding propio para llegar ahí.
• Los botones van a lo ancho completo y centrados. Con el ancho natural, "Escribime por WhatsApp" se partía en dos líneas.
• Los radios bajan de `--r-lg` a `--r-md` en pantallas chicas: en 390px un radio de 20px se come demasiado la esquina.

**Bug arreglado (14/08/2026): el menú hamburguesa no aparecía entre 401px y 720px de ancho.** Las reglas del hamburguesa (`.navtoggle{display:block}` y el dropdown de `.navlinks`) estaban en el breakpoint de `max-width:400px` en vez del de `max-width:720px`, que es el que usa el resto del sitio para mobile. En ese rango (celulares grandes, iPhone Pro Max incluido) no había hamburguesa pero tampoco entraba el nav de escritorio: el logo y los links se pisaban. Se movieron esas reglas al breakpoint de 720px.

### Identidad de marca: el símbolo, el "Método Raíz" y una lección cara (19/08/2026)

**El método de Jimena se llama "Método Raíz".** Dato que aportó Gastón ese día y que cierra un pendiente abierto del backlog. **Ojo: no está escrito en ningún lado todavía** — ni en `contexto.md`, ni en `index.html`, ni en `estrategia/`. Queda como pendiente bajarlo.

**El sitio no tiene símbolo de marca, ni favicon, ni og-image propia.** El header es texto plano (`Jimena Ibañez.`), `index.html` no declara ningún `<link rel="icon">` y el `og:image` apunta a `jimena-sobre-mi.jpg`, que es una foto y no una pieza diseñada. Se nota cuando alguien comparte el link por WhatsApp, que es el canal principal.

**Se decidió que el símbolo sale del nombre del método** (una raíz), aplicando el criterio que ya había salido en donAR: el símbolo tiene que venir de lo único que no se puede copiar. Una mancuerna es el logo de cualquier gimnasio y una hoja el de cualquier marca de wellness; el nombre propio del método, no. Regla que quedó: **la raíz nunca lleva parte aérea** — agregarle hojas la convierte en un árbol genérico.

**La lección, que es lo que hay que recordar:** se intentaron dibujar los símbolos en **SVG a mano y salieron mal**. Tres rondas, y recién al renderizarlas en el navegador se vio que la primera tanda se leía como una antena de TV, un abeto y una figura de palotes corriendo. Los intentos de silueta femenina fallaron los cinco: sólida da un florero, esquemática da el pictograma de baño público, en dos líneas se lee como paréntesis y de perfil dice spa. **Esto ya estaba escrito en `donAR/docs/proceso-logo.md` y se pasó por alto:** el SVG a mano sirve para lo geométrico y lo tipográfico; para un *dibujo* hay que ir a IA de imagen, y después derivar los tamaños finales localmente con un script. El próximo intento va por ahí.

**Dos cosas que sí sirven de esa pasada:**
- **Verificar mirando, no imaginando.** Renderizar en el navegador y mirar la captura es lo único que detectó los errores; a ojo desde el código las seis primeras opciones parecían razonables. Es la misma regla de "medir en vez de mirar" que ya está en `CLAUDE.md`, aplicada a lo visual.
- **Detalle que vale para cualquier símbolo que se elija:** el header ya termina en un punto (`Jimena Ibañez.`). Un punto en bronce dentro del símbolo lo hace citar algo que la marca ya hacía, en vez de sumar un elemento nuevo.

### `design-system.md`, nuevo en la raíz del repo (19/08/2026)

Se creó `design-system.md`, que documenta en un solo lugar la paleta, la tipografía, los radios, las sombras y la voz de marca **tal como están hoy en `docs/index.html`**, leídos del CSS y no de este archivo. Mismo rol que cumple el suyo en el proyecto Tecla.

**Corrección que salió de escribirlo:** este `memory.md` describía la tipografía como "Archivo (display) + Work Sans (cuerpo)". **Work Sans ya no se usa.** El `<link>` de Google Fonts que carga hoy el sitio trae solo **Archivo** (400/500/600/700 + itálica 700) y **IBM Plex Mono** (400/500); Archivo hace los dos roles. Si alguien buscaba Work Sans en el CSS, no está.

### Pasada de copy y de hero (20/08/2026)

Primera sesión con criterio explícito de **copywriting**, no solo de diseño. Gastón pidió tratar el copy con el mismo rigor que un flujo de producto. Se transcribieron al pie de la letra los heros de las dos referencias directas — `entrenadoranoeliarodriguezfit.com` (misma clienta, mismo negocio de una sola persona) y `sariadnapascual.com` — y de ahí salieron las reglas de abajo.

**Lo que hace bien la referencia de Noelia:** su titular tiene seis palabras ("Tu cuerpo cambia en la menopausia") y ninguna habla de ella ni de su método. Habla del cuerpo de quien lee. La estructura es: nombro tu condición → qué vas a conseguir → sin qué → CTA. Y su CTA no dice "quiero mi cambio", dice **"quiero saber por dónde empiezo"**, que nombra la duda real de alguien que ya probó de todo. Sariadna es el contraejemplo: "EL PROYECTO MÁS IMPORTANTE / ¡ERES TÚ!" es grande y podría ser de una inmobiliaria. Ojo, la referencia de Sariadna que había pasado Jimena era **por testimonios**, no por copy.

**Reglas de copy que quedan para el resto del sitio:**

• **Nada de paréntesis técnicos en la parte alta.** El lead viejo tenía 44 palabras y aclaraba "(pérdida de grasa y ganancia de masa muscular/tonificación)". Si hay que aclarar entre paréntesis, ya perdiste a quien lee.
• **No enumerar condiciones clínicas arriba.** Observación de Gastón y es la más importante de la sesión: listar "resistencia a la insulina, SOP, hipotiroidismo, perimenopausia" no confunde a quien las tiene diagnosticadas — **excluye a la que no sabe que las tiene** y se autodescarta leyendo la lista. Y esa es buena parte del público. Arriba se nombra lo que ella siente; el nombre clínico va abajo, con contexto, y explicado la primera vez que aparece. La sección Problema ya lo hace bien.
• **Contar las paradas de lectura antes del botón.** El hero pasó de seis a cuatro.

**Qué quedó en el hero:**

- **El claim vuelve a "Más fuerte. / Más segura. / Más vos."** Se probó reemplazarlo por un remate en dos niveles ("No es tu fuerza de voluntad… / **Son tus hormonas.**") y **se descartó por decisión de Gastón**: a 72px y en color de marca esa frase deja de ser un alivio y se lee como un veredicto sobre el cuerpo de la clienta. Además **esa idea ya vive en la caja "La realidad" de la sección Problema**, quince centímetros más abajo y con espacio para explicarla: el hero le estaba robando el remate a esa sección y lo entregaba peor. **Lección: el titular del hero no es el lugar del diagnóstico.**
- **Las tres palabras que rotan van en `--wine-600`**, y "Más" queda en `--wine-900`. El énfasis lo hace el contraste entre dos tonos del mismo vino. Se probó antes un subrayado en bronce y se descartó. Dato para no rehacer la cuenta: `--wine-600` sobre blanco da **6.6:1**, así que pasa AA incluso como texto normal.
- **Si alguna vez se vuelve a intentar un subrayado ahí, ojo con el `clip-path` de `.rot`**, que recorta a `-.08em` por debajo: un `text-underline-offset` grande se corta solo. Con `.08em` entraba.
- **El techo del `<h1>` bajó de 92px a 72px.** Los 92 estaban puestos cuando el titular cargaba solo con todo el mensaje y el lead no se leía. Con un lead que ahora dice algo, 92px lo aplastaba.
- **El lead lo escribió Gastón** y es mejor que la versión que había propuesto la IA: *"Desarrollé mi Método Raíz para que puedas perder grasa, ganar músculo y recuperar energía. Pensado para tu cuerpo después de los 35."* Arrancar por el verbo en primera persona resuelve tres cosas de un saque: le da al método el peso que le faltaba, y dice sin decirlo que **acá hay alguien y no una empresa** — que era un pendiente suelto del benchmark world class ("escribir la ventaja de ser una sola persona").
- **CTA: "Quiero saber por dónde empiezo"** en lugar de "Quiero mi cambio". Pide preguntar, no anotarse. **El atributo `data-ga="whatsapp_hero"` se conservó**, así que la medición de conversión de GA4 sigue intacta.
- **Microcopy: "Respondo personalmente cada consulta".** Se probó "Te respondo yo, no un bot" y Gastón lo bajó.
- **El video de alumnas pasó a ocupar el ancho completo de su columna.** Estaba topeado en `max-width:340px` dentro de una columna de ~507px, o sea con 167px de aire muerto — un tercio de su propia columna. **El límite pasó a ser el alto y no el ancho** (`max-height:min(64vh,620px)`): sin eso, un video a ancho completo con `aspect-ratio:3/4` pide más alto del que el hero tiene disponible y lo empuja fuera del viewport, y revienta primero entre 1280x800 y 1440x900.
- **Salió la etiqueta mono "Método Raíz"** que estaba debajo del `<h1>`: quedó redundante con el lead. Al sacarla hubo que devolver el `margin-top` del lead a 26px, que se había bajado a 10px justamente porque esa etiqueta ocupaba el espacio.

**Verificación:** DOM medido en 14 anchos de 360px a 1440px — cero overflow horizontal, el claim nunca se parte, áreas táctiles de mobile en 46px mínimo. **El `resize_window` del navegador no funciona en este entorno** (queda fijo en 1440px): sirve el harness con iframe a ancho real, igual que en la pasada de mobile del 15/08.

### Footer de cuatro columnas y tres páginas legales (21/08/2026)

**Pedido de Gastón**, tomando como referencia de estructura el footer de `entrenadoranoeliarodriguezfit.com`, pero con la paleta y la tipografía de este sitio. El footer anterior era una sola línea: nombre a la izquierda, un link a Instagram a la derecha.

**Cómo quedó:** cuatro columnas — marca (Método Raíz *by* Jimena Ibañez, bajada corta y las redes), Programas (ancla a `#servicios`), Otros servicios (consulta personalizada, que abre WhatsApp) y Legal (las tres páginas nuevas). Debajo, una barra con la línea de derechos reservados.

**Fondo `--paper-dim`, no oscuro, y el motivo importa.** La referencia tiene el footer en color fuerte, pero acá arriba del footer está la caja de contacto con el gradiente vino→bronce, que es el último momento fuerte de color del recorrido. Un footer oscuro pegado abajo lo duplica y además le saca a "Cómo trabajo" el lugar de única sección oscura del sitio, que es una regla escrita. En dim, el recorrido cierra con la alternancia de siempre. **Se descartó también la onda decorativa** de la referencia: el sitio no tiene ningún elemento decorativo de ese tipo y habría sido el único.

**Bug de medición que el footer nuevo destapó, y es el más importante de la sesión.** El handler de GA4 era un ternario: *si el `data-ga` empieza con "whatsapp" es contacto, si no es Instagram*. Con una sola red funcionaba. Pero **Jimena tiene TikTok**, y en cuanto entre ese link, cada clic a TikTok iba a llegar a GA4 disfrazado de visita a Instagram — la métrica mintiendo sin que nada se rompa a la vista, que es la peor clase de error para un dato que se mira una vez por mes. Ahora hay un mapa explícito `canal → evento` y **el canal desconocido no manda evento**, que es preferible a mandar uno falso. Es la misma trampa que la advertencia ya escrita sobre conservar `data-ga` al tocar los CTA: el riesgo del sitio no es que la medición se rompa, es que siga andando y mienta.

**Las tres páginas legales** viven en `docs/aviso-legal/`, `docs/politica-de-privacidad/` y `docs/cookies/`, cada una como `index.html` adentro de su carpeta, para que la URL sea `/cookies/` y no `/cookies.html`.

• **Comparten `docs/legal.css`, y eso no contradice la regla del archivo único.** El index tiene el CSS inline porque es *una* página, donde un archivo aparte solo agregaría un round-trip. Acá son tres páginas con exactamente la misma hoja: inline significaría triplicar los tokens y garantizar que en la próxima pasada de paleta terminen diciendo cosas distintas, que es el problema que este repo ya tuvo con los cuatro archivos de documentación.
• **Orientadas a la ley 25.326 argentina, no al GDPR.** Encaja con la decisión ya tomada de no poner banner de cookies, y la página de cookies ahora la explica en vez de dejarla implícita: el banner lo exige el RGPD europeo, no la 25.326, y las únicas cookies del sitio son analíticas sin fines publicitarios.
• **Los datos de salud tienen su propio bloque destacado en privacidad.** Son datos sensibles por el artículo 7 de la ley 25.326 y Jimena los recibe todo el tiempo por WhatsApp. Dice tres cosas: que se comparten voluntariamente y con consentimiento expreso, que no se publican ni se ceden nunca, y que nadie está obligado a darlos.
• **El aviso legal aclara que esto no es asesoramiento médico** y que no reemplaza al médico ni al nutricionista, con la indicación explícita de consultar antes de empezar. Ya era un principio de marca escrito en `contexto.md`; ahora también está donde legalmente corresponde.
• **No se inventó ningún dato que no esté en el repo.** No hay CUIT, ni domicilio, ni razón social, ni email: los textos están redactados para funcionar sin eso, con WhatsApp e Instagram como canales de contacto, que son los dos reales. Ver los pendientes abiertos abajo.

**Lo que apareció midiendo a 360px**, que a ojo no se veía:

• El **ícono de Instagram del footer medía 42px** de alto, dos por debajo del mínimo tocable del repo. Un círculo no puede estirarse a lo ancho para compensar, así que pasó a 44.
• El **logo de las páginas legales medía 26px**. `index.html` ya tenía el `padding:8px 0` en mobile para esto; `legal.css` arrancó sin él.
• La **tabla de cookies obligaba a arrastrar** para llegar a la columna de duración. El documento no desbordaba —el contenedor con `overflow-x` hacía su trabajo— así que el chequeo de overflow horizontal daba limpio igual. A ≤560px cada fila pasa a ser una tarjeta con el encabezado repetido como etiqueta, y el `<thead>` queda oculto a la vista pero disponible para el lector de pantalla. **Que no desborde no quiere decir que se pueda leer.**

### La pestaña oculta: por qué varias mediciones fueron falsas (21/08/2026)

**Descubrimiento que invalida conclusiones anteriores y hay que tener presente siempre.** La pestaña que maneja el harness corre con `document.visibilityState === "hidden"`. Chrome, en una pestaña de segundo plano, **suspende el pintado, no entrega callbacks de `IntersectionObserver` y no descarga media**.

Consecuencias sobre cosas que se dieron por ciertas:

• **El video del hero probablemente nunca estuvo roto.** El 20/08 se concluyó, con `readyState 0` y `networkState 2` medidos en esa pestaña, que el video no cargaba ni en local ni en producción. Eso es exactamente lo que Chrome hace con el media de una pestaña oculta. Queda como pendiente comprobarlo a mano, en primer plano y en un celular. Se perdió una sesión entera persiguiéndolo.
• **`getComputedStyle` devuelve valores previos a la transición** en esa pestaña, porque no hay pintado. Varias veces dio `opacity:0` sobre elementos que en pantalla se veían perfectos.
• **El observador nunca dispara ahí**, así que todo lo que se vio revelado fue obra de la red de seguridad, no del scroll.

**Regla que queda:** la regla del repo dice "medir en vez de mirar", y sigue siendo cierta **para geometría** — anchos, altos, overflow, áreas táctiles. Pero para **movimiento, media y cualquier cosa que dependa del pintado, hay que mirar**, y si la medición y la captura se contradicen, gana la captura. Antes de dar por roto algo que depende del render, chequear `document.visibilityState`.

### El QA local mentía sobre el video (20/08/2026)

**`qa-local.py` no soportaba `Range` requests.** Chrome pide media por rangos; `SimpleHTTPRequestHandler` ignora la cabecera y contesta `200` con el archivo entero, sin `Accept-Ranges`. GitHub Pages contesta `206` con `Content-Range`. O sea que **el servidor de QA se comportaba distinto a producción justo en lo único que no se puede revisar leyendo el código**. Arreglado: ahora responde 206, con `protocol_version = "HTTP/1.1"`. Verificado con `curl -H "Range: bytes=0-1023"` contra los dos.

**Lección de método, que es lo que hay que recordar:** cuando algo se ve mal en local, la primera pregunta no es "¿qué rompí?" sino **"¿el entorno de QA se parece a producción en esto?"**. Acá se perdió una vuelta entera arreglando el JS del sitio antes de comparar las cabeceras de los dos servidores, que tardó diez segundos y fue lo que dio la respuesta.

**Pendiente sin resolver, ojo:** con el `Range` ya arreglado, **el video del hero sigue sin cargar, y también sigue sin cargar en producción** — `networkState 2` (cargando) y `readyState 0` (cero bytes), sin error, en `localhost` y en `entrenaconjime.com` por igual. El archivo está bien: `curl` lo baja entero, 1 MB, `video/mp4`, HTTP 200 en los dos lados. **No está confirmado si le pasa a un navegador normal o solo al Chrome que maneja el harness**, así que falta abrir el sitio a mano en una máquina y un celular antes de sacar conclusiones.

**Lo que sí se arregló del lado del sitio:** el JS tenía un círculo vicioso real. `play()` se llamaba **solo** dentro del handler de `loadeddata`, y `play()` es justamente lo que fuerza la descarga cuando `preload="metadata"` no la dispara. El video esperaba un evento que solo iba a existir si alguien lo despertaba primero. Ahora se pide la reproducción de entrada, y el placeholder se oculta por `readyState >= 2` **o** por evento, porque si el video ya venía de caché el evento tampoco se vuelve a emitir. **Este arreglo no resolvió el síntoma observado**, así que la causa de fondo sigue abierta.

### Rediseño de la sección Problema y pasada de movimiento (21/08/2026)

**La sección era una lista de seis viñetas del mismo peso más una caja de color con el texto centrado.** Los dos problemas, dichos con precisión: una lista es lo que se escribe cuando todavía no se decidió qué es lo importante, y un párrafo centrado es hostil porque cada renglón arranca en una x distinta. Además enterraba su mejor frase, *"No es falta de voluntad"*, en el medio de ese párrafo.

**Se probaron tres direcciones en un comparador** (`docs/_problema-preview.html`, borrado al cerrar, mismo criterio que el de testimonios):

- **A · checklist interactiva** — ella marcaba lo que le pasaba y Jimena respondía según el tema dominante, con el mensaje de WhatsApp precargado con lo marcado. **Descartada por Gastón, con razón, y el motivo sirve para la próxima:** en mobile la respuesta quedaba **724px por debajo** de la tarjeta que tocaba, o sea casi una pantalla. El corazón de la idea era la reacción inmediata y en mobile no había ninguna. Además eran dos pantallas de scroll para la segunda sección de la página. **La idea no está mal, está en el lugar equivocado:** una herramienta que pide participación rinde cuando ya decidió que le interesa, no antes. Queda apuntada al pendiente del quiz de conversión.
- **B · mito contra realidad** — quedó mejor de forma pero **le cambió el trabajo a la sección**: pasaba de calificar a argumentar. Observación de Gastón que vale como regla: alguien puede darle la razón a los cuatro mitos y no concluir nunca que el programa es para ella.
- **C · elegida.** Vuelve a calificar, pero en los dos sentidos, que era la otra mitad de la frase de Gastón: *"tanto ellas como yo nos tenemos que elegir mutuamente"*.

**Cómo quedó:** un bloque vino a todo el ancho, "Es para vos si…", con las seis situaciones en dos columnas; debajo una tira más fina, "No es para vos si…", con cuatro descartes; y el remate suelto, sin caja, con el párrafo alineado a la izquierda.

• **Apilados y no lado a lado, por una razón medida:** en dos columnas, seis ítems contra cuatro daban 730px contra 500px. Emparejar alturas no lo arregla, deja aire muerto adentro de la caja corta. Bloques de ancho completo no pueden quedar disparejos.
• **Los dos títulos comparten familia, tamaño y construcción.** El "no" estaba en IBM Plex Mono a 11.5px y parecía de otro sistema. La jerarquía la da el color.
• **El "no" se distingue por la forma, no por el color:** cruz gris. En rojo o tachado se lee como un reto, y esto es honestidad.
• **Fondo `--paper-dim`**, que cierra de paso el pendiente de que hero, Problema y Sobre mí eran las tres blancas y seguidas. El recorrido quedó blanco → dim → blanco → dim → oscuro → dim → blanco.
• **Los cuatro descartes los tiene que validar Jimena.** Se derivaron de principios ya escritos en `contexto.md`, pero rechazar clientas es decisión de ella.

**Advertencia sobre inventar datos, porque volvió a pasar.** El subtítulo decía *"Trabajo con pocas alumnas a la vez"*. Jimena nunca dijo eso y no está en ningún lado del repo. Es la misma clase de error que el "el programa que ya ayudó a mujeres…" que ella tuvo que corregir en agosto. **Antes de escribir un dato de negocio —cupo, capacidad, precio, trayectoria— hay que preguntarlo.**

**Pasada de movimiento, toda en CSS:**

• **Bug de fondo: el selector es `.reveal.stagger` y necesita las dos clases en el mismo elemento.** El `<ul>` tenía solo `stagger`, así que los seis ítems entraban de golpe. Buena parte de lo que se leía como "estático" era eso.
• **El grid llena por columnas** (`grid-auto-flow:column` con tres filas). Por defecto llenaba por filas, así que la cascada saltaba en zigzag entre las dos columnas a la vez.
• **Secuencia encadenada:** entra la tarjeta → baja el recorrido por la columna izquierda y después la derecha → recién ahí arranca el recuadro. El barrido cuelga de `.in-view` y no del load, que era el error: giraba aunque la sección estuviera fuera de pantalla.
• **Recuadro premium:** un cuadrado con gradiente cónico gira detrás y un pseudo-elemento tapa el interior menos 1.5px, así que del giro solo se ve el filo recorriendo el borde. Cada 8s, sin `@property` y sin JS.
• **Guiño de los bullets:** al aterrizar, cada ítem hace **el mismo gesto que el hover**. La entrada no inventa un lenguaje nuevo, le enseña que ahí hay algo que responde. Sale 50ms después de aterrizar: si se pisara con la transición, la animación le ganaría al `transform` y el ítem entraría de golpe.
• **Trampa de CSS que costó encontrar:** el shorthand `animation` resetea `animation-delay` a 0. Las reglas de delay tienen que repetir el mismo prefijo de clases o pierden por especificidad y todos los escalones salen juntos.

**Dos curvas de easing, que es una excepción deliberada a la regla del 18/08.** Las entradas usaban `cubic-bezier(.16,1,.3,1)`, una exponencial que arranca disparada y **frena en seco**; ese frenazo era el "cae muy pesado" que Gastón marcó tres veces. Las entradas pasaron a `cubic-bezier(.25,.46,.45,.94)`, que desacelera de a poco, con el recorrido del hero de 22px a 14px y las duraciones bastante más largas. **Los hovers y los botones conservan la curva vieja**: una interacción tiene que responder rápido, una entrada tiene que ser suave.

### La red de seguridad del reveal, arreglada de fondo (21/08/2026)

**Se ajustó dos veces por el mismo síntoma y las dos veces se erró el diagnóstico.** 2000ms el 14/08, 8000ms el 20/08: siempre la red terminaba revelando la página entera mientras la persona seguía leyendo arriba, y cuando por fin scrolleaba ya no veía ninguna transición.

**El error era atarla a un cronómetro.** Ninguna cifra puede funcionar: compite contra cuánto tarda alguien en leer, que es un dato que no tenemos. Ahora **la red no mide tiempo, mide si el observador anda**: una sonda sobre el `<header>` con `threshold: 0` confirma que `IntersectionObserver` responde y cancela el temporizador. Solo llega a disparar si el observador nunca contestó, que es el único caso para el que fue pensada.

**Por qué hace falta una sonda aparte y no alcanza con el observador principal:** con un `threshold` distinto de 0 el observador no entrega lote inicial si nada intersecta, y el hero no tiene ningún elemento `.reveal`, así que al cargar no intersecta ninguno. El `<header>` siempre está en pantalla.

### Precio por país: bloqueante nuevo (20/08/2026)

**Decisión de Gastón: el sitio tiene que mostrar un precio para Argentina y otro para el resto del mundo.** Queda como **bloqueante del lanzamiento del 23/08**, con prioridad inmediatamente después del barrido del sitio.

**El motivo importa más que la feature, porque cambia de qué se trata el problema.** No es "poner precios distintos": **Jimena ya le cobra más a las alumnas extranjeras**. O sea que el USD 35 publicado es el precio argentino expuesto a todo el mundo, y una extranjera que entra hoy lee un número más barato que el que después le van a cobrar. El sitio no está por crear una asimetría, la está contradiciendo. **Y el sitio está en vivo desde el 19/08, así que esto ya está pasando** — no es un pendiente que empieza el 23.

Vale anotar el error de razonamiento, porque es reutilizable: la primera reacción fue advertir sobre el riesgo político de cobrar distinto por país. Esa advertencia estaba construida sobre una premisa falsa (que la diferencia no existía todavía). **Antes de objetar una decisión de precio, preguntar qué se cobra hoy de verdad.**

**Restricción dura, pedida explícitamente: sin latencia y sin parpadeo.** Eso descarta las dos opciones obvias:
- **API de geolocalización por IP** (ipapi.co, ipinfo.io): la respuesta llega a los ~200ms y el número cambia a la vista, justo en el dato más sensible de la página. Además suma un tercero que ve las IP de las visitantes y un límite de plan gratuito.
- **Cloudflare Workers**: es la solución técnicamente correcta —se resuelve en el servidor, país real, cero parpadeo— pero **exige prender la nube naranja**, y este mismo archivo tiene escrito que antes hay que pasar SSL/TLS a *Full (strict)* o el sitio se cae con un loop de redirecciones. A tres días del lanzamiento no se toca.

**Camino elegido: zona horaria del navegador.** `Intl.DateTimeFormat().resolvedOptions().timeZone` devuelve algo como `America/Argentina/Buenos_Aires`; todas las zonas argentinas empiezan con `America/Argentina`. Resuelve local, instantáneo, sin llamada externa y sin exponer ninguna IP. Falla con VPN o con alguien de viaje, y ese costo se acepta.

**Regla de implementación que no es obvia: el precio que va escrito en el HTML es el internacional, no el argentino.** El proyecto ya tiene la regla de que el contenido se vea sin JavaScript, y acá esa regla tiene una dirección correcta: si el script no corre, la que ve el precio equivocado tiene que ser la argentina —a quien se le corrige a la baja en la conversación, que es una charla fácil— y no la extranjera, a quien habría que corregirle a la suba. El fallback tiene que fallar hacia el lado barato de explicar.

**Bloqueado por una decisión de negocio:** cuál es el número internacional. Jimena lo cobra pero no está escrito en ningún lado del repo.

### Búsqueda con IA: qué falta (20/08/2026)

Pedido de Gastón, **no bloqueante**. `robots.txt` ya permite todos los crawlers (`User-agent: *`), así que no hay nada que desbloquear. Lo que falta es material citable: **el JSON-LD declara solo `Person`** —nombre, oficio, foto, Instagram— y no dice nada del programa, del precio, del Método Raíz ni de los testimonios, que es justo lo que un modelo necesita para responder "¿quién entrena mujeres +35 con cambios hormonales?".

**Interacción con el pendiente de precio, que es fácil de pasar por alto:** los datos estructurados son estáticos y se indexan una sola vez para todo el mundo. Si se declara el precio ahí, ese número lo ve cualquiera sin importar el país, y se pierde el sentido de la detección por zona horaria. Ahí va el precio internacional o no va ninguno.

### Sección "¿Te suena algo de esto?" y el manual (20/08/2026)

Tres commits de Gastón que quedaron sin documentar hasta esta pasada:

- **Sección Problema nueva**, entre el hero y "Sobre mí": seis bullets de dolor en primera persona más una caja "La realidad" en gradiente vino→bronce que explica por qué no es falta de voluntad. **Cierra sin querer un pendiente 🟢 del benchmark 02** ("reordenar la web para arrancar por el problema de la clienta, no por la oferta").
- **"Método Raíz" bajado al sitio**, que cierra el pendiente 🟡 de Growth.
- **`materiales/Manual_Metodo_Raiz_Jimena_Ibanez.pdf`** — un manual ya producido con el público objetivo +35. **Todavía no está enlazado desde ningún lado del sitio.** Es un lead magnet terminado sin CTA, justo cuando hay un pendiente del benchmark que pide "regalar algo con nombre, formato y plazo".

**Deuda de proceso que se ve acá:** entre el 19 y el 20/08 se pushearon cambios de sitio sin actualizar `memory.md` ni `backlog.md`, y los cuatro archivos volvieron a decir cosas distintas — el mismo problema que ya se había arreglado el 18/08. El sitio es un solo archivo y la documentación es lo único que explica por qué está como está.

**Pendiente que abre esta pasada:** las tres secciones de arriba de todo (hero, Problema, Sobre mí) son **las tres blancas y seguidas**. `#problema` no declara fondo propio, así que hereda `--paper`. El recorrido con ritmo que se armó el 15/08 (claro → dim → oscuro → dim → claro) ahora arranca con tres bloques planos antes del primer cambio. Y la sección nueva tampoco está en el nav.

### La entrada de los bullets: de golpe a respiración (22/08/2026)

Gastón: *"la animación del bulleteado es muy brusca, que pase más lentamente y smooth, estilo Headspace, que me dé calma no que me genere un choque"*.

**El golpe eran dos cosas concretas, las dos leíbles en el CSS:**

1. **El punto hacía `scale(1.5)` en 0.6s.** Crecía a una vez y media su tamaño y volvía, seis veces seguidas. Ahora llega a **1.22 en 1.4s**.
2. **Y las dos animaciones del guiño usaban `cubic-bezier(.16,1,.3,1)`**, que en este sitio es **la curva de interacción**: arranca disparada y frena en seco. Es la correcta para un hover, que tiene que contestar rápido, y es justo la que no va en algo que pasa solo mientras la persona lee. Ahora usan una sinusoide simétrica, `cubic-bezier(.37,0,.63,1)`, que entra y sale sin filo.

Este es el mismo error que ya está documentado arriba en la nota de las dos curvas de easing del 21/08 — la exponencial se sentía como "cae muy pesado". Volvió a aparecer, en otro lugar.

**El desplazamiento horizontal del texto se sacó entero** (`guinoItem`, que corría cada ítem 3px). Una línea que se corre de costado mientras la estás leyendo es lo más molesto del conjunto, y el punto que respira ya alcanza para anticipar el hover. Se pierde que la entrada sea *exactamente* el mismo gesto que el hover, que era el criterio original; se acepta a cambio de la calma.

**Ritmo propio para esta lista.** El `.reveal.stagger` general del sitio escalona cada `.16s` con entradas de `1.25s`; para seis bullets seguidos eso es una ráfaga. Acá el paso sube a **.34s** y la entrada a **1.8s**, así que los seis tardan ~3.5s en vez de ~2 y **cada uno se termina de posar antes de que arranque el siguiente**. El recorrido baja de 24px a 16px: cuanto más corto el viaje, menos se lee como que algo fue empujado. Va con selector propio para no cambiarle el pulso al resto del sitio.

**Y el barrido del borde se recalculó**, como avisaba su propio comentario: el último bullet ahora aterriza a 3.50s y su respiración termina a 4.95s, así que el barrido pasó de arrancar a los 3s a los **5s**. Si se vuelve a tocar el ritmo de la lista, ese número va atrás.

### "Sobre mí": fuera el volanta, y entra la formación (22/08/2026)

Pedido de Gastón: sacar el volanta "SOBRE MÍ" —que no aportaba nada que el titular no diga—, bajar el titular a dos renglones, y **gastar ese espacio en autoridad por formación**.

El titular pasó de `max-width:17ch` a **26ch**: con 17 caía en tres renglones. Ahora entra en dos y la sección arranca directo por él.

Al final de la columna entra un bloque **Formación**: *Profesora Nacional de Educación Física · Entrenadora en levantamiento olímpico · Especialista en salud femenina*. Va último y en chico a propósito, mismo criterio por el que el cargo dejó de ser titular: **es prueba, no gancho**.

**Dos interpretaciones que hice sobre lo que pasó Gastón** y que conviene revisar con él: escribió *"entrenadora y en OLY"*, y se resolvió como una sola credencial, "Entrenadora en levantamiento olímpico" — se expandió OLY porque el público del sitio son mujeres +35 que no tienen por qué conocer la sigla.

### Footer: dado vuelta otra vez (22/08/2026)

El arreglo de la mañana —tres columnas a `max-content`— resolvió que se leyeran desparramadas pero creó el problema opuesto: **la marca se quedaba con todo el sobrante** (564px para un texto de 460) y las tres columnas de links quedaban apretadas contra el borde derecho, con **168px de vacío en el medio**. Gastón lo marcó como "muy arrastrado a la derecha".

Ahora es al revés: **la marca toma el ancho de su texto** (`max-content`) y son **las tres columnas de links las que se reparten el resto en partes iguales**. Sus bordes izquierdos quedan a 269px uno de otro, o sea a distancia pareja, que es lo que el ojo lee como orden — dentro de cada columna sobra aire a la derecha, pero eso no se ve porque no hay borde ni fondo que lo marque.

### Las dos tarjetas del "problema" vuelven a ir lado a lado (22/08/2026)

**Esto revierte una decisión escrita, a pedido explícito de Gastón.** El CSS decía, desde que se armó la sección, que los dos bloques iban **apilados y no lado a lado**, porque en dos columnas quedaban siempre disparejos —6 ítems contra 4, 730px contra 500px— y que emparejar alturas no lo arregla, solo mueve el problema adentro de la tarjeta corta.

**Esa advertencia era correcta y se cumplió.** Ahora las dos miden exactamente lo mismo (490x472 en desktop), y la tarjeta del "no" queda con **264px de aire abajo**. No hay forma de tapar eso con CSS: la lista corta tiene cuatro líneas de una línea cada una.

Se probó `justify-content:space-between` para repartir ese aire y **es peor**: los cuatro ítems quedan separados por ~90px y se leen como cuatro frases sin relación entre sí. Quedó `flex-start`, con el sobrante junto al final, que al menos se lee como "esta tarjeta tiene menos", que es la verdad.

**Lo que falta es contenido, no CSS.** Gastón lo dejó anotado como "luego alineamos contenidos". Las salidas reales son dos: sumarle dos ítems más a "No es para vos si…" para que empareje, o mover ahí alguna línea del remate. Con cuatro ítems contra seis, cualquier arreglo de layout va a ser un parche.

Las listas pasaron a **una sola columna** dentro de cada tarjeta. Las dos columnas que tenían existían para que la cascada del stagger bajara una y después la otra en vez de ir en zigzag; con la tarjeta a media pantalla dejaban líneas de tres palabras, y en una columna el problema del zigzag desaparece solo.

### Footer: las columnas de links dejan de estar desparramadas (22/08/2026)

Con `repeat(3, minmax(0,1fr))` cada columna de links ocupaba un cuarto del ancho para sostener una lista de **uno o tres ítems**, así que "Programas" y "Otros servicios" quedaban con medio ancho de aire a la derecha y las tres se leían desparramadas en vez de como un grupo. Ahora van a `max-content` con separación fija de 64px: cada una mide lo que mide su link más largo y el sobrante se lo queda la columna de marca, que es la única con texto para llenarlo.

### Foto de Carolina, segunda vuelta (22/08/2026)

La primera —la de la fiesta, 738x1600— tenía a Caro chica en el cuadro, así que para llenar el círculo había que recortar muy cerrado y quedaba con demasiado zoom. Gastón pasó otra, 1500x2000 y de cerca. El recorte nuevo es más suelto a propósito: entra la cabeza entera con aire, no solo la cara.

### Testimonio de Carolina, y la cinta en blanco en iOS (22/08/2026)

**Cuarto testimonio en la cinta: Carolina Ibañez, 35 años, Argentina.** Autorización del 22/08/2026, texto y foto. Del mensaje se publica **el último párrafo entero y contiguo** —*"Hoy no solo cambió mi cuerpo: cambió mi forma de cuidarme..."*—, 173 caracteres, justo en el rango de las otras cuatro (158 a 181), así que la tarjeta no cambia de alto.

**Lo que quedó afuera y por qué vale la pena anotarlo:** el párrafo del medio de Caro es el único de toda la cinta que habla de **alimentación**, y dice lo más propio de su testimonio — que la clave fue entender la combinación entre comer bien y entrenar fuerza, *"uno sin el otro no alcanza"*. Mide 191 caracteres y no entra sin agrandar la tarjeta. Queda anotado en `build-testimonios.py`: si algún día se rota el destacado, ese párrafo da para un relato.

**La cinta se veía en blanco en el teléfono, y no era el bug del 22/08 a la mañana.** Ese día se arregló que el arrastre pausara la animación en touch, y era un bug real, pero el blanco era otra cosa.

**No es un hueco de geometría, y eso se midió:** recorriendo el ciclo entero a 390px, el borde derecho de la última tarjeta **nunca baja de 3070px**, o sea que siempre sobran ~2700px de tarjetas fuera de pantalla. La regla del hueco se cumplía de sobra.

**Es un problema de rasterizado.** Con `will-change:transform` la pista entera es **una sola capa de compositor**, y con 3 grupos medía **4590px de ancho**. Safari en iOS no rasteriza capas de más de ~4096px: pinta lo que entra y deja el resto en blanco, que es exactamente lo que se reportó. En desktop no pasa porque el límite es mucho más alto.

**Arreglo: en mobile la pista es de 2 grupos.** `(2-1) x 1530 = 1530px` cubre cualquier teléfono con margen, y la capa baja a **3060px**, debajo del límite. Se hace con `.t-cinta > .t-grupo:nth-child(n+3){display:none}`, que **no depende de cuántos grupos genere el script** — al sumar testimonios no hay que tocarlo. Va con un `@keyframes marquee-mobile` propio que recorre `-50%`, escrito **a propósito sin `calc()`**: el patrón con `calc(-100% / N)` es el que reescribe `build-testimonios.py`, y este no tiene que moverse cuando cambie la cantidad de grupos de desktop.

**De paso, la velocidad en mobile.** Con la duración de desktop daba 27 px/s sobre una pantalla de 390px y Gastón lo marcó como "va muy rápido". Ahora son **85s sobre un grupo de 1530px, o sea ~18 px/s**. Desktop queda igual: 56s, 39.8 px/s.

**Regla nueva para la próxima:** al sumar testimonios, además de la regla del hueco hay que mirar **el ancho total de la pista contra los ~4096px del límite de capa de iOS**. Son dos cuentas distintas y la segunda no la hace el script todavía.

### Tres retoques de la pasada (22/08/2026)

- **Se sacó la franja 2020 / 2023 / HOY** del destacado de Silvia, por pedido de Gastón. El relato de ella ya cuenta el recorrido y la franja lo repetía resumido. Salieron también `.t-datos`/`.t-dato` del CSS y dos comentarios que quedaban hablando de una franja inexistente. El panel cierra con la firma y los 48px de padding de abajo, sin hueco huérfano.
- **La credencial de "Sobre mí" pasó a ser una firma.** Decía "Prof. Jimena Ibañez · Profesora Nacional de Educación Física" en mono a 12px: repetía un cargo que ya está más arriba y pesaba como dato técnico. Ahora dice solo **"Prof. Jimena Ibañez"**, en Archivo cursiva a 13px. **Trampa de especificidad que costó una medición:** `.sobre-texto p` es (0,1,1) y le gana a `.credential` (0,1,0), así que con el selector corto la firma se quedaba en los 16px del párrafo aunque la regla dijera 13. Va como `.sobre-texto .credential`.
- **Casilleros:** ahora son **"+4 países"** y **"1 a 1 · cada alumna, sin planes genéricos"**. El +4 lo pasó Gastón; los testimonios publicados muestran 3 países (Argentina, Puerto Rico, Estados Unidos), así que el cuarto son alumnas que no están en la cinta. Queda anotado en el CSS para que nadie lo "corrija" a 3 mirando solo las tarjetas.

### "Sobre mí" rehecha contra el benchmark de la competencia (22/08/2026)

Gastón comparó la sección con **Noelia Rodríguez** y **Sara Ariadna** y el veredicto fue: *"hay mucho texto, no empieza con un llamado o copy poderoso, no se vende bien, la UI no es linda, la imagen tampoco"*.

**El problema de raíz era el titular.** Noelia abre con "La Mujer Detrás de tu Transformación" — habla de la visitante. Esta sección abría con **el cargo de Jimena** en tres renglones. Un cargo es prueba, no gancho: ahora va abajo y chico, en la línea de credencial.

El titular pasó a ser **su tesis, que ya estaba escrita pero enterrada en el párrafo 1**: *"Entrenar perfecto no existe. Entrenar para tu etapa, sí."* El cuerpo bajó de **~180 palabras a ~52**, y entraron las dos cosas que la competencia tenía y esta sección no: **casilleros de prueba** y **una salida** (link a `#proceso`; antes la sección no llevaba a ningún lado).

**Los números son el punto delicado.** Lo que más vende de la sección de Noelia es "+2000 mujeres transformadas · +20 años de experiencia", y es exactamente lo que **no se puede copiar**: `contexto.md` prohíbe escribir un dato de negocio sin preguntarlo y ya se inventó dos veces en este proyecto. Se publicaron **solo dos casilleros verificables** — los 3 países salen de los testimonios ya publicados, el "1 a 1" es cómo funciona el programa. **Falta pedirle a Jimena un número real** (años entrenando, alumnas acompañadas): con un tercero la sección pega bastante más, y la grilla ya lo soporta sin tocar CSS.

**Foto nueva**, y se sobrescribió `img/jimena-sobre-mi.jpg` en vez de agregar un archivo: ese nombre lo usan también `og:image`, `twitter:image` y el JSON-LD, así que las cuatro referencias pasaron juntas a la foto buena. La anterior era una toma en la vereda con pasto, ladrillos y un auto estacionado, a contraluz; la nueva es en el gimnasio. Se recortó a 1100x1375 (4:5, cabeza a mitad de muslo) y pesa 172 KB contra 249 KB de la anterior. **Sigue siendo selfie de espejo con el celular a la vista**: el pendiente de foto profesional de estudio no está cerrado, solo mejorado.

Al venir ya encuadrada se **borraron el `transform:scale(1.14)` y el `object-position:50% 6%`** que estaban calibrados a mano para la toma anterior. Regla para la próxima: encuadrar al recortar, no compensar con CSS.

**Dos cosas de layout que costaron medición:**
- La foto ahora usa `height:100%` con `align-items:stretch` en vez de `aspect-ratio:4/5`. Con la proporción fija quedaba más baja que la columna de texto y flotaba centrada con aire muerto arriba y abajo; ahora el desbalance entre columnas es **0px exacto**. En el breakpoint de 960px hay que devolverle el `aspect-ratio`, porque al apilarse desaparece la referencia de altura y la foto colapsaría al `min-height`.
- Los casilleros probaron **tres implementaciones**: `repeat(auto-fit, minmax(0,1fr))` genera cientos de pistas de 0px y solo funciona de casualidad; con flex `1 1 0` el padding del divisor queda fuera del reparto y salían **21px desparejos** (164 vs 175 medidos a 360px); quedó `grid-auto-flow:column` + `grid-auto-columns:1fr`, que da columnas exactamente iguales sin que la regla sepa cuántas hay.

**Se perdió la cita** *"El verdadero cambio empieza cuando una mujer se siente fuerte, capaz y segura de sí misma"*, que era el pie de foto en itálica. El titular nuevo ocupa ese lugar emocional y tenerlos a los dos era repetir el registro. Es copy real de Jimena, así que si se la quiere recuperar, el lugar natural es el hero o el cierre — no acá.

Medido de 360 a 1280px: sin overflow, foto en 4:5 al apilarse y casilleros parejos en todos los anchos.

### La cinta de testimonios se congelaba en mobile (22/08/2026)

Reportado por Gastón: en el teléfono los testimonios "se pierden, queda en blanco después de que pasan los que ya existen"; en desktop giraba infinito.

**No era el loop ni faltaban tarjetas.** Cualquier toque sobre la cinta disparaba `pointerdown`, y el handler del arrastre hace `anim.pause()` para poder mover el reloj de la animación con el dedo. El problema es lo que pasa después: cuando el gesto se convierte en scroll vertical nativo —que es justo lo que `touch-action:pan-y` habilita—, **el navegador no siempre entrega el `pointerup` ni el `pointercancel`** que reanudarían la animación. La cinta quedaba pausada a mitad de recorrido y de ahí en más se veía estática, con el hueco del final del grupo a la vista.

**Arreglo: el arrastre queda solo para mouse real** (`window.matchMedia('(pointer: fine)')`). En touch no se registra ningún listener, así que nada puede pausar la animación y la cinta corre pura por CSS, infinita, sin excepción. No se pierde nada de valor: la cinta ya se mueve sola y en mobile el dedo sirve para scrollear la página, no para arrastrar un carrusel. Se sacó también el `touch-action:pan-y`, que existía únicamente para reservarle el eje horizontal a ese arrastre.

**La lección general:** pausar una animación en `pointerdown` es seguro solo si tenés garantizado el evento que la reanuda. En touch no lo tenés.

### Se sacó la nota bajo el programa (22/08/2026)

*"¿Tenés dudas si es para vos? Escribime y lo vemos juntas, sin compromiso."* Pedido de Gastón. Se borró también `.planes-nota`, que quedaba sin usos. El aire lo resuelve el padding de la sección, no hizo falta compensar nada.

### El cierre pasa a ser una persona, no una caja (22/08/2026)

Pedido de Gastón: *"el Instagram lo siento al pedo en ese componente"*. Tenía razón, y buscando el porqué apareció algo más grande.

**El diagnóstico salió de leer la sección en voz alta: decía "escribime" cuatro veces.** El `<h3>` ("Escribime y arrancamos") repetía el título de la sección, y la bajada ("La forma más rápida de empezar es por WhatsApp") repetía el botón que estaba 40px más abajo. Las dos líneas eran relleno para que la caja no quedara vacía — por eso se leía inflada y despegada del resto de la página.

**Instagram era una fuga, no una opción.** La sección tiene un solo trabajo, que te escriban, y el segundo botón mandaba a otra app justo en el momento de decidir. Coherente con lo que ya estaba escrito en los pendientes: **Instagram es canal de captación, no de cierre**.

Sacado el relleno y la fuga, la caja quedaba con una sola cosa (el botón), así que el espacio libre lo ocupa **lo único que la sección necesitaba y no tenía: la cara de Jimena**. La bajada promete "te respondo personalmente" y hasta ese día eso era una afirmación sin cara.

**La caja pasó de 300px de alto a 118px**, de tarjeta alta y centrada a **franja de identidad + acción**: avatar, nombre y credencial a la izquierda, un solo CTA a la derecha. No inventa un patrón nuevo — el avatar redondo con nombre y línea de contexto es **el mismo componente de las tarjetas de testimonios** (`.t-av`), y la estructura "dato a la izquierda, CTA a la derecha" es la de `.programa-top`, la banda del precio. Debajo va una línea de microcopy, igual que el hero bajo su CTA: *"El primer paso es tu entrevista inicial, y es gratuita"*.

**Se revirtió una decisión escrita del 15/08 a propósito.** Ese día Instagram pasó de link suelto a `.btn-ghost` porque como link inline medía 15px de alto tocable. Ese problema era del **link inline**, no de que Instagram tuviera que estar en el cierre: en el footer sigue con su botón y su área tocable correcta. `.btn-ghost` quedó sin usos y se borró.

**Costo asumido de medición:** se pierde el evento `instagram_cierre` de GA4, que era el único lugar que lo emitía. `instagram_footer` sigue intacto, así que las visitas a Instagram se siguen midiendo, pero **no se puede comparar más cuánto aportaba el cierre**.

**Asset nuevo: `docs/img/jimena-avatar.jpg`** — recorte cuadrado de 240px de la cara, generado desde `jimena-sobre-mi.jpg`. Hace falta y no es un capricho: la foto de "Sobre mí" es de cuerpo entero, y a 66px de círculo la cabeza queda de ~9px, o sea no se reconoce a nadie. Con `object-fit:cover` sobre la original no se arregla, porque el problema es la escala, no el encuadre. **Si en algún momento hay una foto nueva de Jimena, el avatar se regenera aparte, no se apunta el `<img>` a la de cuerpo entero.**

Dos detalles del avatar sobre este fondo: el degrade vino→bronce de `.t-av` **desaparece sobre una caja del mismo degrade**, así que la caída sin foto va en `--wine-950` sólido; y lleva un anillo blanco al 38% para despegar el círculo del gradiente.

**Medido de 360px a 1440px** (360, 390, 721, 768, 860, 1024, 1440): sin overflow horizontal, botón de 55px en desktop y 60px en mobile —sobre el mínimo de 44—, y el nombre no se parte en ningún ancho. Entre 721 y ~740px la credencial pasa a dos líneas sin romper nada, porque el alto lo fija el avatar.

### 22/08/2026 — "Cómo trabajo": copy del paso 01 y 02, y las cuatro ilustraciones pasaron a estar animadas

**El copy, pedido por Jimena.** El paso 01 dejó de llamarse "Ficha de ingreso" y pasó a **"Entrevista inicial"**, alineado con lo que el hero y el cierre ya prometían desde el 21/08 ("Quiero mi entrevista gratuita", "El primer paso es tu entrevista inicial, y es gratuita"): el sitio ofrecía una entrevista y el proceso decía que lo primero era llenar una ficha. Ahora dice *"Es una conversación gratuita de 30min donde revisamos tus objetivos…"*. El paso 02 pasó de "Evaluación inicial" a **"Evaluación"** a secas —dos "inicial" seguidos en cuatro pasos— y su texto ahora nombra lo que se hace de verdad: estudio de composición corporal, evaluación física y foto inicial. Se sacó además una raya (—) del paso 03 por preferencia de puntuación de Jimena.

**Las cuatro ilustraciones ahora son loops en CSS.** Antes eran SVG estáticos y dos de ellos no se entendían. Qué muestra cada una y por qué:

1. **Chat que se acumula.** Entra "escribiendo", se convierte en mensaje y **el mensaje se queda**; recién al cerrar el ciclo se limpia todo. La primera versión borraba cada mensaje antes del siguiente y se leía como notificaciones sueltas, no como una conversación.
2. **Anillo + caliper.** El `41%` y el arco se dibujan juntos. **La etiqueta "TU PUNTO DE PARTIDA" salió de adentro del círculo**, donde no entraba, y quedó abajo separada por una línea.
3. **Plantilla → tu semana.** Concepto entero nuevo. Antes decía `ACUM / INTENS / DESC`, jerga de periodización que no significa nada para quien entra al sitio. Ahora son los siete días de la semana: arrancan como plantilla gris pareja y se transforman en la semana real (entreno, movilidad, descanso). Dice lo mismo que el título de la diapositiva sin pedir vocabulario.
4. **Progreso.** Se eliminó la línea de tendencia que cruzaba las barras: quedaba sucia sobre los bordes redondeados. Las etiquetas pasaron de `S1 → S12` a **`MES 1` / `MES 6`**.

**Dos bugs que se comieron el tiempo de esta pasada, y las dos lecciones:**

- **Un `var()` que no existe invalida el shorthand `animation` entero, y no anima nada — en silencio.** Las animaciones se escribieron con `var(--ease-in)`, un token que existía en el prototipo pero **no en este sitio**. No hay error en consola: la declaración simplemente se descarta. Se resolvió declarando `--pvEase` local en `.pin-viz`, y no en `:root`, porque el sitio maneja dos curvas y un nombre suelto en `:root` se presta a que la próxima pasada agarre la equivocada.
- **Un selector genérico le puede ganar en especificidad a la clase que quiere corregirlo.** `.pin-viz svg [class]{transform-origin:center}` (0,2,1) le ganaba a `.pvWk{transform-origin:center bottom}` (0,1,0), así que las barras crecían **desde su centro, hacia arriba y hacia abajo**, y el sobrante de abajo tapaba las letras de los días — se veía sobre todo en la M de miércoles. **La regla genérica ahora declara solo `transform-box`**, que es lo único que necesita ser genérico. Con `transform-box:fill-box` el origen ya cae en el centro por defecto, así que no hacía falta declararlo.

**Medido en el DOM, no mirado:** las 7 barras comparten exactamente la misma base (mismo `bottom` en píxeles) y quedan 11px libres hasta las letras; los 4 SVG entran en su caja de 210px sin desbordar; y las 34 animaciones `pv*` corren de verdad.

**El contador del `41%` se lee del reloj de la animación del aro (`animation.currentTime`), no de un cronómetro propio.** Es lo único que CSS no puede animar, porque el contenido de un `<text>` no es una propiedad animable. Con cronómetro propio se desincronizaba: el CSS pausa el aro cuando su diapositiva no está activa (`.pin-slide:not(.on)`) y el número seguía contando contra un arco congelado, así que al volver a la 02 se veía el aro lleno diciendo 12%.

**Esto es solo escritorio.** `@media (max-width:720px){ .pin{display:none} }` ya apagaba el panel fijo desde antes: en mobile los cuatro pasos se leen como lista y ningún SVG se dibuja. Ningún riesgo mobile, y tampoco ganancia — si alguna vez se quiere movimiento ahí, hay que diseñarlo aparte.

**Nota de método:** `qa-local.py` no corrió porque en la máquina de Jimena no hay Python instalado. Se levantó un servidor equivalente en PowerShell, sin versionarlo. Si esto se repite, conviene decidir si el script de QA pasa a tener una variante que no dependa de Python.

### 23/08/2026 — "¿Te suena algo de esto?" pasa a una sola tarjeta, y el filtro sale de ahí

**Qué cambió, pedido de Jimena.** La sección tenía dos tarjetas lado a lado ("Es para vos si… / No es para vos si…") y pasa a **una sola tarjeta con la lista de dolores**. El criterio: esta sección hace *una* cosa —que la persona se reconozca— y "¿a quién le sirve el programa?" es otra pregunta, que además llegaba antes de que el sitio contara qué ofrece y cuánto sale. La bajada dejó de anunciar el filtro ("Antes de contarte cómo trabajo, prefiero que sepas si esto es para vos") y ahora es el gancho de lectura: *"Si te cuidás, te movés y aun así tu cuerpo no cambia, seguí leyendo."*

**Esto revierte el pedido de Gastón del 22/08** ("dos tarjetas verticales del mismo tamaño"), que tiene apenas un día. La tensión que él quería tapar —6 items contra 4— desaparece sola al quedar una sola lista, pero **conviene que lo sepa antes de que lo vea en vivo**.

**El par no se borró: está comentado en `docs/index.html`, justo arriba de `#contacto`.** Ahí es donde más sentido hace si vuelve —después del precio, "¿esto es para mí?" es la pregunta que queda abierta— pero la ubicación la decide Jimena. Todo el CSS de `.problema-par`, `.bloque-si` y `.tira-no` sigue entero, así que reactivarlo es descomentar.

**Trampa anotada para cuando se reactive:** la columna "es para vos si…" es casi palabra por palabra la lista de dolores que ahora vive en `#problema`. Si vuelve tal cual, la página dice lo mismo dos veces. Antes de descomentar hay que reescribir esa columna en términos de **encaje** (qué espera, cuánto tiempo puede darle, qué busca), que es lo que un filtro al lado del precio tiene que responder.

**Sobre la copy:** el texto que trajo Jimena venía en español peninsular ("te cuidas", "báscula", "has probado", "ti misma"). Se pasó entero a voseo y a vocabulario rioplatense ("te cuidás", "balanza", "probaste", "vos misma"), como el resto del sitio. Se sumó un dolor que antes no estaba y que es el más fuerte de la lista: *"Y lo peor: dejaste de confiar en vos misma."*

**No se agregó la volanta "El Desafío"** que venía en el material de referencia. El 22/08 se sacó la volanta "SOBRE MÍ" por el motivo opuesto —no aportaba nada que el titular no dijera— y "¿Te suena algo de esto?" ya dice de qué va la sección. Si se quiere volanta, es una decisión de sistema y van todas o ninguna.

**`.problema-uno` limita la tarjeta a 760px** y no hereda los 1000px de `.problema-par`: a ese ancho los renglones pasaban de 100 caracteres. Medido de 360px a 1280px, sin desborde en ningún ancho.

#### Bug preexistente encontrado y arreglado: los bullets nunca volvían a su lugar

Los seis items de `.bloque-si` **aparecían con el fade pero se quedaban 16px más abajo para siempre**. El movimiento de subida —el motivo entero del stagger que se calibró el 22/08— no ocurría nunca.

La causa es de especificidad, otra vez: la regla que fija el punto de partida es `.has-js .bloque-si ul.reveal.stagger > li` **(0,4,2)** y la regla general del sitio que los devuelve a su lugar es `.has-js .reveal.stagger.in-view > *` **(0,4,0)**. Los dos nombres de elemento (`ul`, `li`) alcanzan para que la primera le gane a la segunda, así que `transform:none` no se aplicaba nunca.

**No se veía a ojo** porque los seis quedan corridos exactamente lo mismo y la lista se lee pareja. Apareció midiendo el `transform` computado contra el de otra `.reveal.stagger` del sitio (`.programa-feats`), que sí daba `none`. Es el mismo tipo de error que el de las barras del proceso el 22/08: **una regla larga y específica ganándole en silencio a la corta que la tenía que corregir.** Van dos en dos días; cuando un `transform` de reveal no se comporte, lo primero a mirar es la especificidad, no el keyframe.

## Estructura de la página web

Hero → **Problema ("¿Te suena algo de esto?")** → Sobre mí → Testimonios → **Cómo trabajo** → **Programa** → Contacto (WhatsApp) → Footer.

El orden es deliberado: **el método va antes que el precio**. Explicar cómo se trabaja antes de mostrar cuánto sale es lo que hace que el precio se entienda. Antes estaba al revés.

**Sobre mí:** foto a la izquierda (placeholder hasta tener la real), con la cita y la credencial debajo; título y párrafos a la derecha. Las especialidades son una banda a todo el ancho que cruza las dos columnas, separada por una línea fina, sin caja. Se probó como tarjeta con borde y sombra y competía visualmente con la foto.

**Cómo trabajo:** panel fijo con `position: sticky` que cambia mientras se scrollea, al estilo de Equinox. La izquierda dice la idea de cada paso, la derecha el mecanismo concreto. Nunca lo mismo dicho dos veces. En mobile el panel se oculta y los cuatro pasos se leen como lista.

**Programa (13/08/2026, reemplaza a "Planes"):** Jimena decidió pasar de tres planes (Entrenamiento, Integral, Nutrición) a un solo programa con precio único — USD 35/mes, confirmado real por ella. Se sacó el toggle de duración (Mensual/Semestral/Anual) porque ya no hay nada que comparar. La sección es una sola card (`.programa-card`) con el precio y el CTA arriba, y debajo una lista de 6 features numeradas (entrenamiento adaptado a gimnasio o casa, alimentación flexible, WhatsApp, revisión con datos cada 2 semanas, videollamada mensual 1 a 1, comunidad de mujeres). El copy de las features lo pasó Jimena copiado de otra página como referencia de estructura — se reescribió con palabras propias, mismo criterio que ya está anotado en `contexto.md`/memoria de la IA sobre no copiar texto de ejemplo literal.

## Metodología de entrenamiento (referencia para las herramientas del proyecto)

- **Modelo de periodización usado por defecto:** lineal por bloques (acumulación → intensificación → descarga) con autorregulación por RPE — no doble progresión, no ondulante. El rango de reps baja semana a semana en una sola dirección mientras la carga sube, con descarga al final del bloque.
- **Estructura de sesión:** bloque de fuerza (ejercicio principal) + bloque accesorio (hipertrofia) + finalizador metabólico corto.
- **Cálculo nutricional:** fórmula de Mifflin-St Jeor para TDEE, con déficit moderado de referencia de -300 kcal/día. Reparto de macros: proteína ~2 g/kg de peso, grasas 25-30% de las calorías, carbohidratos el resto.

## Preferencias de contenido y formato

- Listas con viñetas redondas (•), nunca guiones (-).
- Explicar siempre el porqué de cada decisión (entrenamiento, nutrición, diseño) — no dar recomendaciones genéricas sin fundamento.
- Aclarar siempre qué es competencia de una entrenadora y cuándo corresponde derivar a un médico o nutricionista, especialmente en contenido sobre condiciones hormonales.
- Nada de promesas de resultados imposibles ni dietas extremas — es un principio de marca, no solo de estilo de redacción.

## Herramientas internas (`herramientas/`)

- Formato elegido: planillas Excel (`.xlsx`) con fórmulas, no plantillas de texto ni herramientas web públicas. Motivo: es el formato que Jimena ya usa hoy, y no son parte del sitio público — quedan fuera de `docs/`.
- Cada planilla se genera con un script `build-*.ps1` (Excel vía COM automation) versionado junto al `.xlsx` resultante, para poder reproducir o corregir la estructura sin editar el binario a mano.
- `calculadora-nutricional.xlsx` implementa exactamente la fórmula de la sección "Metodología de entrenamiento" de `contexto.md` (Mifflin-St Jeor, déficit -300 kcal, proteína 2 g/kg, grasas 27.5% como punto medio del rango 25-30%, carbohidratos el resto). Si esa fórmula de referencia cambia, hay que actualizar ambos lugares.
- `planificador-mesociclos.xlsx` usa la tabla RPE→%1RM estándar (Tuchscherer/RTS) para sugerir carga en kg a partir del 1RM cargado por la entrenadora.
- Nota técnica: generar archivos Excel con Excel COM automation en PowerShell 5.1 tiene un bug conocido — si una misma línea de código asigna valores de tipos alternados (ej. Int32 y luego Double, o número y luego string vacío) a la propiedad `.Value2` dentro de un loop, PowerShell tira `InvalidCastException` de forma intermitente. Solución aplicada: asignar siempre vía `InvokeMember` en vez de la sintaxis de propiedad directa de PowerShell, y evitar escribir `""` alternado con números en la misma celda/loop.

## Estrategia (`estrategia/`)

- Carpeta abierta el 11/08/2026, **en curso**. Tiene `propuesta-de-valor.md` y `business-case.md`, que se leen juntos.
- La decisión que bloquea todo lo demás es el posicionamiento: mujeres +30 en general, o especialización en salud hormonal femenina. Define precio, canal y mensaje. Hasta que no se resuelva, no tiene sentido escribir misión/visión, Business Model Canvas ni FODA.
- **Decisión de Gastón del 11/08/2026: todo va en el repo público, incluido el análisis financiero.** Se evaluó separarlo en un repo privado y se descartó: tener todo en un solo lugar compartido con Jimena vale más que mantener reservados los precios. La única regla de privacidad que se mantiene firme es la de datos de alumnas, porque son datos de terceros.
- Hallazgo central del business case: el techo del negocio lo fija el precio, no la capacidad. El plan más caro es el que peor rinde por hora de trabajo.

## Pendientes

### Estado al cerrar el 18/08/2026 — leer esto primero

**Lo que pasó ese día, en orden:** se sincronizaron los cuatro archivos de documentación (estaban diciendo cuatro cosas distintas), se rediseñó Testimonios cuatro veces, y en el medio quedó claro que **el problema no era Testimonios sino el sistema de tokens** — de ahí salió la pasada de sistema visual (blanco, títulos livianos y grandes, botones en píldora), que es el cambio más grande que tuvo el sitio hasta ahora.

**Lo que está pendiente y bloquea la fecha, en orden de urgencia:**

1. ✅ **El dominio ya no bloquea nada: resuelto entero el 19/08/2026.** `entrenaconjime.com` está comprado, apuntado y en vivo con HTTPS. Era el único punto del lanzamiento con una espera que no dependía de que alguien hiciera algo, y esa espera terminó siendo de menos de un minuto. Detalle en la sección de abajo.
2. 🔴 **Las reglas de la comunidad de WhatsApp** siguen sin definirse y la feature 06 se promociona en el sitio en vivo.
3. 🔴 **Foto profesional de Jimena** para "Sobre mí". Con el sitio ahora blanco y limpio **la foto actual canta mucho más** que antes: sobre crema se disimulaba, sobre blanco y al lado de un título liviano de 40px es lo primero que rompe.
4. ✅ **Testimonios: cerrado el 19/08/2026.** Llegaron cinco citas con edad y país, la historia completa de Silvia, cuatro de las cinco fotos y las autorizaciones. La sección dejó de ser un diseño esperando contenido. Queda solo 🟢 `daiana.jpg`, que no bloquea nada. La carga de los próximos testimonios tiene proceso escrito en `testimonios.md`.
5. 🔴 **Sin favicon ni og-image propia** (detectado el 19/08/2026). La pestaña muestra el ícono default del navegador y el preview al compartir es una foto suelta. Con el sitio ya en vivo y el lanzamiento el 23/08, es lo que se ve cada vez que alguien pasa el link por WhatsApp. Está bloqueado por el símbolo de marca, que todavía no existe — ver "Identidad de marca" más arriba.

**Lo que quedó sin commitear a propósito:** `docs/_testimonios-preview.html`, que tiene el bloque destacado con foto en retrato 4:5 y el antes/después armado. No se publica porque tiene datos inventados y el sitio está en vivo.

**Advertencia sobre el proceso, que costó cara.** Se rediseñó Testimonios cuatro veces empujando la forma contra un contenido que no daba, y recién a la cuarta quedó claro que faltaban dos cosas distintas: un sistema visual (que se arregló) y contenido real (que sigue faltando). Antes de volver a iterar sobre una sección, conviene preguntarse si lo que falta es diseño o es material.

### Fecha de lanzamiento: 23/08/2026, con dominio propio

**Decisión de Gastón del 17/08/2026.** El sitio tiene que estar en vivo bajo un dominio propio el **23/08/2026**. Deja de ser una fecha abierta y pasa a ser el hito que ordena todo lo demás.

Dos consecuencias sobre lo que ya estaba escrito acá:

• **El dominio deja de ser una idea 🟢 de septiembre.** En `backlog.md` estaba en Operaciones como "definir si se contrata dominio/hosting propio o se sigue con GitHub Pages", sin fecha, y en el gantt figuraba recién el 20/09. Está decidido: dominio propio, y hay que comprarlo y apuntarlo. GitHub Pages puede seguir siendo el hosting — un dominio propio no obliga a cambiar de hosting, se apunta con un CNAME.
**El dominio es `entrenaconjime.com`, comprado el 19/08/2026 en Cloudflare.** Lo eligió y lo registró Gastón. No está entre los tres que se habían chequeado el 17/08 (`jimenaibanez.com`, `jimenaibanez.com.ar`, `pfjimenaibanez.com`) y el cambio de criterio importa: el nombre no es la persona sino **lo que se hace con ella** — se lee como una frase ("entrená con Jime"), usa el diminutivo con el que la conocen las alumnas y funciona dicho en voz alta en un audio de WhatsApp o en una story, que es por donde va a llegar la mayoría del tráfico. Un dominio con nombre y apellido obliga a deletrear.

Consecuencias técnicas, **todas ejecutadas el 19/08/2026**:

• ✅ **`CNAME` versionado dentro de `docs/`**, con `entrenaconjime.com` y nada más. Tenía que estar adentro de `docs/` o cada push lo borraría, porque GitHub Pages publica esa carpeta entera.
• ✅ **DNS en Cloudflare.** Cuatro registros `A` en el apex hacia `185.199.108-111.153` más un `CNAME` de `www` hacia `gaston-perez-art.github.io`, los cinco en **DNS only** (nube gris). Lo del proxy era real: en naranja, GitHub no puede validar el apex ni emitir el certificado. Mientras la nube siga gris, el modo SSL/TLS de Cloudflare no interviene; **si alguna vez se prende, hay que pasarlo a Full (strict) antes**, nunca *Flexible*.
• ✅ **El certificado no tardó 24h: se emitió en menos de un minuto.** Let's Encrypt, cubre el apex y el `www`, vence el 17/11/2026 y se renueva solo. HTTPS forzado activado, así que las cuatro variantes de entrada terminan en `https://entrenaconjime.com`.
• ✅ **URLs absolutas revisadas:** el sitio no tiene `og:url`, `canonical` ni `sitemap`, así que no había nada que corregir. El `README.md` ya apunta al dominio nuevo. La URL vieja de `github.io` sigue funcionando y redirige sola.
• ⬜ **Queda un pendiente menor, sin urgencia:** verificar la propiedad del dominio en GitHub (Settings → Pages → Verified domains, vía un registro TXT en Cloudflare). No cambia nada de lo que funciona hoy; protege el nombre si el repo alguna vez dejara de publicar.

**Observación aparte, no bloquea nada:** al no haber etiquetas Open Graph, cuando alguien comparte el link por WhatsApp o Instagram **no aparece la tarjeta con imagen y título** — se ve la URL pelada. Para un sitio cuyo tráfico va a llegar por stories y audios de WhatsApp, es una mejora de bajo costo a considerar después del lanzamiento.

• **Se abre un corte entre "lanzamiento" y "después".** Antes del 23 solo entra lo que bloquea publicar; todo lo que sea mejora del sitio ya publicado pasa a después. El criterio para decidir de qué lado cae cada pendiente: *¿esto hace que la página no se pueda mostrar, o solo que se pueda mostrar mejor?*

**Mejoras pedidas por Jimena (14/08/2026) — ver `backlog.md` para la vista por área:**

- [x] Sacar los eyebrows que no aportaban valor (ver Decisiones de diseño).
- [x] Bug: botón "Quiero mi cambio" ahora abre WhatsApp directo (ver Decisiones de diseño).
- [x] Bug: ícono de WhatsApp roto en el botón de contacto (ver Decisiones de diseño).
- [x] Bug encontrado sin pedirlo: menú hamburguesa no aparecía entre 401-720px (ver Decisiones de diseño, sección Mobile).
- [x] Animación del claim del hero: arreglada en dos pasos — el fantasma semitransparente (14/08) y el hueco de ~0,4s por relevo que dejaba ese arreglo (15/08). Ver Decisiones de diseño.
- [x] Hacer más armónica la sección "Sobre mí" (15/08/2026): retrato 4:5, título en dos líneas, cita con más presencia y corregido el recorte apaisado de tablet/mobile. Ver Decisiones de diseño. **Queda abierto lo que el CSS no arregla: la foto en sí.**
- [ ] Nueva sección antes de "En qué me especializo" con logos animados (marquee) de empresas de prestigio donde trabajó Jimena. **Bloqueada: falta que Jimena pase los logos y la autorización de uso.**
- [ ] Reescribir "En qué me especializo" — hoy es una lista de tags que no cuenta nada.
- [x] Testimonios: hacerlos menos genéricos (19/08/2026). Se rehizo la tarjeta con la forma de la referencia de Coderhouse — foto, nombre, edad y país — y el destacado pasó a contar el recorrido de Silvia. Ver Decisiones de diseño. **Queda pendiente el archivo de las cinco fotos y la autorización de Jimena; el código ya las espera y la tarjeta no se rompe sin ellas.**
- [x] Sumar más animación en general (que no parezca landing "de juguete") y jugar más con contraste de color (15/08/2026, dos pasadas). Botones y CTAs a gradiente wine→bronze, "Cómo trabajo" como única sección oscura del sitio, recorrido de la animación de aparición de 16px a 34px, y el bug de fondo: la red de seguridad del script revelaba todo a los 2s y las animaciones de scroll nunca llegaban a verse. Ver Decisiones de diseño.
- [ ] Mejorar todos los gráficos del sitio — falta definir con Jimena cuáles y qué espera de cada uno.
- [ ] Mejorar la sección de contacto "Escribime y arrancamos".
- [x] Pasada completa de mobile (15/08/2026), con viewport real de 390px vía harness con iframe. Cinco bugs encontrados midiendo el DOM, no mirando. Verificado: cero overflow horizontal y cero áreas táctiles bajo 44px. Ver Decisiones de diseño.
- [ ] Decidir si el CTA del nav ("Escribime") va directo a WhatsApp o sigue scrolleando a `#contacto` — es lo único que queda contra el criterio del 14/08 de no agregar pasos.

**Mejoras pedidas por Jimena (12/08/2026), en curso:**

- [x] Hero: ampliar el lead y el `<title>` para no limitarlo a "reducir grasa y ganar masa muscular" — incluir mantenimiento y ganancia muscular sin pérdida de grasa.
- [x] "Sobre mí": reescrito (13/08/2026) con la historia real que contó Jimena — mamá de dos hijos, entrenó durante embarazo y posparto, aprendió a adaptar el movimiento a cada etapa de vida. Reemplaza el texto anterior, que era solo credenciales.
- [x] Plan Entrenamiento: agregado "Videollamada cada 2 semanas" a `plan-feats` (y actualizada su lista de excluidos para que coincida con el vocabulario de Integral). *Superado el 13/08/2026: los tres planes se reemplazaron por un solo programa, ver "Programa" en Decisiones de diseño.*
- [x] Plan Integral: sumado "Reordenamiento alimenticio", "Plan de alimentación a medida" y "Medición cada 2 semanas" a `plan-feats`. *Superado el 13/08/2026, ídem anterior.*
- [ ] Decidir dónde va la foto real de Jimena en el hero (sigue abierto — el espacio "signature" ya no es una foto de Jimena, ahora es el video de una alumna, ver Decisiones de diseño).
- [x] **Video del hero subido (13/08/2026, con un ajuste pedido después).** Jimena pasó 3 clips (WhatsApp) de alumnas entrenando. Primera versión combinó solo 2 de los 3 (press de banca + press con mancuernas) porque el tercero (elevaciones de rodilla con disco, cámara en mano) se sacude tanto por el salto que la cabeza sale del cuadro en la mayor parte del clip al recortar a 3:4. Jimena pidió que se incluyeran los tres igual y que quedaran más cortos. Se encontró una ventana estable de ~1.5s al inicio del tercer clip (antes de que arranque el salto) donde la cara sí entra en cuadro, y se usó esa. Versión final: `docs/video/alumnas-entrenando.mp4`, los tres clips recortados a tramos de 4s / 4s / 1.5s con una transición corta entre cada uno, ~8.9s de loop total (antes ~14s), 3:4 vertical (720x960), sin audio. Poster en `docs/img/alumnas-entrenando-poster.jpg`. Herramienta usada: `ffmpeg` (instalado en esta sesión vía winget, no estaba disponible antes).
- [x] Poner la foto real de Jimena en el placeholder `.foto-ph` de "Sobre mí" (13/08/2026): `docs/img/jimena-sobre-mi.jpg`, recortada con `object-fit:cover; object-position:50% 18%` para priorizar cara/hombros ya que la foto original es vertical de cuerpo entero y el contenedor es cuadrado/horizontal según el breakpoint. Se descartó una primera foto (selfie de espejo en ropa deportiva) por no encajar con la línea editorial del sitio.
- [x] **Reemplazar los tres planes por un solo programa (13/08/2026, decisión de Jimena)** — resuelve de paso el pendiente de "repensar el tercer plan" y el de precios públicos: ahora hay un precio único y visible. Ver "Programa" en Decisiones de diseño.
- [ ] Revisar si la nueva cadencia (videollamada mensual 1 a 1 del programa único) cambia el análisis de capacidad de `estrategia/business-case.md` — el business case todavía está escrito sobre la estructura de tres planes.

**Bloqueantes de captación — cerrados el 15/08/2026.** Hasta esa fecha la web no podía convertir una sola visita.

- [x] Reemplazar el número de WhatsApp de ejemplo en `docs/index.html` por el real (15/08/2026): `541135863879`, con mensaje pre-cargado, en los dos botones. Ver "Datos de contacto reales" en Decisiones de diseño.
- [x] Agregar el enlace real de Instagram (15/08/2026): `instagram.com/pf.jimenaibanez`, en el footer y como botón secundario en la caja de contacto.
- [ ] **Foto nueva de Jimena para "Sobre mí" — pedírsela a ella.** La actual es una toma casual en la vereda, sin contexto de entrenamiento, y contradice el posicionamiento profesional del resto de la página. Ningún ajuste de CSS lo arregla. Al reemplazarla hay que recalibrar `transform:scale` y `object-position` de `.foto-ph img`, que están ajustados a mano para la foto actual.
- [x] Sumar testimonios reales de alumnas a la sección "Testimonios" (13/08/2026): Silvia Rodríguez y Verónica Vázquez, con autorización confirmada por Jimena. Las citas son textuales (Silvia, transcripta tal cual, cortada donde cortaba el mensaje original — no se completó la frase; Verónica, extraída de un posteo más largo, sacando solo la mención dirigida a Jimena). Sin fotos de ellas todavía. La tercera tarjeta del grid quedó como invitación abierta ("Tu lugar está reservado acá") en vez de un tercer testimonio inventado — no inventar testimonios hasta que exista uno real.

**Decisiones abiertas de negocio:**

- [x] Definir el posicionamiento: mujeres +30 en general o especialización hormonal. **Decidido por Jimena el 12/08/2026: especialización en salud hormonal femenina** — recomposición corporal para mujeres +35 con resistencia a la insulina, SOP, hipotiroidismo, perimenopausia o menopausia. Aplicado en `docs/index.html` (title, meta description, hero, "Sobre mí", especialidades, footer), `contexto.md` y `estrategia/propuesta-de-valor.md`. Ver `estrategia/propuesta-de-valor.md`.
- [x] Corregir el footer de `docs/index.html`: decía "mujeres +40" mientras el resto del sitio decía +30. Resuelto: todo el sitio dice ahora +35, consistente con el posicionamiento decidido.
- [x] Reescribir el hero (12/08/2026, pedido directo de Jimena): eyebrow, lead y una lista de tres bullets nuevos (`.hero-bullets`) con copy más directo — "sin pasar hambre", "sin entrenar todos los días", "adaptado a tus hormonas, tu edad y tu tiempo real". Reemplaza la primera versión del lead, que a Jimena no le convenció. **Corrección importante:** un primer intento puso "30 a 60 años" (tomado literal de un ejemplo de Jimena que era solo de estilo) y afirmaba "el programa que ya ayudó a mujeres..." — Jimena aclaró que el nicho es +35 y que **todavía no tiene alumnas ni resultados propios, recién empieza**. El lead final no afirma experiencia previa ni resultados; describe el método (sin dietas restrictivas, sin entrenar todos los días, adaptado a hormonas). No inventar trayectoria ni testimonios hasta que existan de verdad.
- [x] **Confirmar el precio publicado.** Resuelto el 13/08/2026 al pasar a un solo programa: Jimena confirmó USD 35/mes como precio único y real. Ya no aplican los precios viejos de Entrenamiento/Integral/Nutrición ni los semestrales/anuales provisorios — se sacaron del sitio.
- [ ] Medir las horas reales que consume al mes una alumna del programa. Una alumna, un mes, las horas anotadas. Define si el precio único (USD 35/mes) conviene sostenerlo como está.
- [ ] **Idea de Jimena (11/08/2026): descuento del 10% para docentes.** Sin definir todavía: si es para docentes en general o solo de Educación Física, y si es permanente o de lanzamiento. (Ya no hace falta definir "a qué planes aplica" — desde el 13/08/2026 hay un solo programa.)
- [ ] **Comunidad (dirección acordada el 11/08/2026, sin implementar):** grupo de WhatsApp para alumnas activas (retención + testimonios orgánicos, aprovecha el canal que ya se usa para seguimiento 1 a 1) e Instagram como canal público de captación, no como comunidad cerrada — mezclar los dos diluye tanto el mensaje de venta como la intimidad del grupo. Requiere moderación activa de Jimena por ser temas de salud hormonal. Falta definir: cuándo se abre el grupo (¿desde el alta o a partir de cierta antigüedad?) y quién modera si el grupo crece. **Atención:** desde el 13/08/2026 "Comunidad de mujeres" ya se promociona como feature 06 del programa en `docs/index.html`, pero operativamente sigue sin implementarse — hay que resolver esto antes de que alguien se anote esperando algo que todavía no existe.

**Ideas del benchmark de sitios** (ver `product-discovery/02-benchmark-sitios/`, ninguna decidida todavía):

- [ ] Ponerle nombre al método de Jimena. Hoy la metodología está documentada y no tiene nombre; la referencia principal llama a la suya "Método Reset". Un método con nombre sostiene precio.
- [ ] Reemplazar el CTA "Escribime por WhatsApp" por una sesión de valoración gratuita por videollamada.
- [ ] Reordenar la web para arrancar por el problema de la clienta y no por la oferta.
- [ ] Sumar una sección de descalificación: "esto no es para vos si...".
- [ ] Capturar emails con una guía descargable de perimenopausia.
- [ ] Mostrar las planillas de `herramientas/` como argumento de venta en la web.

**Ideas del benchmark world class** (14/08/2026, ver `product-discovery/03-benchmark-world-class/`, ninguna decidida todavía). Se relevaron 18 sitios nuevos de primer nivel, dentro y fuera del entrenamiento, para responder qué techo existe. Ordenadas por relación entre impacto y esfuerzo:

- [ ] **Sumar un número con plazo en la parte alta de la página.** Ninguna de las mejores páginas dice "resultados reales": todas dicen una cifra, una unidad y una ventana de tiempo (Alloy: 95% de alivio en 2 semanas; Eight Sleep: hasta 44%; Wild.AI: 6× de riesgo de lesión). Jimena no tiene ninguno y todavía no tiene datos propios de alumnas, así que el camino honesto es el dato fisiológico publicado y citado como tal, no uno inventado. Empezar por la sarcopenia que se acelera 1-2% al año después de los 50.
- [ ] **Reemplazar el botón de WhatsApp por un quiz de tres preguntas.** Es la conversión de fricción más baja del relevamiento (Sohee, ZOE, Stronger by the Day). Baja el costo de la clienta, que hoy tiene que redactar el primer mensaje sin saber qué decir, y de paso segmenta. Encaja con el diferencial ya declarado en `contexto.md`: evaluar antes de armar el plan. Se cruza con el pendiente del 02 de la sesión de valoración — hay que elegir uno de los dos como primer paso, no poner los dos.
- [ ] **Escribir la ventaja de ser una sola persona.** En los 18 sitios, quien atiende nunca es quien está en la portada. Jimena arma el plan y responde el mensaje. Es verificable, no lo puede copiar ninguno de los 18, y hoy no está dicho en ninguna parte del sitio.
- [ ] **Definir la frase de posicionamiento propia.** Referencia del relevamiento: "La madurez no es tu declive. Es tu momento más poderoso" (Noelia Rodríguez Fit, misma clienta y también negocio de una sola persona). Jimena tiene el contenido y no tiene la frase.
- [ ] **Cambiar la guía descargable por un plan gratuito de 5 días** (ver el pendiente del 02, arriba). Ninguna de las mejores páginas regala "una guía": regalan algo con nombre, formato y plazo (Girls Gone Strong: cursos de 5 días; Stronger by the Day: 3 entrenamientos gratis sin descarga ni tarjeta). Mismo esfuerzo de producción, más valor percibido.
- [ ] **Nombrar al adversario.** ZOE se define contra "los mitos gritados por influencers no cualificados". Jimena compite contra el consejo de Instagram y contra el entrenador que da la misma rutina a todo el mundo, y decirlo ordena el resto del argumento.
- [ ] **Evaluar la certificación de coaching en menopausia de Girls Gone Strong** como credencial concreta y verificable para el posicionamiento hormonal ya decidido.

**Confirmaciones que salieron del mismo benchmark** (no requieren acción, sirven para no revisar decisiones ya tomadas):

- **El precio publicado estaba bien.** El discovery 02 había concluido que en la categoría nadie publica precios. Con 18 sitios más, ocho sí lo hacen, y el patrón real es que lo publica quien vende un producto cerrado y no lo publica quien vende horas uno a uno. El paso a un solo programa de USD 35/mes del 13/08/2026 puso a la web del lado correcto. Lo que queda abierto no es si publicar el precio, es cuál, y eso depende del pendiente de medir horas reales por alumna.
- **La cursiva del claim del hero tiene respaldo.** Oura usa el mismo recurso en sus titulares ("Get the best sleep of *your life*"): una sola palabra en cursiva marcando dónde está el sentido de la frase. Es la misma solución a la que llegó este proyecto, tomada por un equipo con otro presupuesto.
- **El método con nombre dejó de ser una idea.** El 02 lo proponía con dos ejemplos. Ahora son cinco de cinco entre quienes venden bien, y cero entre quienes no. Sigue como pendiente arriba, pero ya no está en discusión si conviene.

**Producto y operación:**

- [x] **Comprar el dominio: hecho el 19/08/2026.** Es `entrenaconjime.com`, registrado en Cloudflare por Gastón.
- [x] **Apuntar el dominio: hecho el 19/08/2026, cuatro días antes de la fecha límite.** El sitio está en vivo en **https://entrenaconjime.com**. Cómo quedó: cuatro registros `A` en el apex hacia las IPs de GitHub Pages (`185.199.108-111.153`) y un `CNAME` de `www` hacia `gaston-perez-art.github.io`, los cinco en **DNS only** (nube gris). El archivo `docs/CNAME` está versionado, así que ningún push lo borra. Las cuatro variantes de entrada (con y sin `www`, con y sin HTTPS) terminan en `https://entrenaconjime.com`, y la URL vieja de GitHub redirige sola, así que los links ya compartidos siguen funcionando. El certificado de Let's Encrypt se emitió en menos de un minuto —no las 24h previstas— y vence el 17/11/2026, con renovación automática. HTTPS forzado activado.
  - **Si algún día se prende la nube naranja de Cloudflare** (para caché o analítica de red), antes hay que pasar SSL/TLS a **Full (strict)**, o el sitio se cae con un loop de redirecciones. Mientras la nube esté gris, el modo SSL de Cloudflare no interviene.
  - **Pendiente menor, sin urgencia:** verificar la propiedad del dominio en GitHub (Settings → Pages → Verified domains, con un registro TXT en Cloudflare). No cambia nada de lo que funciona hoy; evita que, si el repo dejara de publicar, otra cuenta de GitHub pudiera reclamar el dominio.

- [x] **Analytics: Google Analytics 4, instalado el 19/08/2026.** Propiedad `G-CNR32WF83Z`, el tag va en el `<head>` de `docs/index.html`. Se eligió GA4 sobre Cloudflare Web Analytics porque esta última no mide eventos: habría dicho cuánta gente entra, nunca cuántas apretaron WhatsApp.
  - **Qué mide, además de las visitas:** los cuatro links salientes están marcados con `data-ga` y emiten dos eventos propios — `contacto_whatsapp` y `visita_instagram` — cada uno con el parámetro `ubicacion` (`hero`, `cierre` o `footer`). O sea que se puede saber **si la gente escribe apenas entra o recién después de leer todo el sitio**, que son dos historias distintas sobre qué está haciendo la página.
  - **Sin banner de cookies**, decisión tomada: el público es argentino y rige la ley 25.326, que no lo exige como sí lo hace el GDPR europeo. En un sitio de una sola página, el banner es fricción arriba del contenido. Igual quedó configurado **Consent Mode v2** con publicidad y perfilado denegados y solo la medición habilitada, más `anonymize_ip`: si alguna vez entra tráfico de España, no hay que rehacer nada.
  - **Al tocar los CTA, mantener el atributo `data-ga`.** Si se reemplaza el botón de WhatsApp por un quiz o por una sesión de valoración (dos pendientes abiertos más arriba), hay que ponerle su propio `data-ga` al elemento nuevo o se pierde la medición de conversión sin que nada se rompa a la vista.
- [ ] Sumar planillas de seguimiento de progreso (medidas, fotos, hábitos, fuerza) a `herramientas/`.
- [ ] Usar las planillas de `herramientas/` como argumento comercial en la web. Hoy son el activo de retención del proyecto y no se mencionan en ningún lado.
