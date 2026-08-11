# Memoria del proyecto

Registro vivo de decisiones ya tomadas, para no repetir trabajo ni contradecir cosas definidas. Se actualiza a medida que el proyecto avanza.

## Antes de empezar a trabajar: `git pull`

**Siempre hacer `git pull` antes de tocar cualquier archivo.** Vale también para un asistente de IA que esté leyendo este archivo: si estás por editar algo de este repo, hacé el pull primero.

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

**Tipografía:**
- Display (títulos): Fraunces (serif con carácter, Google Fonts)
- Cuerpo: Work Sans
- Detalles/datos (eyebrows, labels): IBM Plex Mono — refuerza el posicionamiento "basado en evidencia"

**Elemento distintivo (signature):** gráfico de barras ascendente en el hero, mostrando una progresión real de carga en sentadilla semana a semana. Refuerza el mensaje de progreso sostenido en vez de una foto de stock genérica.

**Principio técnico importante:** todo el contenido de la página es visible por defecto en el HTML/CSS. Las animaciones (aparición al hacer scroll, barras que crecen) son una mejora progresiva que se agrega solo si el JavaScript corre correctamente, con un timeout de seguridad — así un fallo de JavaScript nunca deja la página en blanco.

## Estructura de la página web

Hero → Sobre mí → Testimonios (placeholders, a completar) → Servicios → Cómo trabajo (proceso de 4 pasos) → Contacto (WhatsApp) → Footer.

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

## Pendientes

- [ ] Reemplazar el número de WhatsApp de ejemplo en `docs/index.html` por el real.
- [ ] Agregar el enlace real de Instagram en el footer.
- [ ] Sumar testimonios reales de alumnas a la sección "Testimonios" (requiere autorización explícita de cada alumna para uso público).
- [ ] Definir si se contrata dominio/hosting propio o se usa GitHub Pages.
- [ ] Sumar planillas de seguimiento de progreso (medidas, fotos, hábitos, fuerza) a `herramientas/`.
