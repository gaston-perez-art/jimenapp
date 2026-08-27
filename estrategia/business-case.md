# Business case

> **Estado: EN CURSO**, segunda versión al 11/08/2026. Los precios son datos reales. Las horas por plan, la permanencia y las tasas de captación son estimaciones señaladas como tales.
>
> **Desactualizado desde el 13/08/2026, y otra vez desde el 27/08/2026.** Este documento analiza la estructura vieja de tres planes (Entrenamiento USD 20, Integral USD 32, Nutrición USD 25). Jimena la reemplazó primero por un solo programa a USD 35/mes, y después por una estrategia de penetración en tres etapas con dos escalas por país — ver [`estrategia-de-precios-metodo-raiz.docx`](estrategia-de-precios-metodo-raiz.docx), que es el documento vigente, y `memory.md`.
>
> **Precio vigente (etapa fundadoras, desde el 1/09/2026): USD 45/mes en Argentina, USD 90/mes internacional.** Sube a 70/130 en diciembre y a 90-110/175 en marzo de 2027.
>
> El análisis de rendimiento por hora y los escenarios de abajo siguen siendo útiles como referencia de método, pero los números ya no describen lo que se vende. **Al rehacerlo, el hallazgo central de este documento —el techo del negocio lo fija el precio, no la capacidad— es exactamente el que la estrategia nueva toma como punto de partida**, así que conviene rehacerlo sobre las dos escalas y no volver a empezar de cero.
>
> **Qué cambió respecto de la primera versión:** el benchmark de sitios (`product-discovery/02-benchmark-sitios/`) mostró que una competidora directa publica 18 meses de permanencia promedio, contra los 4 a 6 que asumía este documento. Eso obligó a rehacer el modelo, y al rehacerlo apareció un error de planteo más grave que el número.

## El error de la primera versión

La primera versión calculaba cuánto rinde la agenda llena. La pregunta correcta es **si la agenda se llena alguna vez**.

No es lo mismo. Un negocio de acompañamiento pierde alumnas todos los meses, y crece solo mientras las altas superen a las bajas. Cuando se igualan, el negocio deja de crecer, sin importar cuánta capacidad quede sin usar.

Esa es la fórmula que gobierna todo:

```
alumnas en equilibrio = altas por mes × meses de permanencia
```

Con 2 altas por mes y una permanencia de 5 meses, el negocio se estabiliza en **10 alumnas**. No en 35. Y se queda ahí para siempre, con la agenda a un tercio, por más horas libres que haya.

## Los tres números

| Escenario | Qué supone | Ingreso anual |
|---|---|---|
| **Si nada cambia** | 2 altas/mes, 5 meses de permanencia, USD 32 | **USD 3.840** |
| **Techo del 1 a 1 bien hecho** | 4 altas/mes, 12 meses, USD 60, agenda llena | **USD 25.200** |
| **Con escalera de producto** | Lo anterior más programa grupal y ebook | **USD 31.920** |

El primero es el escenario por defecto: lo que pasa si el proyecto sigue como está. No es pesimista, es inercial.

La distancia entre el primero y el segundo no se cubre trabajando más horas. Se cubre moviendo tres variables que se multiplican entre sí.

## La tabla que importa

Alumnas en equilibrio según altas mensuales y permanencia. El asterisco marca dónde se llena la agenda.

| Altas/mes | 4 meses | 6 meses | 9 meses | 12 meses | 18 meses |
|---|---|---|---|---|---|
| 2 | 8 | 12 | 18 | 24 | 35* |
| 3 | 12 | 18 | 27 | 35* | 35* |
| 4 | 16 | 24 | 35* | 35* | 35* |
| 5 | 20 | 30 | 35* | 35* | 35* |
| 6 | 24 | 35* | 35* | 35* | 35* |

**Con 4 meses de permanencia hay que captar 6 alumnas por mes para llegar a 24.** Con 12 meses, alcanzan 3 para superar el tope. La retención no sube el techo: decide si el techo es alcanzable.

## La retención libera capacidad, no solo ingreso

Dar de alta a una alumna consume entre 3 y 4 horas: ficha de ingreso, evaluación, armado del mesociclo y del plan nutricional. Con la agenda llena en 35 alumnas, la reposición cuesta:

| Permanencia | Altas necesarias/mes | Horas solo en altas | Horas totales |
|---|---|---|---|
| 4 meses | 8,8 | 30,6 | 100,6 |
| 6 meses | 5,8 | 20,4 | 90,4 |
| 12 meses | 2,9 | 10,2 | 80,2 |
| 18 meses | 1,9 | 6,8 | 76,8 |

Pasar de 4 a 12 meses de permanencia devuelve **20 horas mensuales**, que es cerca de un tercio de la capacidad productiva. Esas horas hoy se gastan reponiendo alumnas que se fueron.

Y hay un punto de rendimientos decrecientes. Entre 12 y 18 meses el ingreso ya no sube, porque la agenda está llena en los dos casos. Lo que se gana es tiempo libre. **Pasado cierto umbral, la retención se convierte en capacidad, no en plata**, y esa capacidad recién vale algo si se usa para construir producto grupal o digital.

