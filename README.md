# jimenapp

Repositorio de trabajo del proyecto profesional de Jimena Ibañez — Profesora Nacional de Educación Física y entrenadora de fuerza especializada en recomposición corporal femenina.

Colaboran en este proyecto: **Jimena Ibañez** y **Gastón**.

## Qué hay en este repositorio

| Archivo / carpeta | Qué es | Actualización |
|---|---|---|
| `CLAUDE.md` | Instrucciones para Claude Code y para cualquiera que retome el proyecto. **Lo primero que se lee** | Constante |
| `contexto.md` | Contexto de negocio: quién es Jimena, a quién apunta el proyecto, objetivos | Constante |
| `memory.md` | Decisiones tomadas, preferencias de trabajo, estado actual y pendientes | Constante |
| `docs/` | Código de la página web del negocio (HTML/CSS/JS, un solo archivo autocontenido) | Según cambios |
| `herramientas/` | Planillas Excel de uso interno con Jimena y sus alumnas (ficha de ingreso, planificador de mesociclos, calculadora nutricional) | Según cambios |
| `estrategia/` | Posicionamiento, propuesta de valor y business case. **En curso**, nada cerrado todavía | En discusión |
| `product-discovery/` | Cómo se llegó a cada decisión de producto: investigaciones, benchmarks y opciones descartadas | Por decisión |

## Herramientas internas (`herramientas/`)

Planillas Excel (`.xlsx`) de uso interno — **no** se enlazan desde la web pública:

- **`ficha-ingreso.xlsx`** — formulario de alta de una alumna nueva: datos personales, objetivo, historial de salud (incluye condiciones hormonales relevantes), historial de entrenamiento, antropometría inicial (con IMC calculado automáticamente) y consentimiento.
- **`planificador-mesociclos.xlsx`** — planificador de 6 semanas (3 acumulación / 2 intensificación / 1 descarga) con autorregulación por RPE. Incluye la tabla de referencia RPE → %1RM y calcula la carga sugerida en kg a partir del 1RM cargado y el RPE objetivo de cada semana.
- **`calculadora-nutricional.xlsx`** — calcula TMB (Mifflin-St Jeor), TDEE y reparto de macros (proteína 2 g/kg, grasas ~27.5% de las calorías, carbohidratos el resto) según objetivo (déficit/mantenimiento/superávit).

Cada `.xlsx` tiene un script `build-*.ps1` homónimo que lo genera desde cero (usa Excel vía COM automation en Windows). Sirven como fuente versionada de la estructura y las fórmulas — si hay que rehacer una planilla o corregir una fórmula, se edita el `.ps1` y se vuelve a ejecutar en PowerShell con Excel instalado, en vez de editar el `.xlsx` a mano.

## Cómo ver la página web

**Opción rápida (sin publicar nada):** abrí `docs/index.html` directo en el navegador. Es instantáneo y sirve para ir viendo cambios mientras se trabaja.

**Publicarla gratis con GitHub Pages:**
1. Andá a **Settings → Pages** en este repositorio.
2. En "Source", elegí **Deploy from a branch**.
3. Elegí la rama `main` y la carpeta `/docs`. Guardá.
4. En un par de minutos la página queda publicada.

**El sitio está en vivo en https://entrenaconjime.com** — esa es la dirección oficial y la que hay que compartir. El dominio se compró el 19/08/2026 en Cloudflare y quedó apuntado el mismo día, con HTTPS. La dirección vieja `gaston-perez-art.github.io/jimenapp/` **sigue funcionando y redirige sola**, así que cualquier link que ya se haya mandado no se rompe. El detalle de la configuración está en `memory.md`.

**El sitio mide visitas con Google Analytics 4** desde el 19/08/2026, incluidos los clics a WhatsApp y a Instagram. Si tocás alguno de los botones, mirá la nota de analytics en `memory.md` antes: hay un atributo `data-ga` que no hay que perder.

> La carpeta se llama `docs` y no `web` por una restricción de GitHub Pages: publicando desde una rama, las únicas carpetas posibles son la raíz del repo (`/`) o `/docs`. No se puede elegir una carpeta con otro nombre.

