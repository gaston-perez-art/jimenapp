# Jimena Ibañez / entrenaconjime.com — Design System

> Documenta lo que **ya está decidido y en producción** en `docs/index.html`, leído directo del CSS
> (no de `memory.md`, que en algún punto queda desactualizado — ver nota de tipografía abajo).
> **Última actualización:** 23/08/2026

## Movimiento

**Dos curvas de easing, y la diferencia es deliberada** (21/08/2026). Hasta esa fecha el sitio usaba una sola, `cubic-bezier(.16,1,.3,1)`, que es una exponencial: arranca disparada y frena en seco. Ese frenazo hacía que las entradas se sintieran como un golpe.

| Uso | Curva | Por qué |
|---|---|---|
| **Entradas** (hero, reveal, stagger) | `cubic-bezier(.25,.46,.45,.94)` | Desacelera de a poco. El elemento se posa en vez de caer |
| **Interacciones** (hover, botones, foco) | `cubic-bezier(.16,1,.3,1)` | Una interacción tiene que responder rápido |

**Duraciones de entrada:** hero `1.35s`–`1.6s` con recorrido de 14px; reveal general `1.5s` con recorrido de 34px; stagger de hijos `1.25s` con escalón de `.16s`.

**Todo lo que rote o escale declara su propio `transform-origin`** (23/08/2026). En SVG el valor
inicial de `transform-origin` es `0 0`, no `50% 50%`, así que con `transform-box:fill-box` el origen
cae en la esquina superior izquierda de la caja del elemento. `.pvRing` rotaba -90° alrededor de esa
esquina y el aro terminaba un diámetro entero más arriba. Vale para las cuatro ilustraciones de
`.pin-viz`: el origen **no** se declara en el selector genérico —le gana en especificidad a las
clases que sí necesitan un origen distinto, que fue el bug de las barras del 22/08— sino en cada
clase que transforma.

**Ritmo de fondos del recorrido:** blanco → dim → blanco → dim → **oscuro** → dim → blanco → **footer dim**. La única sección oscura es "Cómo trabajo", y el footer se mantiene claro para no disputárselo: la caja de contacto que va justo arriba ya es el último momento fuerte de color (gradiente vino→bronce).

## Páginas legales

Tres páginas planas —`/aviso-legal/`, `/politica-de-privacidad/`, `/cookies/`— que **comparten `docs/legal.css`** en vez de llevar el CSS inline como el index. El criterio: inline es correcto para *una* página, donde un archivo aparte solo agrega un round-trip; con tres páginas iguales, inline garantiza que en la próxima pasada de paleta terminen diciendo cosas distintas. Los tokens de `legal.css` son un subconjunto de los del index — **si cambia la paleta, cambian los dos lados**.

Su lenguaje propio, que el sitio no tenía: columna de texto a `68ch` (arriba de eso el ojo pierde el renglón al volver), header reducido a logo + "Volver al sitio" sin menú, caja `.aviso` con filo vino a la izquierda para lo que no puede pasar desapercibido, y la tabla de cookies apilada como tarjetas por debajo de 560px.

## Logo

**Existe desde el 23/08/2026.** El sistema tiene **tres piezas**, y la que se usa depende del
tamaño, no del gusto.

| Pieza | Archivo | Dónde | Desde/hasta |
|---|---|---|---|
| **Marca sólida** — raíz blanca sobre disco vino | `marca-96/192/512.png`, `favicon-16/32/48.png`, `apple-touch-icon.png` | Favicon, header del sitio y de las legales, foto de perfil | **Todo lo menor a 120px** |
| **Isotipo** — raíz vino dentro de aro bronce | `isotipo-512.png` | og:image, manual, presentaciones, impresos | **120px para arriba** |
| **Firma con silueta** — la raíz sale de la columna | `silueta.png` | Solo el footer del sitio | 268px de ancho |

Todo vive en `docs/img/marca/`. Los masters de 1024px están en `materiales/marca/`, fuera de
`docs/` para que GitHub Pages no los sirva. El registro visual de las piezas es
**`docs/logo-preview.html`** — página de trabajo, con `noindex` y sin link desde ningún lado.

**Por qué dos marcas y no una.** El isotipo de aro es el dibujo lindo, pero a tamaño chico
desaparece: se midió reduciéndolo a 16px reales y queda una mancha rosa indistinguible; a 30px
—el tamaño del header— todavía se lee lavado. El aro bronce y las raíces finas se promedian
contra el fondo blanco. La marca sólida invierte el problema: disco vino relleno, raíz blanca,
tres pares de raíces gruesas en vez de doce finas. A 30px se lee perfecto y a 16px queda un punto
vino con el tronco adentro, que es lo que un favicon puede dar.

