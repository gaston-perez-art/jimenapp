#!/usr/bin/env bash
#
# Relevamiento tipográfico: detecta qué fuentes usa cada sitio de referencia.
#
# Descarga el HTML de cada sitio y extrae dos cosas: las declaraciones
# font-family del CSS embebido, y los nombres de los archivos de fuente
# (.woff2 / .otf) que el sitio descarga. El nombre del archivo suele revelar
# la familia incluso cuando el CSS está minificado o en un bundle externo.
#
# Uso:  ./relevar-fuentes.sh [carpeta-de-salida]
#
# Requiere: curl. La carpeta de salida por defecto es un temporal.
#
# Repetirlo dentro de un año sirve para ver qué rediseñó cada marca.

set -uo pipefail

OUT="${1:-$(mktemp -d)}"
mkdir -p "$OUT"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126 Safari/537.36"

# Competencia directa: entrenamiento basado en evidencia
# Categoría premium: marcas de fitness que cobran caro
# Excelencia fuera del rubro: control de calidad de oficio
SITIOS=(
  "https://rpstrength.com"
  "https://www.strongerbyscience.com"
  "https://girlsgonestrong.com"
  "https://www.barbellmedicine.com"
  "https://www.caliberstrong.com"
  "https://www.equinox.com"
  "https://www.joinladder.com"
  "https://www.future.co"
  "https://www.tonal.com"
  "https://www.onepeloton.com"
  "https://stripe.com"
  "https://linear.app"
)

for url in "${SITIOS[@]}"; do
  nombre=$(echo "$url" | sed 's|https://||; s|/.*||')
  archivo="$OUT/raw_$nombre.html"

  codigo=$(curl -sL -A "$UA" -m 25 -o "$archivo" -w "%{http_code}" "$url")

  echo "════════════════════════════════════════════════════"
  echo "  $nombre   [HTTP $codigo]"
  echo "════════════════════════════════════════════════════"

  if [ "$codigo" != "200" ]; then
    echo "  sin datos: el sitio bloqueó el acceso automatizado"
    echo
    continue
  fi

  echo "  font-family declaradas:"
  grep -oiE 'font-family:[^;"}]{0,80}' "$archivo" \
    | sed 's/  */ /g' | sort -u | head -10 | sed 's/^/    /'

  echo "  archivos de fuente descargados:"
  grep -oiE '[A-Za-z0-9_/.-]+\.(woff2|woff|otf|ttf)' "$archivo" \
    | sed 's|.*/||' | sort -u | head -10 | sed 's/^/    /'

  echo "  rutas completas (revelan familias propietarias):"
  grep -oiE '[A-Za-z0-9_/.-]{10,70}\.woff2' "$archivo" \
    | grep '/' | sort -u | head -4 | sed 's/^/    /'

  echo
done

echo "HTML crudo guardado en: $OUT"
