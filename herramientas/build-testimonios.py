#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera la cinta de testimonios de docs/index.html a partir de la lista de acá abajo.

Para qué es
-----------
La cinta se repite en varios grupos idénticos para que el loop cierre sin salto,
así que sumar UNA cita a mano significa pegar la misma tarjeta N veces y, además,
recalcular tres números que si quedan viejos rompen la sección de formas que ya
pasaron en producción:

1. `@keyframes marquee` recorre 100%/N. Si N cambia y el keyframe no, la cinta
   salta en cada vuelta.
2. `unGrupo()` en el script usa el mismo N para el arrastre. Si queda viejo, la
   cinta se arrastra a otra velocidad que el dedo.
3. La duración fija la velocidad: al agregar tarjetas el grupo se hace más ancho
   y, con la misma duración, la cinta se acelera sola.

Y la regla que se llevó una publicación con un hueco a la derecha el 18/08/2026:

    (grupos - 1) x ancho_de_grupo  >=  la pantalla más ancha donde se vea

Al correrse un grupo entero, lo que queda tiene que seguir tapando la pantalla.
Ese cálculo lo hace este script; a ojo se da por bueno en el monitor propio y
falla en uno más ancho, que es exactamente como falló la vez pasada.

Uso
---
    python3 herramientas/build-testimonios.py            # escribe docs/index.html
    python3 herramientas/build-testimonios.py --check    # no escribe, avisa si está desactualizado

Después de correrlo hay que MIRARLO en local (`python3 qa-local.py`) antes de
commitear, como cualquier otro cambio del sitio.