**Correcciones aplicadas a los archivos originales** (son PNG salidos de un modelo de imagen):

- **El aro del isotipo no cerraba.** En el arco inferior se aplanaba en una recta y perdía
  opacidad. Se redibujó como círculo real. El resto del aro tenía grosor parejo — medido ángulo
  por ángulo contra el original, el defecto era solo abajo.
- **El tronco quedaba corto.** Terminaba en corte plano a unos píxeles del aro, sin tocarlo, y se
  leía como un error. Ahora lo cruza y remata arriba.
- **El vino no era el del sitio.** El isotipo traía `#631A2A` y la marca sólida `#671A31`. Los dos
  se llevaron a `--wine-900` (`#5C1F32`). El bronce ya coincidía (`#AF824C` contra `#A9824A`,
  imperceptible) y no se tocó.

**Pendiente: vectorizar.** Son PNG corregidos a mano. Un SVG no vuelve a tener el problema del aro
en ningún tamaño, se ve nítido en retina y pesa una fracción. Es el próximo paso, no un bloqueante.

**Arquitectura de marca: arriba la persona, abajo el método.** El header lleva la marca sólida +
"Jimena Ibañez" en Archivo; el footer lleva la firma con silueta, que trae "Método Raíz" adentro.
Jimena es quien vende, Método Raíz es lo que vende. Por eso **el logotipo serif del lockup no entra
al sitio**: vive en el og:image, el manual y los impresos, donde tiene lugar para respirar. La
decisión del 11/08 sobre tipografía (grotesca sans, ver abajo) sigue en pie donde importaba, que es
la lectura de la página.

## Header

**Dos estados, y el alto no cambia nunca** (23/08/2026).

| Estado | Cuándo | Qué se ve |
|---|---|---|
| **Banda** | Arriba de todo | Vidrio esmerilado de borde a borde, `rgba(255,255,255,.93)` + `blur(20px)`, borde inferior |
| **Flotante** | Apenas se scrollea | La banda se disuelve y `nav.wrap` queda como tarjeta: 26px de los costados, 6px del techo, `--r-lg`, `--shadow-sm` |

Solo de **721px para arriba**. En mobile no cambia nada: abajo de ese ancho manda la hamburguesa y
el menú desplegable está anclado al alto del header.

**Los 67px son invariantes.** La tarjeta baja de 66 a 54px y los 6px de aire arriba y abajo reponen
la diferencia. Tres detalles que lo sostienen y que ya costaron una vez:

- **El aire va de `padding` del header, no de `margin` de la tarjeta.** Un `margin-top` del primer
  hijo colapsa hacia afuera: el header pasaba de 67px a 61px y la página daba un salto de 6px al
  cruzar el umbral.
- **El borde inferior no se saca, se vuelve transparente.** Sacarlo cambiaría el alto en 1px.
- **El blur se muda de `<header>` a la tarjeta.** Los dos no pueden tenerlo: `backdrop-filter` crea
  contexto de apilado y el de afuera anula al de adentro.

La clase la pone un **IntersectionObserver sobre un testigo de 1px** al tope del `<body>`, no un
listener de scroll: el sitio ya resuelve todo con observadores y un callback por frame no aporta.
Si el observador no existe o tira, el header queda como la banda de siempre, que es un estado
completo y válido.

La curva es la de **interacción** (`cubic-bezier(.16,1,.3,1)`), no la de entrada: responde a un
gesto de la persona y tiene que arrancar rápido. Con `prefers-reduced-motion` el estado se aplica
sin transición.

**Sobre `#proceso`, la única sección oscura**, la tarjeta flota clara sobre el fondo vino y se lee
bien. La regla de opacidad de la banda sigue valiendo para la tarjeta: **no bajar de .9**.

**La franja angosta: 721 a 860px.** La hamburguesa arranca en 720, pero el nav de escritorio a
medida real pide **~772px** —logo 171 + las cuatro listas con gaps de 36px 545 + 56 de padding—,
así que a 721 se partía en dos líneas con el CTA cortado. En esa franja el nav se aprieta: gap de
20px, links a 14px, logo a 18px y el CTA con menos padding horizontal. A 721 con esos valores el
header pide ~685px.

**No se corrige moviendo el corte de la hamburguesa:** `@media (max-width:720px)` gobierna todo el
layout mobile —la cinta, el panel fijo de "Cómo trabajo", las áreas tocables— y moverlo por un
problema del header arrastraría nueve cosas más. Y el padding vertical del CTA no se toca ahí: sigue
valiendo el mínimo tocable de 44px.

