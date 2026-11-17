from PIL import Image, ImageDraw, ImageFont, ImageFilter

W, H = 1080, 1920
FONT = 'fonts/gf/ofl/archivo/Archivo[wdth,wght].ttf'
EMOJI = '/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf'
# Correr desde la raíz del repo. Necesita la fuente Archivo (google/fonts, ofl/archivo) en FONT.

WINE950 = (0x3E, 0x14, 0x22)
WINE900 = (0x5C, 0x1F, 0x32)
WINE600 = (0x9D, 0x3A, 0x57)
BRONZE_L = (0xDC, 0xBA, 0x84)
WHITE = (255, 255, 255)
SOFT = (0xF3, 0xE4, 0xE9)


def font(size, weight):
    f = ImageFont.truetype(FONT, size)
    f.set_variation_by_axes([weight, 100])
    return f


def emoji_img(ch, size):
    f = ImageFont.truetype(EMOJI, 109)
    im = Image.new('RGBA', (160, 160), (0, 0, 0, 0))
    ImageDraw.Draw(im).text((8, 8), ch, font=f, embedded_color=True)
    im = im.crop(im.getbbox())
    r = size / im.height
    return im.resize((round(im.width * r), size), Image.LANCZOS)


# Fondo: degradé vino con un halo suave arriba a la derecha
bg = Image.new('RGB', (W, H), WINE950)
px = bg.load()
for y in range(H):
    t = y / H
    c = tuple(round(WINE900[i] * (1 - t) + WINE950[i] * t) for i in range(3))
    for x in range(W):
        px[x, y] = c
glow = Image.new('L', (W, H), 0)
ImageDraw.Draw(glow).ellipse((520, -260, 1400, 620), fill=150)
glow = glow.filter(ImageFilter.GaussianBlur(160))
bg = Image.composite(Image.new('RGB', (W, H), WINE600), bg, glow)
img = bg.convert('RGBA')
d = ImageDraw.Draw(img)

X = 96
y = 270

# Titular
f_small = font(54, 500)
f_big = font(88, 800)
d.text((X, y), 'Y a veces, buscar', font=f_small, fill=SOFT)
y += 74
d.text((X, y), 'esa actitud es', font=f_small, fill=SOFT)
y += 104
d.text((X, y), 'hacer algo', font=f_big, fill=WHITE)
y += 104
d.text((X, y), 'lindo por vos', font=f_big, fill=BRONZE_L)
w = d.textlength('lindo por vos', font=f_big)
img.alpha_composite(emoji_img('💗', 74), (X + int(w) + 20, y + 10))
y += 160

# Filete bronce
d.line((X, y, X + 120, y), fill=BRONZE_L, width=5)
y += 80

# Lista
items = [
    ('💪🏼', 'Mover el cuerpo,', 'aunque sean 20 min'),
    ('☕', 'Un café tranquila', None),
    ('🥗', 'Comer rico y', 'nutrirte bien'),
    ('💗', 'Ponerte primera', 'un ratito'),
]
f_item = font(58, 500)
for e, l1, l2 in items:
    img.alpha_composite(emoji_img(e, 62), (X, y + 2))
    d.text((X + 100, y), l1, font=f_item, fill=WHITE)
    y += 74
    if l2:
        d.text((X + 100, y), l2, font=f_item, fill=WHITE)
        y += 74
    y += 34

y += 30
# Cierre
f_close = font(54, 700)
d.text((X, y), 'No hace falta todo.', font=f_close, fill=BRONZE_L)
y += 72
d.text((X, y), 'Con un gesto alcanza', font=f_close, fill=BRONZE_L)
w = d.textlength('Con un gesto alcanza', font=f_close)
img.alpha_composite(emoji_img('✨', 54), (X + int(w) + 16, y + 6))

# Firma
d.text((X, 1790), 'entrenaconjime.com', font=font(34, 500), fill=SOFT)

img.convert('RGB').save('materiales/historias/actitud-2026-11-17/historia-actitud-algo-lindo-por-vos.jpg', quality=93)
print('ok', y)
