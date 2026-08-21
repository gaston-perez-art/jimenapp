#!/usr/bin/env python3
"""
Servidor de QA local para jimenapp.

Para qué es
-----------
Ver los cambios de `docs/` en el navegador ANTES de commitear y pushear.
Importa porque `main` es lo que está publicado: GitHub Pages sirve `main/docs`
y todo lo que se pushea está en vivo un minuto después. Sin esto, la única
forma de mirar un cambio era publicarlo.

Qué hace además de servir
-------------------------
1. Manda `Cache-Control: no-store`. Sin esto, como todo el CSS va inline en
   `index.html`, el navegador se queda con la versión vieja y uno termina
   mirando estilos de hace dos ediciones sin darse cuenta.
2. Recarga la pestaña sola cuando cambia un archivo de `docs/`. Inyecta un
   script chico en las respuestas HTML que pregunta cada segundo si algo se
   modificó. La inyección pasa solo en este servidor: el archivo en disco no
   se toca, así que nunca se puede colar en lo que se publica.
3. Responde `Range` requests (HTTP 206). Hace falta para el `<video>` del hero:
   Chrome pide media por rangos, y `SimpleHTTPRequestHandler` ignora la
   cabecera y contesta 200 con el archivo entero. El resultado era que acá el
   video se quedaba clavado en el póster, con el placeholder encima, mientras
   en producción andaba perfecto — GitHub Pages sí contesta 206. O sea que el
   QA mentía justo sobre lo único que no se puede revisar de otra forma.
   Costó una sesión entera de debugging el 20/08/2026: no lo saques.

Uso
---
    python3 qa-local.py            # http://localhost:8899
    python3 qa-local.py 9000       # otro puerto

Ctrl+C para cortar.
"""

import http.server
import os
import socketserver
import sys
import threading
import time

RAIZ = os.path.join(os.path.dirname(os.path.abspath(__file__)), "docs")
PUERTO = int(sys.argv[1]) if len(sys.argv) > 1 else 8899

# El script que se inyecta en las respuestas HTML. Pregunta por la marca de
# tiempo mas nueva de docs/ y recarga si cambió. `cache:'no-store'` es
# necesario o el propio poll queda cacheado y nunca detecta nada.
RECARGA = """
<script>
(function(){
  var actual = null;
  setInterval(function(){
    fetch('/__cambios', {cache:'no-store'})
      .then(function(r){ return r.text(); })
      .then(function(t){
        if (actual === null) { actual = t; return; }
        if (t !== actual) { location.reload(); }
      })
      .catch(function(){ /* el servidor se corto: no hacer nada */ });
  }, 1000);
})();
</script>
"""


def marca_de_tiempo():
    """La modificación más reciente de todo lo que hay en docs/."""
    ultima = 0.0
    for carpeta, _, archivos in os.walk(RAIZ):
        for a in archivos:
            try:
                m = os.path.getmtime(os.path.join(carpeta, a))
                if m > ultima:
                    ultima = m
            except OSError:
                pass
    return str(ultima)


class Handler(http.server.SimpleHTTPRequestHandler):
    # HTTP/1.1 para que la conexión se reutilice. Todas las ramas de do_GET
    # mandan Content-Length, que es lo que 1.1 exige para no cerrar el socket.
    protocol_version = "HTTP/1.1"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=RAIZ, **kwargs)

    def _servir_rango(self, ruta):
        """Responde 206 si el pedido trae Range. Devuelve True si ya respondió.

        Chrome pide el video del hero con `Range: bytes=0-`, y el handler de la
        stdlib no implementa rangos: contesta 200 con el archivo completo y sin
        `Accept-Ranges`. Con eso el elemento <video> queda en networkState 2
        (cargando) y readyState 0 (sin datos) para siempre, sin tirar error.
        """
        rango = self.headers.get("Range")
        if not rango or not rango.startswith("bytes="):
            return False

        total = os.path.getsize(ruta)
        desde_txt, _, hasta_txt = rango[len("bytes="):].partition("-")
        try:
            if desde_txt:
                desde = int(desde_txt)
                hasta = int(hasta_txt) if hasta_txt else total - 1
            else:
                # sufijo: "bytes=-500" son los ultimos 500 bytes
                desde = max(0, total - int(hasta_txt))
                hasta = total - 1
        except ValueError:
            return False

        hasta = min(hasta, total - 1)
        if desde > hasta:
            self.send_response(416)
            self.send_header("Content-Range", f"bytes */{total}")
            self.send_header("Content-Length", "0")
            self.end_headers()
            return True

        largo = hasta - desde + 1
        self.send_response(206)
        self.send_header("Content-Type", self.guess_type(ruta))
        self.send_header("Accept-Ranges", "bytes")
        self.send_header("Content-Range", f"bytes {desde}-{hasta}/{total}")
        self.send_header("Content-Length", str(largo))
        self.end_headers()
        with open(ruta, "rb") as f:
            f.seek(desde)
            restante = largo
            while restante > 0:
                bloque = f.read(min(64 * 1024, restante))
                if not bloque:
                    break
                self.wfile.write(bloque)
                restante -= len(bloque)
        return True

    def end_headers(self):
        # Sin esto se mide el CSS viejo: va todo inline en index.html.
        self.send_header("Cache-Control", "no-store, must-revalidate")
        super().end_headers()

    def do_GET(self):
        if self.path == "/__cambios":
            cuerpo = marca_de_tiempo().encode()
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Content-Length", str(len(cuerpo)))
            self.end_headers()
            self.wfile.write(cuerpo)
            return

        ruta = self.translate_path(self.path)
        if os.path.isdir(ruta):
            ruta = os.path.join(ruta, "index.html")

        if ruta.endswith(".html") and os.path.exists(ruta):
            with open(ruta, "rb") as f:
                html = f.read().decode("utf-8")
            # antes de </body> para no interferir con el script del sitio
            if "</body>" in html:
                html = html.replace("</body>", RECARGA + "</body>", 1)
            else:
                html += RECARGA
            cuerpo = html.encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(cuerpo)))
            self.end_headers()
            self.wfile.write(cuerpo)
            return

        if os.path.isfile(ruta) and self._servir_rango(ruta):
            return

        super().do_GET()

    def log_message(self, formato, *args):
        # el poll de cada segundo llenaria la consola
        if "__cambios" not in (args[0] if args else ""):
            super().log_message(formato, *args)


class Servidor(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


if __name__ == "__main__":
    with Servidor(("127.0.0.1", PUERTO), Handler) as httpd:
        print(f"QA local  →  http://localhost:{PUERTO}/index.html")
        print(f"sirviendo {RAIZ}")
        print("la pestaña se recarga sola al guardar. Ctrl+C para cortar.\n")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nlisto.")
