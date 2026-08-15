# Backlog por área

> Vista del proyecto agrupada por área, no por owner ni por fecha. Los pendientes salen de `memory.md`, que sigue siendo la fuente de verdad: si algo de acá lo contradice, gana `memory.md`. Para ver quién hace qué y cuándo, la vista complementaria es `gantt.md`.
>
> Criterio de agrupación: "ajustar la web" es una tarea de producto (cambiar algo que ya existe en `docs/index.html`). Growth y Negocio son decisiones que después *se reflejan* en la web, pero no son en sí mismas un cambio de código — son la razón por la que el código va a cambiar.
>
> Última actualización: 14/08/2026.

## Producto — Web

Ajustes directos sobre `docs/index.html`, sin decisión de negocio pendiente detrás.

- [ ] 🔴 Reemplazar el número de WhatsApp de ejemplo por el real
- [ ] 🔴 Agregar el enlace real de Instagram en el footer
- [x] Sacar los eyebrows ("Mujeres +35", "Sobre mí", "Testimonios", "Cómo trabajo", "Programa") que no aportaban valor — pedido de Jimena (14/08/2026). Se limpió también el CSS asociado (`.eyebrow`, animación de entrada del hero, override mobile) que quedó sin uso.
- [x] **Bug: botón "Quiero mi cambio" del hero.** Funcionaba (scrolleaba a la sección de contacto), pero eso era un paso de más para convertir — ahora abre WhatsApp directo, igual que el botón de la sección de contacto (14/08/2026, decisión de Gastón).
- [x] **Bug: ícono de WhatsApp roto en el botón de "Escribime y arrancamos".** El `path` del SVG estaba cortado a la mitad, faltaba el detalle del teléfono adentro de la burbuja. Se corrigió copiando el `path` completo que ya se usaba en el botón del hero (14/08/2026).
- [x] **Bug encontrado sin estar pedido: el menú hamburguesa de mobile no aparecía entre 401px y 720px de ancho** (celulares grandes, iPhone Pro Max incluido) — el nav de escritorio se pisaba con el logo en ese rango. El breakpoint del hamburguesa estaba mal alineado (max-width:400px) contra el resto de las reglas de mobile (max-width:720px). Corregido moviendo las reglas al breakpoint de 720px (14/08/2026).
- [x] **Bug de la animación del claim del hero, arreglado (14/08/2026).** La causa real no era el `clip-path` (ese margen alcanza). Era que `opacity` y `transform` cambiaban al mismo tiempo en la transición: a mitad de camino la palabra quedaba medio transparente y medio desplazada, y ese "fantasma" pisaba el texto de arriba. Se desacoplaron los tiempos dentro de `@keyframes rotWord` (paradas nuevas en 4% y 33%) para que el desplazamiento grande pase siempre en `opacity:0`. Verificado con la Web Animations API y visualmente, en varios anchos. Mismo timing global, misma duración, mismo `cubic-bezier` — no cambió la sincronización entre palabras.
- [ ] 🟡 Decidir dónde va la foto real de Jimena en el hero (el espacio "signature" ya lo ocupa el video de alumnas)
- [ ] 🟡 Hacer más armónica la sección "Sobre mí" — ajustar layout o imagen (pedido de Jimena, 14/08/2026, ver captura)
- [ ] 🟢 Nueva sección antes de "En qué me especializo" con logos animados (marquee) de las empresas de prestigio donde trabajó Jimena — **necesita que Jimena pase los logos/autorización**
- [ ] 🟡 Reescribir "En qué me especializo" — hoy es una lista de tags que no cuenta nada (pedido de Jimena, 14/08/2026)
- [ ] 🟡 Testimonios: sumar fotos de las alumnas y hacerlos menos genéricos — benchmark pasado por Jimena: Coderhouse, reseñas de Airbnb, sariadnapascual.com. **Necesita las fotos de Silvia y Verónica (autorización ya la dieron para el texto, falta para foto).**
- [~] 🟡 Sumar más animación en general y jugar más con contraste de color — Jimena sugiere empezar por el botón de WhatsApp. **En curso (15/08/2026):** botones y CTAs pasaron a gradiente wine→bronze con desplazamiento en hover, el CTA del hero suma un pulso de entrada, y la sección de contacto es el primer bloque de color fuerte del sitio (antes todo alternaba entre dos crema casi iguales). Benchmark: Coderhouse (AI Builders Program) y entrenadoranoeliarodriguezfit.com. Ver `memory.md`. **Segunda pasada (15/08/2026):** "Cómo trabajo" pasó a ser la única sección oscura del sitio (gradiente wine-950→wine-900), que era la causa de fondo del "parece de juguete" — antes todas las secciones alternaban entre dos crema casi iguales. El recorrido ahora tiene ritmo: crema → crema-dim → oscuro → crema-dim → crema con CTA oscuro. Además el recorrido de la animación de aparición pasó de 16px a 34px, que es la diferencia entre "tiene animaciones" y "se nota". Falta: la pasada de "Sobre mí" / gráficos / mobile siguen abajo en la lista.
- [x] **Bug encontrado sin estar pedido (15/08/2026): las animaciones de scroll ya programadas casi nunca se veían.** La red de seguridad del script revelaba todo el contenido a los 2 segundos de cargar la página, sin importar el scroll — cualquier persona real tarda más que eso en llegar a una sección de abajo, así que la transición ya había pasado antes de que la vieran. Subido a 8000ms y verificado que el `IntersectionObserver` real dispara en ~400ms. De paso se sumó animación en cascada a dos listas que aparecían de golpe sin ninguna transición (`esp-lista`, `programa-feats`). Ver `memory.md`.
- [ ] 🟡 Mejorar todos los gráficos del sitio (pedido de Jimena, 14/08/2026 — sin especificar cuáles; a definir con ella qué gráficos hay hoy y qué se espera)
- [ ] 🟡 Mejorar la sección de contacto "Escribime y arrancamos"
- [ ] 🔴 Pasada completa de mobile — Jimena lo pide como foco especial. Ya se corrigió el bug del hamburguesa; falta revisar el resto (animación, layout de Sobre mí, testimonios) específicamente en viewport chico
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

- [ ] 🟢 Definir si se contrata dominio/hosting propio o se sigue con GitHub Pages
- [ ] 🟢 Sumar planillas de seguimiento de progreso (medidas, fotos, hábitos, fuerza) a `herramientas/`

## Cómo leer las prioridades

🔴 bloqueante hoy · 🟡 importante, sin apuro fijo · 🟢 idea evaluada, sin decidir si entra

La única dependencia dura entre áreas: el business case (Negocio) no se puede cerrar bien hasta no tener las horas reales de una alumna (también Negocio), y el nombre del método (Growth) conviene resolverlo antes de tocar mucho más copy de la web (Producto), para no reescribir dos veces.
