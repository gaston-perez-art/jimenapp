# Datos del relevamiento

Fuentes detectadas leyendo el CSS y los archivos `.woff2` servidos por cada sitio. Relevado el **11 de agosto de 2026** con [`relevar-fuentes.sh`](relevar-fuentes.sh).

## Resultados

| Sitio | Display | Texto | Licencia | Grupo |
|---|---|---|---|---|
| Equinox | Equinox Sans | Equinox Sans + Messina Sans Mono | A medida | Premium |
| Ladder | EK Modena Extended | SF Pro Display | Licenciada | Premium |
| Future | Season Mix, Season Sans | Messina Sans | Licenciada | Premium |
| Tonal | GT America | GT America | Licenciada | Premium |
| Peloton | Inter | Inter | Gratuita | Premium |
| Caliber | Benton Sans | Benton Sans | Licenciada | Competencia |
| RP Strength | Funnel Display | Figtree, Roboto Condensed | Gratuita | Competencia |
| Barbell Medicine | Barlow | Barlow | Gratuita | Competencia |
| Girls Gone Strong | Droid Serif | Assistant | Gratuita | Competencia |
| Stronger by Science | Raleway | DM Sans, Source Sans Pro | Gratuita | Competencia |
| Stripe | Söhne | Söhne + Source Code Pro | Licenciada | Excelencia |
| Linear | Inter Variable | Inter Variable | Gratuita | Excelencia |

## Conteos

| Variable | Resultado |
|---|---|
| Usan grotesca sans en títulos | **11 de 12** |
| Usan serif en títulos | 1 de 12 (Girls Gone Strong) |
| Usan fuente licenciada o a medida | 6 de 12 |
| Suman una mono para datos y etiquetas | 2 de 12 (Equinox, Stripe) |

## Evidencia cruda

Rastros concretos encontrados en el código de cada sitio, para poder verificar los datos de arriba sin volver a correr el script:

**Equinox** — archivos servidos desde `assets.cdn-equinox.com/fonts/Equinox-Sans/`, y declaraciones `@font-face` con `font-family: "Equinox Sans"` y `font-family: "Messina Sans Mono"`.

**Ladder** — `EKModenaExtended_Heavy.woff2`, `EKModenaExtended_Light.woff2`, `SFPro_Display_Bold.woff2`, `SFPro_Display_Regular.woff2`.

**Future** — `SeasonMix_Medium.woff2`, `SeasonSans_Bold.woff2`, `SeasonSans_Regular.woff2`, `MessinaSansWeb_Regular.woff2`.

**Tonal** — `font-family: GT America`.

**Peloton** — `font-family:'Inter',sans-serif`, más los woff2 de Inter servidos desde Google Fonts.

**Caliber** — `font-family: 'Benton Sans'`, `BentonSans-Regular.otf`.

**RP Strength** — `funneldisplay_n7.woff2`, `figtree_n4.woff2`, `figtree_n7.woff2`, más `font-family: 'Roboto Condensed', sans-serif`.

**Barbell Medicine** — `font-family:'Barlow', sans-serif !important`.

**Girls Gone Strong** — `font-family:'Droid Serif'`, `font-family:'Assistant'`, más `assistant-v23-latin-*.woff2` en siete pesos.

**Stronger by Science** — `font-family:'Raleway',sans-serif`, `font-family:'DM Sans',sans-serif`, `font-family:'Source Sans Pro',sans-serif`. Es el único con tres familias de texto conviviendo, señal de un sistema tipográfico sin unificar.

**Stripe** — `Sohne.cb178166.woff2`, `SourceCodePro-Medium.f5ba3e6a.woff2`.

**Linear** — `InterVariable.woff2`, más `font-family:var(--font-monospace)`.

## Sitios que no se pudieron relevar

| Sitio | Motivo |
|---|---|
| Whoop | Devuelve HTTP 403 ante acceso automatizado |
| Gymshark | Responde 200 pero no expone declaraciones de fuente inspeccionables en el HTML inicial |
