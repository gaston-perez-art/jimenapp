# Contexto del proyecto

> Última actualización: ver historial de commits de este archivo.

## Quién es Jimena

Jimena Ibañez es Profesora Nacional de Educación Física (Argentina), con experiencia como entrenadora personal y coach funcional. Se especializa en entrenamiento de fuerza femenino basado en evidencia científica, con foco en:

- Recomposición corporal (pérdida de grasa + ganancia de masa muscular) en mujeres +35, teniendo en cuenta los cambios hormonales propios de esa etapa
- Salud hormonal femenina aplicada al entrenamiento y la nutrición: resistencia a la insulina, SOP, hipotiroidismo, perimenopausia y menopausia
- Hábitos sostenibles, sin dietas extremas ni promesas mágicas
- Mujeres adultas con poco tiempo (mamás, profesionales) que buscan salir de métodos tradicionales que no les funcionaron

## Filosofía de trabajo

- La fuerza cambia cuerpos, cambia hábitos y mejora la calidad de vida — el objetivo nunca es solo bajar de peso.
- Sin extremos: ni en entrenamiento (evitar el sobreentrenamiento) ni en nutrición (sin demonizar alimentos, sin déficits agresivos).
- Todo programa parte de una evaluación real de la alumna, no de una plantilla genérica.
- Progresión basada en evidencia: periodización por bloques, autorregulación por esfuerzo percibido (RPE), seguimiento real de cargas y composición corporal.
- Límites claros entre lo que resuelve una entrenadora y lo que corresponde derivar a un médico o nutricionista (diagnósticos, medicación, estudios de laboratorio).

## Objetivo del proyecto

Construir la presencia profesional online de Jimena y las herramientas de trabajo que usa con sus alumnas:

1. **Página web** (`docs/index.html`) — sitio de una sola página pensado para conseguir clientas nuevas: presentación profesional, servicios, proceso de trabajo, testimonios y contacto por WhatsApp.
2. **Plantillas y sistemas de trabajo** (`herramientas/`, Excel, uso interno): ficha de ingreso para alumnas nuevas, planificador de mesociclos de entrenamiento, calculadora de necesidades calóricas y macronutrientes. Pendiente: planillas de seguimiento de progreso (medidas, fotos, hábitos, fuerza).
3. **Casos de éxito y contenido educativo**: documentación de resultados reales de alumnas (con su autorización) para portfolio profesional, y guías de referencia sobre entrenamiento y nutrición aplicados a condiciones hormonales específicas.

## Público objetivo de la página web

Mujeres +35 que atraviesan cambios hormonales — resistencia a la insulina, SOP, hipotiroidismo, perimenopausia o menopausia — y buscan recomposición corporal (pérdida de grasa + ganancia de masa muscular) teniendo en cuenta esos cambios, no una rutina genérica que los ignora. Ya probaron dietas restrictivas o métodos tradicionales sin resultados sostenidos, muchas veces porque nadie les entrenó considerando su situación hormonal. Buscan un programa realista — entrenable en casa o en el gimnasio, desde 2 sesiones semanales — no un cambio de vida de tiempo completo.

## Identidad de marca

- **Nombre / firma:** Jimena Ibañez
- **Nombre del método: "Método Raíz"** (dato de Gastón, 19/08/2026). Es el nombre del programa de recomposición corporal de Jimena, y desde el 20/08/2026 está escrito en el sitio: abre el lead del hero. Un método con nombre es lo que sostiene precio e identidad — de cinco referencias del benchmark que venden bien, las cinco tienen el suyo nombrado; las que no venden, ninguna. Todavía falta bajarlo a `estrategia/`.
- **Tono:** profesional pero cercano, en primera persona, sin tecnicismos innecesarios
- **Reglas de copy** (20/08/2026, ver `memory.md` para el detalle y el benchmark del que salieron):
  - Nada de paréntesis técnicos ni aclaraciones en la parte alta de la página.
  - **No enumerar condiciones clínicas arriba.** Listar "SOP, hipotiroidismo, perimenopausia" no confunde a quien las tiene diagnosticadas: excluye a la que no sabe que las tiene y se autodescarta leyendo la lista. Arriba se nombra lo que ella siente; el nombre clínico va abajo, con contexto y explicado la primera vez que aparece.
  - El titular del hero no es el lugar del diagnóstico.
- **Paleta y tipografía:** ver `memory.md`, sección "Decisiones de diseño", y `design-system.md`

## Estado actual

- Sitio web: versión completa y funcional, con contenido orientado a mujeres +35 con especialización en salud hormonal (posicionamiento decidido el 12/08/2026). Ya tiene el WhatsApp real, el Instagram real y dos testimonios reales con autorización (15/08/2026), así que la página puede convertir una visita. El 20/08/2026 entró la sección "¿Te suena algo de esto?" entre el hero y "Sobre mí", y se rehizo el hero con criterio de copywriting. Pendiente: foto profesional de Jimena para "Sobre mí", fotos de las alumnas para los testimonios, y reescribir "En qué me especializo".
- **Fecha de lanzamiento: 23/08/2026, con dominio propio** (decisión de Gastón del 17/08/2026). El dominio es **`entrenaconjime.com`**, comprado el 19/08/2026 en Cloudflare. El hosting sigue siendo GitHub Pages, que sirve `main/docs`. **El 19/08/2026 quedó apuntado y en vivo: https://entrenaconjime.com**, con HTTPS y certificado válido. Ver `memory.md` y `gantt.md`.