Una vez configurado, cada vez que se pushea a `main` la página publicada se actualiza sola en aproximadamente un minuto. Si no ves el cambio, probá recargar con caché limpia (Cmd+Shift+R).

## Cómo seguir trabajando este proyecto

Este repo está pensado para que cualquiera de los dos (Jimena o Gastón) pueda retomarlo con contexto completo, incluso usando un asistente de IA: `contexto.md` explica el negocio y `memory.md` explica las decisiones de diseño y contenido ya tomadas, para no repetir trabajo ni contradecir cosas ya definidas.

**Empezá siempre con `git pull`.** El flujo acordado entre los dos está al principio de `memory.md`, y la misma regla vive en `CLAUDE.md`, que Claude Code carga solo cada vez que se abre el repositorio.

## Puesta al día — sesión del 11 y 12 de agosto de 2026

Si volvés después de unos días, esto es lo que cambió. El detalle de cada decisión está en `memory.md`.

> **Esta sección es una foto del 11-12/08/2026 y quedó vieja en varias cosas — se deja fechada, no se reescribe.** Lo que cambió desde entonces: los tres planes con toggle de duración **ya no existen** (13/08, un solo programa), los precios provisorios de USD 20 / 32 tampoco, el WhatsApp y el Instagram reales están publicados desde el 15/08, y la foto de "Sobre mí" dejó de ser placeholder. **El precio vigente desde el 27/08/2026 es USD 45/mes en Argentina y USD 90/mes internacional**, etapa fundadoras — ver `contexto.md` para el estado actual y `estrategia/estrategia-de-precios-metodo-raiz.docx` para la estrategia completa.

**El sitio**

• **Tipografía nueva: Archivo** en lugar de Fraunces y Work Sans. Salió de relevar 12 sitios de referencia: 11 usan grotesca sans en los títulos. Ver `product-discovery/01-tipografia/`.
• **Todo redondeado y más suave**, con una escala de radios y sombras muy bajas. Antes las esquinas eran casi rectas.
• **El claim del hero se anima**: "Más" queda fijo y la palabra rota entre fuerte, segura y vos, en cursiva y con un rodillo vertical.
• **Sección nueva de Planes** con las tres modalidades y un toggle de duración (mensual, semestral, anual) que cambia los precios sin recargar.
• **"Cómo trabajo" ahora tiene un panel fijo** que va cambiando mientras scrolleás, al estilo de Equinox.
• **El orden de la página cambió**: el método va antes que el precio.
• **Sobre mí se rehizo**: foto a la izquierda, texto a la derecha, y las especialidades como una banda al pie.
• **Pasada completa de mobile**, verificada desde 360px de ancho.

**Documentos nuevos**

• `estrategia/` — propuesta de valor y business case con el modelo económico.
• `product-discovery/` — cómo se llegó a cada decisión, con los benchmarks de tipografía y de sitios de referencia.

**Lo que necesita tu revisión**

1. **Los precios están publicados y algunos son provisorios.** Entrenamiento (USD 20) e Integral (USD 32) mensuales son reales. El de Nutrición y todos los semestrales y anuales los estimó Claude para poder maquetar.
2. **La foto de Sobre mí es un placeholder.** Hace falta una foto tuya.
3. **El WhatsApp de la web sigue siendo un número de ejemplo**, así que hoy nadie puede contactarte. Es lo más urgente.
4. **Falta el enlace de Instagram** y los testimonios reales.

## Privacidad

Este repositorio es **público**.

**No se suben datos personales de alumnas**: nombres completos, condiciones de salud, mediciones ni datos de contacto. Los ejemplos de trabajo con alumnas que aparecen en `contexto.md` están descritos en términos generales, sin identificar a nadie. Esta regla no se toca, porque son datos de terceros y no nos corresponde publicarlos.

**La información de negocio sí va en el repo**, por decisión de Gastón del 11/08/2026: precios, análisis de rentabilidad y proyecciones viven en `estrategia/business-case.md`. Tener todo en un solo lugar compartido vale más que mantenerlo reservado. Vale tener presente que el historial de Git conserva todo lo que se sube, incluso si después se borra el archivo.
