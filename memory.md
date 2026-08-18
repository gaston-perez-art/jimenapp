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

**Mobile.** Hay un bloque dedicado en el breakpoint de 720px, con tres reglas que conviene sostener al agregar secciones nuevas:

• Nada tocable por debajo de 44px de alto. Los links del nav y del footer llevan padding propio para llegar ahí.
• Los botones van a lo ancho completo y centrados. Con el ancho natural, "Escribime por WhatsApp" se partía en dos líneas.
• Los radios bajan de `--r-lg` a `--r-md` en pantallas chicas: en 390px un radio de 20px se come demasiado la esquina.

**Bug arreglado (14/08/2026): el menú hamburguesa no aparecía entre 401px y 720px de ancho.** Las reglas del hamburguesa (`.navtoggle{display:block}` y el dropdown de `.navlinks`) estaban en el breakpoint de `max-width:400px` en vez del de `max-width:720px`, que es el que usa el resto del sitio para mobile. En ese rango (celulares grandes, iPhone Pro Max incluido) no había hamburguesa pero tampoco entraba el nav de escritorio: el logo y los links se pisaban. Se movieron esas reglas al breakpoint de 720px.

## Estructura de la página web

Hero → Sobre mí → Testimonios → **Cómo trabajo** → **Programa** → Contacto (WhatsApp) → Footer.

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

### Fecha de lanzamiento: 23/08/2026, con dominio propio

**Decisión de Gastón del 17/08/2026.** El sitio tiene que estar en vivo bajo un dominio propio el **23/08/2026**. Deja de ser una fecha abierta y pasa a ser el hito que ordena todo lo demás.

Dos consecuencias sobre lo que ya estaba escrito acá:

• **El dominio deja de ser una idea 🟢 de septiembre.** En `backlog.md` estaba en Operaciones como "definir si se contrata dominio/hosting propio o se sigue con GitHub Pages", sin fecha, y en el gantt figuraba recién el 20/09. Está decidido: dominio propio, y hay que comprarlo y apuntarlo. GitHub Pages puede seguir siendo el hosting — un dominio propio no obliga a cambiar de hosting, se apunta con un CNAME.
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
- [ ] Testimonios: sumar fotos de Silvia y Verónica y hacerlos menos genéricos. Benchmark pasado por Jimena: Coderhouse, reseñas de Airbnb, sariadnapascual.com. **Bloqueada: falta la autorización y el archivo de las fotos.**
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

- [ ] 🔴 **Comprar el dominio y apuntarlo, antes del 23/08/2026.** Ya no es "definir si se contrata": está decidido que va con dominio propio (17/08/2026). Falta elegir el nombre, comprarlo y configurar el `CNAME` en `docs/` más los registros DNS. El hosting puede seguir siendo GitHub Pages. Ojo con dos cosas: el certificado HTTPS de Pages tarda hasta 24h en emitirse después de apuntar el DNS — no dejarlo para el 22 — y el archivo `CNAME` tiene que estar versionado dentro de `docs/`, si no cada push lo borra.
- [ ] Sumar planillas de seguimiento de progreso (medidas, fotos, hábitos, fuerza) a `herramientas/`.
- [ ] Usar las planillas de `herramientas/` como argumento comercial en la web. Hoy son el activo de retención del proyecto y no se mencionan en ningún lado.