## Rentabilidad por hora de cada plan

Esta parte no cambió respecto de la primera versión y sigue siendo el hallazgo más contraintuitivo.

| Plan | USD/mes | Horas/mes (estimadas) | **USD por hora** |
|---|---|---|---|
| Entrenamiento | 20 | 1,0 | **20,0** |
| Integral | 32 | 2,0 | 16,0 |
| Personalizado | 100 | 7,0 o más | **14,3 o menos** |

El plan de USD 20 es el más rentable por hora. El de USD 100, el peor.

**Umbral del plan personalizado:** a USD 20 la hora, un plan de USD 100 se justifica solo si consume menos de 5 horas al mes. Si requiere 10, rinde USD 10 por hora, la mitad que el plan más barato. Sigue pendiente medirlo: una alumna, un mes, las horas anotadas.

Hay un caso donde conviene sostenerlo aunque rinda poco: si esas alumnas producen los testimonios que hoy faltan, el retorno está en la conversión de todas las demás.

## Los planes

| Plan | Precio | Qué incluye |
|---|---|---|
| Entrenamiento | USD 20/mes | Seguimiento personalizado por WhatsApp, entrevistas cada tanto. Asincrónico. |
| Integral | USD 30 a 35/mes | Entrenamiento más hábitos alimenticios: control de calorías e ingesta. |
| Personalizado | ~USD 100/mes | Alcance ampliado. Consume mucho tiempo, entrarían 1 o 2 alumnas. |
| Asesoría nutricional | **Sin definir** | Figura en la web como servicio independiente y no tiene precio. |

Ninguno de los cinco sitios del benchmark publica precios. No publicarlos es la norma de la categoría, no un error de la web.

## Romper el techo: el modelo mixto

El 1 a 1 tiene un tope duro porque consume horas. La escalera que valida el benchmark (la referencia principal vende asesorías, ebooks y una membresía) permite crecer sin tocar ese tope.

| Componente | Unidades | USD c/u | USD/mes | Horas/mes |
|---|---|---|---|---|
| 1 a 1 integral | 30 | 60 | 1.800 | 60 |
| Programa grupal, 2 grupos de 10 | 20 | 25 | 500 | 12 |
| Ebook, ventas mensuales | 20 | 18 | 360 | 0 |
| Altas 1 a 1 | | | | 9 |
| **Total** | | | **2.660** | **81** |

**USD 31.920 al año, con 81 de las 140 horas mensuales disponibles.** Quedan 59 horas libres, que es el margen para seguir creciendo.

El programa grupal es lo que quiebra la relación lineal entre horas e ingreso: diez alumnas comparten mesociclo y un encuentro semanal, así que el precio por alumna baja pero las horas por alumna caen entre cuatro y cinco veces. El ebook tiene margen cercano al 100% y cero horas marginales, y además funciona como puerta de entrada barata al 1 a 1.

## Qué habilita cobrar más

Un precio no se sube por decisión, se sube por posicionamiento. El diagnóstico está en [`propuesta-de-valor.md`](propuesta-de-valor.md) y el benchmark aportó las herramientas concretas: ponerle nombre al método, reemplazar el CTA por una sesión de valoración, sumar testimonios con edad y plazo.

De todas ellas, la más directa sobre el precio es **ponerle nombre al método**. Jimena ya tiene una metodología documentada y sin nombre. Un método con nombre convierte un servicio en producto, y un producto sostiene un precio que un servicio genérico no sostiene.

## Captación: el embudo sigue roto

Sigue siendo cierto y sigue siendo lo primero. El botón de WhatsApp de la web apunta a un número de ejemplo, no hay Instagram y los testimonios son placeholders. La conversión no es baja, es cero.

Todo este modelo empieza a correr recién cuando ese embudo funciona. Las 2 a 4 altas mensuales que necesita el escenario intermedio no salen de ningún lado si la web no puede convertir una sola visita.

## Secuencia

1. **Destrabar el embudo.** WhatsApp real, Instagram, primeros testimonios. Cuesta una tarde.
2. **Medir permanencia y horas.** Cuánto se quedan las alumnas actuales y cuánto consume el plan personalizado. Son los dos números que más mueven el modelo.
3. **Trabajar retención antes que captación.** Es más barato y libera horas. Las planillas de `herramientas/` ya son la maquinaria, falta usarlas como argumento.
4. **Decidir posicionamiento y ponerle nombre al método.** Habilita el precio.
5. **Subir el precio del integral.** De USD 32 a USD 60 duplica el ingreso sin una hora más de trabajo.
6. **Recién ahí, la escalera.** Grupal y ebook, cuando la agenda esté llena y el proceso probado.

## Datos que faltan

- [ ] **Alumnas activas hoy y antigüedad de la más antigua.** Es la única medición de permanencia obtenible sin esperar seis meses, y la permanencia es ahora la variable central del modelo.
- [ ] **Altas reales por mes de los últimos meses.** Junto con la permanencia, determina en qué número se estabiliza el negocio.
- [ ] **Horas semanales que Jimena le puede dedicar.** El tope de 35 alumnas asume dedicación completa.
- [ ] **Horas reales del plan personalizado.** El supuesto más frágil que queda.
