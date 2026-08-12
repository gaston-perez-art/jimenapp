# jimenapp

Repositorio de trabajo del proyecto profesional de Jimena Ibañez — Profesora Nacional de Educación Física y entrenadora de fuerza especializada en recomposición corporal femenina.

Colaboran en este proyecto: **Jimena Ibañez** y **Gastón**.

## Qué hay en este repositorio

| Archivo / carpeta | Qué es | Actualización |
|---|---|---|
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
4. En un par de minutos la página queda en **https://gaston-perez-art.github.io/jimenapp/**

> La carpeta se llama `docs` y no `web` por una restricción de GitHub Pages: publicando desde una rama, las únicas carpetas posibles son la raíz del repo (`/`) o `/docs`. No se puede elegir una carpeta con otro nombre.

Una vez configurado, cada vez que se pushea a `main` la página publicada se actualiza sola en aproximadamente un minuto. Si no ves el cambio, probá recargar con caché limpia (Cmd+Shift+R).

## Cómo seguir trabajando este proyecto

Este repo está pensado para que cualquiera de los dos (Jimena o Gastón) pueda retomarlo con contexto completo, incluso usando un asistente de IA: `contexto.md` explica el negocio y `memory.md` explica las decisiones de diseño y contenido ya tomadas, para no repetir trabajo ni contradecir cosas ya definidas.

**Empezá siempre con `git pull`.** El flujo de trabajo acordado entre los dos está al principio de `memory.md` — leelo antes de la primera sesión.

## Privacidad

Este repositorio es **público**.

**No se suben datos personales de alumnas**: nombres completos, condiciones de salud, mediciones ni datos de contacto. Los ejemplos de trabajo con alumnas que aparecen en `contexto.md` están descritos en términos generales, sin identificar a nadie. Esta regla no se toca, porque son datos de terceros y no nos corresponde publicarlos.

**La información de negocio sí va en el repo**, por decisión de Gastón del 11/08/2026: precios, análisis de rentabilidad y proyecciones viven en `estrategia/business-case.md`. Tener todo en un solo lugar compartido vale más que mantenerlo reservado. Vale tener presente que el historial de Git conserva todo lo que se sube, incluso si después se borra el archivo.
