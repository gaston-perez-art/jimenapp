# Gantt por owner

> Vista de planificación del proyecto. Los pendientes salen de `memory.md`, que sigue siendo la fuente de verdad: si algo de acá lo contradice, gana `memory.md`.
>
> ⚠️ **Las fechas y los owners son una propuesta de Gastón, no un acuerdo cerrado entre los dos.** `memory.md` nunca tuvo owners asignados, así que esta división está inferida por el tipo de tarea. Jimena: corregí lo que no te cierre, es para eso.
>
> Última actualización: 13/08/2026.

```mermaid
gantt
    title jimenapp — Roadmap a fin de septiembre 2026
    dateFormat YYYY-MM-DD
    axisFormat %d/%m
    todayMarker stroke-width:3px,stroke:#9D3A57

    section @jimena
    Pasar WhatsApp real e Instagram      :crit, j1, 2026-08-14, 3d
    Decidir foto real en el hero         :j2, 2026-08-16, 4d
    Reglas de la comunidad               :crit, j3, 2026-08-20, 6d
    Medir horas reales de una alumna     :j4, 2026-08-18, 14d
    Definir descuento a docentes         :j5, 2026-09-05, 4d

    section @gaston
    Publicar WhatsApp e Instagram        :crit, g1, after j1, 1d
    Actualizar business case al programa único :crit, g2, 2026-08-17, 4d
    Mision vision y proposito            :g3, 2026-09-01, 4d
    Business Model Canvas                :g4, after g3, 5d
    FODA con competencia directa         :g5, after g4, 4d
    Planillas de seguimiento             :g6, 2026-09-14, 5d
    Definir dominio y hosting            :g7, 2026-09-20, 2d
    Seccion esto no es para vos          :g8, 2026-09-16, 3d
    Reordenar la web por el problema     :g9, 2026-09-19, 5d

    section Los dos
    Ponerle nombre al metodo             :d1, 2026-09-07, 6d
    Decidir CTA sesion de valoracion     :d2, 2026-09-14, 4d
```

## Por qué este orden

1. **Primero lo que desbloquea captación.** Hoy la web no puede convertir una sola visita: el WhatsApp es un número de ejemplo y el Instagram no tiene link. Todo lo demás optimiza un embudo que está cortado.
2. **La comunidad es urgente por riesgo, no por valor.** Ya se promociona como feature 06 del programa en el sitio en vivo, y operativamente no existe. Hay que resolverlo antes de que alguien se anote esperando algo que todavía no está.
3. **El business case bloquea las decisiones de precio.** Está escrito sobre los tres planes que ya no existen, así que sus conclusiones de rentabilidad quedaron desactualizadas. Y su hallazgo central es que el techo del negocio lo fija el precio.
4. **Las horas reales tardan.** Medir una alumna durante un mes no se acelera. Conviene arrancar temprano aunque el resultado se use tarde.
5. **Misión, visión, BMC y FODA van en cadena**, y recién ahora tienen sentido: dependían del posicionamiento, que se cerró el 12/08.

## Tabla de control

| Owner | Tarea | Estado | Bloquea a |
|---|---|---|---|
| @jimena | WhatsApp real e Instagram | 🔴 Pendiente | Toda la captación |
| @jimena | Reglas de la comunidad | 🔴 Pendiente | Feature 06 ya publicada |
| @jimena | Foto real en el hero | 🟡 Pendiente | — |
| @jimena | Horas reales de una alumna | 🟡 Pendiente | Sostener USD 35/mes |
| @jimena | Descuento a docentes | 🟢 Idea sin definir | — |
| @gaston | Business case al programa único | 🔴 Pendiente | Decisiones de precio |
| @gaston | Publicar WhatsApp e Instagram | ⏸️ Bloqueada por @jimena | — |
| @gaston | Misión, visión y propósito | 🟡 Pendiente | BMC |
| @gaston | Business Model Canvas | 🟡 Pendiente | FODA |
| @gaston | FODA con competencia | 🟡 Pendiente | — |
| @gaston | Planillas de seguimiento | 🟢 Pendiente | Argumento de venta |
| @gaston | Dominio y hosting | 🟢 Pendiente | — |
| @gaston | Sección "esto no es para vos" | 🟢 Idea del benchmark | — |
| @gaston | Reordenar la web por el problema | 🟢 Idea del benchmark | — |
| Los dos | Nombre del método | 🟡 Pendiente | Sostener precio |
| Los dos | CTA de sesión de valoración | 🟢 Idea del benchmark | — |

## Cerradas en los últimos días

Posicionamiento hormonal (12/08) · Precio único USD 35/mes (13/08) · Programa único en reemplazo de los tres planes (13/08) · Hero reescrito con el copy de Jimena (12/08) · "Sobre mí" con su historia real (13/08) · Foto real de Jimena (13/08) · Video de alumnas en el hero (13/08) · Primeros testimonios reales, Silvia y Verónica (13/08).