## Footer

**Cinco grupos: la marca y cuatro listas** —Programas, Otros servicios, Legal y Redes sociales—.
Las redes son columna propia desde el 23/08/2026: cuando la firma con silueta entró a la columna de
marca, esa columna pasó a ~350px de alto contra ~130px de las listas y quedaba un hueco vacío abajo
a la derecha. **El desbalance era de alto, no de ancho**, así que repartir mejor el ancho no lo
tocaba; mudar las redes baja la marca a dos elementos y suma una cuarta lista corta que ocupa el
hueco.

**Los cortes salen de medir el contenido.** El item más ancho de las cuatro listas es "Consulta
personalizada": 167px sin partir.

| Viewport | Forma | La cuenta |
|---|---|---|
| **≥1240px** | Marca al lado + 4 columnas | 282 + 4×167 + 4×40 de gap + 56 de padding = 1166px |
| **845–1239px** | Marca arriba (fila entera) + 4 columnas | 4×167 + 3×40 + 56 = 844px |
| **721–844px** | Marca arriba + listas en 2×2 | debajo de 844 las cuatro se parten |
| **≤720px** | Una sola columna | manda el bloque mobile |

A cualquier ancho de 721 para arriba las cuatro listas miden exactamente lo mismo: ningún label ni
ningún link se parte en ningún punto. El alto total va de 914px apilado a 392px en escritorio.

La firma mide **214px** en el layout de 5 columnas y **268px** cuando la marca ocupa la fila entera
o está apilada — ahí el ancho sobra y la pieza puede respirar.

**El label es "Redes sociales", no "Seguime en redes sociales":** a 170px de columna el largo se
partía en dos renglones y desalineaba los cuatro títulos.

## Paleta

**Base (neutros — blanco dominante):**

| Token | HEX | Uso |
|---|---|---|
| `--paper` | `#FFFFFF` | Fondo principal |
| `--paper-dim` | `#FAF8F6` | Fondo alterno (secciones) |
| `--card` | `#FFFFFF` | Tarjetas |
| `--line` | `#E9E4DE` | Bordes |
| `--ink` | `#241F26` | Texto principal |
| `--ink-soft` | `#5B5460` | Texto secundario |

**Nota de historia:** hasta el 18/08/2026 el fondo eran dos cremas cálidos (`#FAF6F2` / `#F1E9E1`).
Se cambió a blanco dominante a propósito — con dos cremas casi iguales el sitio se leía monocromático
y "de juguete". Referencia: Midi y Superpower (blanco-dominante + segundo neutro casi indistinguible).
El calor de la marca lo aportan el vino y el bronce, no el fondo.

**Color de marca (vino):**

| Token | HEX | Uso |
|---|---|---|
| `--wine-950` | `#3E1422` | Fondo de sección oscura (única del sitio: "Cómo trabajo") |
| `--wine-900` | `#5C1F32` | Texto de marca fuerte, footer |
| `--wine-600` | `#9D3A57` | Color de marca principal — botones, acentos, palabra que rota en el hero. Da **6.6:1** sobre blanco, así que pasa AA también como texto normal |
| `--wine-500` | `#B14A67` | Variante clara |
| `--wine-100` | `#F3E4E9` | Fondo suave |

**Acento (bronce):**

| Token | HEX | Uso |
|---|---|---|
| `--bronze` | `#A9824A` | Iconos, líneas, elementos no-texto |
| `--bronze-text` | `#8A6636` | Texto chico sobre fondo claro (4.9:1, AA) |
| `--bronze-soft` | `#EFE3CD` | Fondo suave |
| `--bronze-light` | `#DCBA84` | Acento legible sobre fondo oscuro |

**Por qué dos tonos de bronce:** `--bronze` (`#A9824A`) da 3.5:1 sobre fondo claro — insuficiente
para texto chico (mínimo AA es 4.5:1). Se usaba en labels mono de 11–13px, el peor caso. `--bronze-text`
da 4.9:1 con el mismo tono visual. `--bronze` se sigue usando para lo que no es texto.

**Botones / CTA:** gradiente `linear-gradient(135deg, var(--wine-600), var(--bronze))`, con
`background-position` animado en hover (el gradiente se desplaza, no solo oscurece). No color sólido.

## Tipografía

- **Todo el sitio (títulos y cuerpo): `Archivo`**, sans-serif grotesca ancha (Google Fonts, pesos
  400/500/600/700 + itálica 700).
