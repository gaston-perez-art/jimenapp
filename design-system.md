# Jimena Ibañez / entrenaconjime.com — Design System

> Documenta lo que **ya está decidido y en producción** en `docs/index.html`, leído directo del CSS
> (no de `memory.md`, que en algún punto queda desactualizado — ver nota de tipografía abajo).
> **Última actualización:** 21/08/2026

## Movimiento

**Dos curvas de easing, y la diferencia es deliberada** (21/08/2026). Hasta esa fecha el sitio usaba una sola, `cubic-bezier(.16,1,.3,1)`, que es una exponencial: arranca disparada y frena en seco. Ese frenazo hacía que las entradas se sintieran como un golpe.

| Uso | Curva | Por qué |
|---|---|---|
| **Entradas** (hero, reveal, stagger) | `cubic-bezier(.25,.46,.45,.94)` | Desacelera de a poco. El elemento se posa en vez de caer |
| **Interacciones** (hover, botones, foco) | `cubic-bezier(.16,1,.3,1)` | Una interacción tiene que responder rápido |

**Duraciones de entrada:** hero `1.35s`–`1.6s` con recorrido de 14px; reveal general `1.5s` con recorrido de 34px; stagger de hijos `1.25s` con escalón de `.16s`.

**Ritmo de fondos del recorrido:** blanco → dim → blanco → dim → **oscuro** → dim → blanco → **footer dim**. La única sección oscura es "Cómo trabajo", y el footer se mantiene claro para no disputárselo: la caja de contacto que va justo arriba ya es el último momento fuerte de color (gradiente vino→bronce).

## Páginas legales

Tres páginas planas —`/aviso-legal/`, `/politica-de-privacidad/`, `/cookies/`— que **comparten `docs/legal.css`** en vez de llevar el CSS inline como el index. El criterio: inline es correcto para *una* página, donde un archivo aparte solo agrega un round-trip; con tres páginas iguales, inline garantiza que en la próxima pasada de paleta terminen diciendo cosas distintas. Los tokens de `legal.css` son un subconjunto de los del index — **si cambia la paleta, cambian los dos lados**.

Su lenguaje propio, que el sitio no tenía: columna de texto a `68ch` (arriba de eso el ojo pierde el renglón al volver), header reducido a logo + "Volver al sitio" sin menú, caja `.aviso` con filo vino a la izquierda para lo que no puede pasar desapercibido, y la tabla de cookies apilada como tarjetas por debajo de 560px.

## Logo

**No existe todavía.** El header es texto plano: `<a class="logo">Jimena Ibañez<span>.</span></a>`
en Archivo bold, color `--wine-900`. No hay isotipo, no hay favicon (el sitio usa el default del
navegador), no hay og-image diseñada — el `og:image` actual apunta directo a una foto
(`jimena-sobre-mi.jpg`), no a una pieza de marca.

**Pendiente:** definir un símbolo (monograma o geométrico, paleta vino/bronce) del que derivar
favicon + og-image. Ver `docs/logo-preview.html` cuando exista — mismo criterio que
`donAR/docs/proceso-logo.md`: iterar en artifact, guardar el preview final versionado en el repo.

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
| `favicon` | **no existe** — default del navegador |
| `og:image` | foto directa (`jimena-sobre-mi.jpg`), no una pieza diseñada |
| Analítica | GA4 `G-CNR32WF83Z`. El atributo es `data-ga="canal_ubicacion"` y un mapa explícito traduce el canal al evento (`whatsapp`→`contacto_whatsapp`, `instagram`→`visita_instagram`, `tiktok`→`visita_tiktok`). **Un canal que no esté en el mapa no manda evento**, a propósito: antes caía por defecto en `visita_instagram` y la métrica mentía sin romperse |
| Dominio | `entrenaconjime.com` (CNAME, Cloudflare DNS-only → GitHub Pages) |

## Archivos relacionados

- `memory.md` — historial completo de decisiones e iteraciones (por qué se llegó a cada cosa).
- `contexto.md` — quién es Jimena, público objetivo, objetivo del proyecto.
- `product-discovery/01-tipografia/` — benchmark que descartó Fraunces.
- `docs/logo-preview.html` — (pendiente de crear) registro del isotipo cuando se defina.