Cómo sumar un testimonio
------------------------
Ver `testimonios.md` en la raíz: están los campos que hay que pedir y qué hacer
con la foto. Acá solo se agrega un diccionario más a CITAS, en el orden en que
se quiere que aparezcan, y se corre el script.
"""

import argparse
import math
import os
import re
import sys

# ---------------------------------------------------------------------------
# LAS CITAS. Esta lista es la única fuente: lo que está en el HTML se pisa.
#
# Reglas de contenido, que no las hace el script:
# • El texto es TEXTUAL. Se puede cortar en el límite de una oración si no
#   entra, y corregir tipeos evidentes. No se completan frases ni se reescribe.
# • Nada de esto se publica sin autorización de la alumna, pedida por Jimena.
#   La columna `autorizacion` deja registrado cuándo la dio y qué alcanza.
# • `ini` son las iniciales que se ven mientras no está la foto (y si falla).
# ---------------------------------------------------------------------------
CITAS = [
    dict(
        nom="Daiana Gillese Urueña", edad=34, pais="Argentina", ini="DG",
        foto="daiana.jpg", autorizacion="18/08/2026, texto y foto",
        txt="A mí me encanta entrenar con vos porque siempre estás atenta a cada "
            "movimiento, ayudándome para que no me lastime. Sos muy dedicada y una "
            "excelente profesional.",
    ),
    dict(
        nom="Margarita Izurieta López", edad=49, pais="Puerto Rico", ini="MI",
        foto="margarita.jpg", autorizacion="18/08/2026, texto y foto",
        txt="Después de dos años entrenando con vos me siento mucho más fuerte y pude "
            "lograr algo que me costaba muchísimo: ser constante. Siendo mamá, entrenar "
            "desde casa me facilitó un montón.",
    ),
    dict(
        nom="Verónica Vázquez", edad=39, pais="Estados Unidos", ini="VV",
        foto="veronica.jpg", autorizacion="13/08/2026 texto, 18/08/2026 foto",
        txt="Gracias a Jimena, que cambió mi forma de entrenar y mi estilo de vida. "
            "Desde Argentina me manda videos y me exige mandarle todo para revisar que "
            "esté haciéndolo bien.",
    ),
    dict(
        nom="Lorena Mariel Agout", edad=49, pais="Argentina", ini="LA",
        foto="lorena.jpg", autorizacion="18/08/2026, texto y foto",
        txt="Mi experiencia fue muy buena y muy eficiente, vi muchos resultados. Las "
            "planificaciones un 1000 y muy personalizadas. Realmente muy profesional en "
            "su trabajo.",
    ),
    # Silvia Rodríguez no va acá: es el destacado, y el destacado se edita a mano
    # en el HTML porque es un relato, no una tarjeta. Ver `testimonios.md`.
]

# Banderas disponibles en el sprite del <body>. Sumar un país es sumar un
# <symbol id="fl-xx"> ahí y una línea acá.
BANDERAS = {
    "Argentina": "fl-ar",
    "Puerto Rico": "fl-pr",
    "Estados Unidos": "fl-us",
}

# ---------------------------------------------------------------------------
# Medidas del layout. Están duplicadas del CSS a propósito: son los números que
# entran en la cuenta, y si alguien cambia el CSS sin tocar esto el script lo
# avisa mal. Al tocar `.t-mini` o `.t-grupo` hay que actualizarlas.
# ---------------------------------------------------------------------------
ANCHO_TARJETA = 420   # el tope del clamp(290px, 30vw, 420px) de .t-mini
SEPARACION = 26       # gap de .t-grupo, y su margin-right (el mismo valor)
PANTALLA_MAX = 3840   # 4K. Es la pantalla más ancha donde se da por soportado
PX_POR_SEG = 40       # velocidad objetivo, medida contra la cinta de coderhouse

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX = os.path.join(RAIZ, "docs", "index.html")
DIR_FOTOS = os.path.join(RAIZ, "docs", "img", "testimonios")

INICIO = "      <!-- BUILD:cinta — generado por herramientas/build-testimonios.py -->\n"
FIN = "      <!-- /BUILD:cinta -->"


def medidas(cantidad):
    """Ancho de grupo, cuántos grupos hacen falta y cuánto tiene que durar la vuelta."""
    # gaps entre tarjetas: (n-1) x SEPARACION. Más el margin-right del grupo:
    # otro SEPARACION. O sea n x SEPARACION, que es lo que hace que la pista
    # mida exactamente N grupos iguales y el recorrido sea un porcentaje justo.
    ancho_grupo = cantidad * (ANCHO_TARJETA + SEPARACION)
    grupos = math.ceil(PANTALLA_MAX / ancho_grupo) + 1
    grupos = max(grupos, 2)          # con un solo grupo no hay loop posible
    duracion = round(ancho_grupo / PX_POR_SEG)
    return ancho_grupo, grupos, duracion


def tarjeta(c, sangria):
    s = " " * sangria
    bandera = BANDERAS[c["pais"]]
    return (
        f'{s}<div class="t-mini">\n'
        f'{s}  <div class="cab">\n'
        f'{s}    <span class="t-av">{c["ini"]}<img src="img/testimonios/{c["foto"]}" alt="" loading="lazy" onerror="this.remove()"></span>\n'
        f'{s}    <span>\n'
        f'{s}      <span class="qn">{c["nom"]}</span>\n'
        f'{s}      <span class="edad">{c["edad"]} años</span>\n'
        f'{s}    </span>\n'
        f'{s}  </div>\n'
        f'{s}  <p>{c["txt"]}</p>\n'
        f'{s}  <div class="pie">\n'
        f'{s}    <span class="t-pais"><svg class="bandera" role="img" aria-label="{c["pais"]}"><use href="#{bandera}"/></svg>{c["pais"]}</span>\n'
        f'{s}  </div>\n'
        f'{s}</div>\n'
    )


def bloque_cinta(grupos):
    partes = [INICIO]
    partes.append(
        f'      <!-- {len(CITAS)} citas repetidas en {grupos} grupos idénticos. Los grupos 2 en\n'
        f'           adelante existen SOLO para que el loop cierre sin salto, así que van\n'
        f'           aria-hidden: un lector de pantalla las lee una sola vez.\n'
        f'           NO editar a mano: correr herramientas/build-testimonios.py. -->\n'
    )
    partes.append('      <div class="t-mas">\n       <div class="t-cinta" id="tCinta">\n')
    for g in range(grupos):
        attr = "" if g == 0 else ' aria-hidden="true"'
        partes.append(f'        <div class="t-grupo"{attr}>\n')
        for c in CITAS:
            partes.append(tarjeta(c, 10))
        partes.append('        </div>\n')
    partes.append('       </div>\n      </div>\n')
    partes.append(FIN)
    return "".join(partes)


def reemplazar_uno(html, patron, nuevo, que):
    """Reemplaza y falla fuerte si no hay exactamente una coincidencia.

    Si el HTML cambió de forma y el patrón dejó de matchear, es preferible que
    el script se corte a que escriba un archivo a medias y quede una cinta que
    salta en cada vuelta sin que nadie sepa por qué.
    """
    html, n = re.subn(patron, nuevo, html, count=1)
    if n != 1:
        sys.exit(f"ERROR: no encontré {que} en docs/index.html. "
                 f"¿Cambió el HTML? Revisar el patrón: {patron}")
    return html


def construir(html):
    cantidad = len(CITAS)
    if cantidad < 2:
        sys.exit("ERROR: hacen falta al menos 2 citas para que la cinta tenga sentido.")

    ancho_grupo, grupos, duracion = medidas(cantidad)

    ini = html.index(INICIO)
    fin = html.index(FIN) + len(FIN)
    html = html[:ini] + bloque_cinta(grupos) + html[fin:]

    html = reemplazar_uno(
        html, r"animation:marquee \d+s linear infinite;",
        f"animation:marquee {duracion}s linear infinite;", "la duración de la cinta")
    html = reemplazar_uno(
        html, r"translateX\(calc\(-100% / \d+\)\)",
        f"translateX(calc(-100% / {grupos}))", "el recorrido del @keyframes marquee")
    html = reemplazar_uno(
        html, r"cinta\.getBoundingClientRect\(\)\.width / \d+",
        f"cinta.getBoundingClientRect().width / {grupos}", "el divisor de unGrupo() en el script")

    return html, ancho_grupo, grupos, duracion


def avisos(ancho_grupo, grupos, duracion):
    print(f"  {len(CITAS)} citas · grupo de {ancho_grupo}px · {grupos} grupos · {duracion}s por vuelta")
    print(f"  velocidad: {ancho_grupo / duracion:.1f} px/s (objetivo {PX_POR_SEG})")
    cubre = (grupos - 1) * ancho_grupo
    print(f"  regla del hueco: {grupos - 1} x {ancho_grupo} = {cubre}px cubre {PANTALLA_MAX}px "
          f"({'ok' if cubre >= PANTALLA_MAX else 'NO ALCANZA'})")

    faltan = [c["foto"] for c in CITAS if not os.path.exists(os.path.join(DIR_FOTOS, c["foto"]))]
    if faltan:
        print(f"  ojo: faltan fotos en docs/img/testimonios/ → {', '.join(faltan)}")
        print("       (no rompe nada: esas tarjetas muestran las iniciales)")
    sin_aut = [c["nom"] for c in CITAS if not c.get("autorizacion")]
    if sin_aut:
        print(f"  OJO: sin autorización registrada → {', '.join(sin_aut)}. No publicar.")


def main():
    ap = argparse.ArgumentParser(description="Genera la cinta de testimonios en docs/index.html")
    ap.add_argument("--check", action="store_true",
                    help="no escribe: avisa si el HTML no coincide con las citas de este archivo")
    args = ap.parse_args()

    with open(INDEX, encoding="utf-8") as f:
        original = f.read()

    nuevo, ancho_grupo, grupos, duracion = construir(original)

    if args.check:
        if nuevo == original:
            print("docs/index.html está al día con CITAS.")
            avisos(ancho_grupo, grupos, duracion)
            return 0
        print("docs/index.html NO coincide con CITAS. Correr el script sin --check.")
        avisos(ancho_grupo, grupos, duracion)
        return 1

    if nuevo == original:
        print("Sin cambios: docs/index.html ya estaba al día.")
    else:
        with open(INDEX, "w", encoding="utf-8") as f:
            f.write(nuevo)
        print("Escrito docs/index.html.")
    avisos(ancho_grupo, grupos, duracion)
    print("\n  Ahora mirarlo antes de commitear:  python3 qa-local.py")
    return 0


if __name__ == "__main__":
    sys.exit(main())
