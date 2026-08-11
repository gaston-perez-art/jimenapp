# Memoria del proyecto

Registro vivo de decisiones ya tomadas, para no repetir trabajo ni contradecir cosas definidas. Se actualiza a medida que el proyecto avanza.

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