- **Datos / labels / mono: `IBM Plex Mono`** (pesos 400/500) — usado en etiquetas, cifras, contadores.
- **⚠️ Corrección sobre `memory.md`:** ese archivo describe la tipografía como "Archivo (display) +
  Work Sans (cuerpo)". El `<link>` de Google Fonts que carga hoy `docs/index.html` **no incluye Work
  Sans** — solo Archivo + IBM Plex Mono. `Archivo` hace ambos roles. Esta página refleja lo que corre
  en producción; si se reintroduce Work Sans, actualizar acá.
- **Por qué no Fraunces (como Tecla):** decisión del 11/08/2026, no estética. De 12 sitios de
  referencia relevados, 11 usan grotesca sans en títulos; Fraunces empujaba la lectura hacia
  "wellness artesanal" cuando el contenido habla de periodización y RPE. Proceso completo en
  `product-discovery/01-tipografia/`.
- Letter-spacing: `-.02em` en títulos grandes (aprieta), `.02em` a `.14em` en mono/labels (abre).
- **Claim del hero (actualizado 20/08/2026):** `clamp(40px, 5.6vw, 72px)`. Bajó de un techo de 92px, que estaba dimensionado para cuando el `<h1>` cargaba solo con todo el mensaje. La palabra que rota va en cursiva y en `--wine-600`; el "Más" fijo queda recto y en `--wine-900`. El énfasis lo hace el contraste entre dos tonos del mismo vino, no un subrayado ni un tercer color.

## Radios y sombras

| Token | Valor | Uso |
|---|---|---|
| `--r-sm` | `10px` | Botones, chips, etiquetas |
| `--r-md` | `14px` | Tarjetas y cajas |
| `--r-lg` | `20px` | Superficies grandes |
| `--r-pill` | `999px` | Botones (píldora — igual que Midi/Superpower) |
| `--shadow-sm` | `0 1px 2px rgba(36,31,38,.05), 0 6px 16px -10px rgba(36,31,38,.14)` | Elevación baja |
| `--shadow-md` | `0 2px 4px rgba(36,31,38,.05), 0 16px 32px -18px rgba(36,31,38,.22)` | Hover de tarjeta |

La suavidad la aporta la sombra, no bordes gruesos ni colores más claros.

## Voz y tono de marca

De `contexto.md` y las convenciones del sitio:
- Primera persona, profesional pero cercana, sin tecnicismos innecesarios.
- Sin promesas de resultados imposibles ni dietas extremas — principio de marca, no solo de
  redacción. Ningún número de escala inventado (ej. "+100 alumnas" cuando hay dos reales):
  el reemplazo honesto para el mismo efecto es el dato fisiológico o real disponible.
- Público: mujeres +35 con cambios hormonales (resistencia a la insulina, SOP, hipotiroidismo,
  perimenopausia, menopausia) que buscan recomposición corporal realista, no una rutina genérica.

## Meta / social (estado actual)

| Campo | Valor hoy |
|---|---|
| `<title>` | "Jimena Ibañez — Recomposición corporal para mujeres +35" |
| `favicon` | `img/marca/favicon-16/32/48.png` + `apple-touch-icon.png` (180). Tres PNG con `sizes` explícito en vez de un `.ico` multi-tamaño: un binario no se puede revisar en un diff |
| `og:image` | `img/marca/og-image.jpg` — 1200×630, isotipo + logotipo sobre crema, con `og:image:width/height/alt` |
| `theme-color` | `#5C1F32` |
| Analítica | GA4 `G-CNR32WF83Z`. El atributo es `data-ga="canal_ubicacion"` y un mapa explícito traduce el canal al evento (`whatsapp`→`contacto_whatsapp`, `instagram`→`visita_instagram`, `tiktok`→`visita_tiktok`). **Un canal que no esté en el mapa no manda evento**, a propósito: antes caía por defecto en `visita_instagram` y la métrica mentía sin romperse |
| Dominio | `entrenaconjime.com` (CNAME, Cloudflare DNS-only → GitHub Pages) |

## Archivos relacionados

- `memory.md` — historial completo de decisiones e iteraciones (por qué se llegó a cada cosa).
- `contexto.md` — quién es Jimena, público objetivo, objetivo del proyecto.
- `product-discovery/01-tipografia/` — benchmark que descartó Fraunces.
- `docs/logo-preview.html` — registro visual de las piezas de marca, con `noindex`.
- `materiales/marca/` — los masters de 1024px, fuera de `docs/`.
