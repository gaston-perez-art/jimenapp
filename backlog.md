# Backlog por área

> Vista del proyecto agrupada por área, no por owner ni por fecha. Los pendientes salen de `memory.md`, que sigue siendo la fuente de verdad: si algo de acá lo contradice, gana `memory.md`. Para ver quién hace qué y cuándo, la vista complementaria es `gantt.md`.
>
> Criterio de agrupación: "ajustar la web" es una tarea de producto (cambiar algo que ya existe en `docs/index.html`). Growth y Negocio son decisiones que después *se reflejan* en la web, pero no son en sí mismas un cambio de código — son la razón por la que el código va a cambiar.
>
> Última actualización: 13/08/2026.

## Producto — Web

Ajustes directos sobre `docs/index.html`, sin decisión de negocio pendiente detrás.

- [ ] 🔴 Reemplazar el número de WhatsApp de ejemplo por el real
- [ ] 🔴 Agregar el enlace real de Instagram en el footer
- [ ] 🟡 Decidir dónde va la foto real de Jimena en el hero (el espacio "signature" ya lo ocupa el video de alumnas)
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
