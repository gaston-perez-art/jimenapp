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

**Tipografía:** decidida y aplicada el 11/08/2026.

- Display (títulos): **Archivo** (grotesca ancha, Google Fonts)
- Cuerpo: **Archivo**
- Detalles/datos (eyebrows, labels): IBM Plex Mono. Se mantiene sin cambios: refuerza el posicionamiento "basado en evidencia" y es lo que hacen Equinox y Stripe.

Reemplaza a Fraunces + Work Sans. El motivo no fue estético: de 12 sitios de referencia relevados, 11 usan grotesca sans en los títulos, y Fraunces empujaba la lectura hacia *wellness artesanal* cuando el contenido habla de periodización y RPE. El proceso completo, con el benchmark y las opciones descartadas, está en `product-discovery/01-tipografia/`.

**Radios y profundidad (decisión de Gastón, 11/08/2026):** el sitio pasó de esquinas casi rectas (`--radius: 2px`) a un sistema redondeado y más suave, en la línea de Airbnb sin exagerar. Escala de tres valores:

• `--r-sm: 10px` — botones y CTA del nav
• `--r-md: 14px` — tarjetas y cajas, y todas las superficies en mobile
• `--r-lg: 20px` — superficies grandes en desktop (gráfico de progresión, caja de contacto)
• Chips y etiquetas van en pastilla completa (`999px`)

La suavidad la aportan dos sombras muy bajas (`--shadow-sm` y `--shadow-md`), no bordes más gruesos ni colores más claros. La sombra grande aparece solo en hover de tarjeta.

**Elemento distintivo (signature):** gráfico de barras ascendente en el hero, mostrando una progresión real de carga en sentadilla semana a semana. Refuerza el mensaje de progreso sostenido en vez de una foto de stock genérica.

**Principio técnico importante:** todo el contenido de la página es visible por defecto en el HTML/CSS. Las animaciones (aparición al hacer scroll, barras que crecen) son una mejora progresiva que se agrega solo si el JavaScript corre correctamente, con un timeout de seguridad — así un fallo de JavaScript nunca deja la página en blanco.

**Animación: criterio del proyecto (decisión de Gastón, 11/08/2026).** Se anima sin timidez, la animación es parte de la identidad del sitio y no un adorno opcional. Lo que se mantiene firme, porque es correctitud y no cautela:

• Preferir CSS puro sobre JavaScript. Una animación CSS no tiene el modo de falla que tiene el JS.
• El `opacity:0` nunca va en una regla base, solo dentro de un `@keyframe` con `fill-mode: both`. Si las animaciones no corren, el contenido queda visible igual.
• Todo lo que se anima respeta `prefers-reduced-motion`.
• Si un texto rota o se reemplaza, el texto completo vive en un `.sr-only` y la parte animada va con `aria-hidden`. Sin eso se rompen el SEO y los lectores de pantalla.

**Animaciones vigentes:** claim del hero rotando (fuerte → segura → vos, CSS puro, ciclo de 8,4s), entrada escalonada del hero al cargar, `.stagger` para que los hijos de una grilla entren uno detrás de otro, reveals al hacer scroll y barras del gráfico que crecen.

**Claim del hero, detalle de diseño.** "Más" queda recto y fijo; la palabra que cambia va en **cursiva**, para separar tipográficamente lo constante de lo variable. La salida es un **rodillo vertical**: la palabra sube y se va, la siguiente entra desde abajo. Se evaluaron y descartaron el borrado letra por letra (con `steps()` corta los glifos al medio porque Archivo es proporcional, y lee "terminal" en vez de "entrenadora") y el barrido horizontal. Se eligió el rodillo porque empuja hacia arriba igual que el gráfico de progresión que está al lado.

**Mobile.** Hay un bloque dedicado en el breakpoint de 720px, con tres reglas que conviene sostener al agregar secciones nuevas:

• Nada tocable por debajo de 44px de alto. Los links del nav y del footer llevan padding propio para llegar ahí.
• Los botones van a lo ancho completo y centrados. Con el ancho natural, "Escribime por WhatsApp" se partía en dos líneas.
• Los radios bajan de `--r-lg` a `--r-md` en pantallas chicas: en 390px un radio de 20px se come demasiado la esquina.

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

## Estrategia (`estrategia/`)

- Carpeta abierta el 11/08/2026, **en curso**. Tiene `propuesta-de-valor.md` y `business-case.md`, que se leen juntos.
- La decisión que bloquea todo lo demás es el posicionamiento: mujeres +30 en general, o especialización en salud hormonal femenina. Define precio, canal y mensaje. Hasta que no se resuelva, no tiene sentido escribir misión/visión, Business Model Canvas ni FODA.
- **Decisión de Gastón del 11/08/2026: todo va en el repo público, incluido el análisis financiero.** Se evaluó separarlo en un repo privado y se descartó: tener todo en un solo lugar compartido con Jimena vale más que mantener reservados los precios. La única regla de privacidad que se mantiene firme es la de datos de alumnas, porque son datos de terceros.
- Hallazgo central del business case: el techo del negocio lo fija el precio, no la capacidad. El plan más caro es el que peor rinde por hora de trabajo.

## Pendientes

**Bloqueantes de captación** (hoy la web no puede convertir una sola visita):

- [ ] Reemplazar el número de WhatsApp de ejemplo en `docs/index.html` por el real.
- [ ] Agregar el enlace real de Instagram en el footer.
- [ ] Sumar testimonios reales de alumnas a la sección "Testimonios" (requiere autorización explícita de cada alumna para uso público).

**Decisiones abiertas de negocio:**

- [ ] Definir el posicionamiento: mujeres +30 en general o especialización hormonal. Bloquea el precio, el canal y el mensaje de toda la web. Ver `estrategia/propuesta-de-valor.md`.
- [ ] Corregir el footer de `docs/index.html`: dice "mujeres +40" y el resto del sitio dice +30. Se resuelve solo cuando se cierre el posicionamiento.
- [ ] Definir el valor de la Asesoría nutricional. Es el único de los tres servicios de la web sin precio asignado.
- [ ] Medir las horas reales que consume al mes una alumna del plan personalizado. Una alumna, un mes, las horas anotadas. Define si ese plan conviene sostenerlo como está.

**Ideas del benchmark de sitios** (ver `product-discovery/02-benchmark-sitios/`, ninguna decidida todavía):

- [ ] Ponerle nombre al método de Jimena. Hoy la metodología está documentada y no tiene nombre; la referencia principal llama a la suya "Método Reset". Un método con nombre sostiene precio.
- [ ] Reemplazar el CTA "Escribime por WhatsApp" por una sesión de valoración gratuita por videollamada.
- [ ] Reordenar la web para arrancar por el problema de la clienta y no por la oferta.
- [ ] Sumar una sección de descalificación: "esto no es para vos si...".
- [ ] Capturar emails con una guía descargable de perimenopausia.
- [ ] Mostrar las planillas de `herramientas/` como argumento de venta en la web.

**Producto y operación:**

- [ ] Definir si se contrata dominio/hosting propio o se usa GitHub Pages.
- [ ] Sumar planillas de seguimiento de progreso (medidas, fotos, hábitos, fuerza) a `herramientas/`.
- [ ] Usar las planillas de `herramientas/` como argumento comercial en la web. Hoy son el activo de retención del proyecto y no se mencionan en ningún lado.
