/**
 * Crea el formulario "Antes de nuestra entrevista 🌱" y la planilla donde llegan
 * las respuestas, los dos en el Drive de quien lo corre.
 *
 * Uso: script.google.com → Nuevo proyecto → pegar este archivo → Ejecutar
 * `crearFormularioPreEntrevista` → aceptar los permisos. El "Registro de
 * ejecución" imprime el link para las clientas y el link para editar.
 *
 * Cada corrida crea un formulario NUEVO: no hace falta volver a correrlo para
 * editar preguntas, eso se hace desde el link de edición.
 *
 * Cómo leer las respuestas: ver `guion-presentacion.md`, sección "Antes de la
 * entrevista". Los síntomas de la pregunta 13 van mezclados a propósito, para
 * que la interesada no se autodiagnostique leyendo una lista agrupada.
 */
function crearFormularioPreEntrevista() {
  var form = FormApp.create('Antes de nuestra entrevista 🌱');
  form.setDescription(
    'Completar esto te lleva 5 minutos y me ayuda a conocerte antes de la charla, ' +
    'así la aprovechamos para hablar de vos. No hay respuestas correctas: contestá ' +
    'como te salga. Todo lo que escribas es confidencial. — Jimena'
  );
  form.setProgressBar(true);
  form.setCollectEmail(false);

  // Sección 1 · Sobre vos
  form.addTextItem().setTitle('Nombre y apellido').setRequired(true);
  form.addTextItem().setTitle('Edad').setRequired(true);
  form.addTextItem().setTitle('País y ciudad').setRequired(true);
  form.addParagraphTextItem().setTitle('¿A qué te dedicás y cómo son tus horarios?');

  // Sección 2 · Tu objetivo
  form.addPageBreakItem().setTitle('Tu objetivo');
  form.addCheckboxItem().setTitle('¿Qué te gustaría lograr?')
    .setChoiceValues(['Bajar grasa', 'Ganar músculo y firmeza', 'Tener más energía',
      'Sentirme bien con mi cuerpo', 'Mejorar mi salud', 'Aprender a comer sin hacer dieta'])
    .showOtherOption(true).setRequired(true);
  form.addParagraphTextItem()
    .setTitle('Imaginate dentro de 6 meses, con todo saliendo bien. ¿Qué cambió en tu vida?')
    .setRequired(true);
  form.addParagraphTextItem().setTitle('¿Por qué ahora? ¿Qué te hizo decidirte a escribirme?');

  // Sección 3 · Lo que ya probaste
  form.addPageBreakItem().setTitle('Lo que ya probaste');
  form.addCheckboxItem().setTitle('¿Qué probaste antes?')
    .setChoiceValues(['Dietas', 'Gimnasio por mi cuenta', 'Clases grupales', 'Nutricionista',
      'Rutinas o apps online', 'Entrenadora personal', 'Nunca probé nada']);
  form.addParagraphTextItem()
    .setTitle('¿Qué fue lo que más te costó sostener, y por qué creés que no funcionó?');

  // Sección 4 · Tu cuerpo hoy
  form.addPageBreakItem().setTitle('Tu cuerpo hoy')
    .setHelpText('Esto me sirve para orientar la charla. No es un diagnóstico.');
  form.addCheckboxItem().setTitle('¿Tenés algún diagnóstico médico?')
    .setChoiceValues(['Resistencia a la insulina', 'SOP', 'Hipotiroidismo', 'Diabetes',
      'Hipertensión', 'Ninguno', 'No sé / nunca me hice estudios'])
    .showOtherOption(true).setRequired(true);
  form.addTextItem().setTitle('¿Tomás alguna medicación o suplemento? ¿Cuál?');
  form.addMultipleChoiceItem().setTitle('¿Cómo es tu ciclo menstrual hoy?')
    .setChoiceValues(['Regular', 'Irregular desde siempre',
      'Cambió en el último año o dos (más corto, más largo o saltea meses)',
      'No menstrúo hace menos de un año', 'No menstrúo hace más de un año',
      'Uso anticonceptivos', 'Prefiero no responder'])
    .setRequired(true);
  form.addCheckboxItem().setTitle('¿Te pasa alguna de estas cosas seguido?')
    .setChoiceValues(['Calores o sofocos', 'Duermo peor o me despierto de noche',
      'Cambios de ánimo o irritabilidad', 'Me cuesta concentrarme o me olvido cosas',
      'Me da sueño o cansancio después de comer', 'Tengo antojos de dulce o harinas',
      'La grasa se me acumula en la panza', 'Tengo hambre poco después de comer',
      'Estoy cansada casi todo el día', 'Ninguna'])
    .setRequired(true);
  form.addTextItem().setTitle('¿Tenés alguna lesión o dolor?');

  // Sección 5 · Tu rutina
  form.addPageBreakItem().setTitle('Tu rutina');
  form.addMultipleChoiceItem().setTitle('¿Entrenás actualmente?')
    .setChoiceValues(['No', 'A veces', '1 o 2 veces por semana', '3 o más veces por semana'])
    .setRequired(true);
  form.addMultipleChoiceItem().setTitle('¿Cuántos días por semana podrías entrenar de verdad?')
    .setChoiceValues(['2', '3', '4 o más']).setRequired(true);
  form.addMultipleChoiceItem().setTitle('¿Dónde preferís entrenar?')
    .setChoiceValues(['En casa', 'En el gimnasio', 'Las dos']).setRequired(true);
  form.addGridItem().setTitle('Del 1 al 5, ¿cómo están hoy…?')
    .setRows(['Tu sueño', 'Tu nivel de estrés', 'Tu energía'])
    .setColumns(['1', '2', '3', '4', '5']);

  // Sección 6 · Para nuestra charla
  form.addPageBreakItem().setTitle('Para nuestra charla');
  form.addScaleItem().setTitle('Del 1 al 10, ¿qué tan lista te sentís para empezar?')
    .setBounds(1, 10).setLabels('Todavía no', '¡Ya!').setRequired(true);
  form.addMultipleChoiceItem().setTitle('¿Cuándo te gustaría arrancar?')
    .setChoiceValues(['Esta semana', 'Este mes', 'Más adelante', 'Todavía no sé'])
    .setRequired(true);
  form.addParagraphTextItem().setTitle('¿Hay algo más que quieras contarme o preguntarme?');
  form.addCheckboxItem().setTitle('Confidencialidad')
    .setChoiceValues(['Entiendo que esta información es confidencial, que la usa solo Jimena ' +
      'para preparar nuestra entrevista y que no reemplaza una consulta médica.'])
    .setRequired(true);

  form.setConfirmationMessage('¡Gracias! Ya tengo todo para nuestra entrevista. Nos vemos pronto 🌱');

  // Planilla donde llegan las respuestas
  var planilla = SpreadsheetApp.create('Respuestas · Antes de nuestra entrevista');
  form.setDestination(FormApp.DestinationType.SPREADSHEET, planilla.getId());

  // Los formularios creados por script pueden quedar sin publicar según la
  // versión de Google Forms; si el método no existe, se ignora.
  try { form.setPublished(true); } catch (e) {}

  Logger.log('Link para mandar a las clientas: ' + form.getPublishedUrl());
  Logger.log('Link para editar: ' + form.getEditUrl());
  Logger.log('Planilla de respuestas: ' + planilla.getUrl());
}
