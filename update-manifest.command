#!/bin/bash
# Regenerates collage/manifest.js (file list + precomputed accent colors).
cd "$(dirname "$0")" || exit 1
python3 - <<'PY'
import os, json
files = sorted(f for f in os.listdir('collage')
               if f.lower().endswith(('.png','.jpg','.jpeg','.webp','.gif')))
colors = {}
try:
    from PIL import Image
    def accent(path):
        im = Image.open(path).convert('RGB').resize((32,32))
        buckets = {}
        for r,g,b in list(im.getdata()):
            k = ((r>>5)<<6)|((g>>5)<<3)|(b>>5)
            B = buckets.setdefault(k,[0,0,0,0])
            B[0]+=1; B[1]+=r; B[2]+=g; B[3]+=b
        lst = []
        for B in buckets.values():
            n=B[0]; r=B[1]/n; g=B[2]/n; b=B[3]/n
            mx=max(r,g,b); mn=min(r,g,b)
            lst.append((n,r,g,b,(mx-mn)/mx if mx else 0))
        lst.sort(key=lambda t:-t[0])
        dom = lst[0]; best, bs = None, 0
        for q in lst[1:]:
            if ((q[1]-dom[1])**2+(q[2]-dom[2])**2+(q[3]-dom[3])**2)**0.5 < 60: continue
            s = q[0]*(0.25+q[4]*1.6)
            if s > bs: bs, best = s, q
        c = best or dom
        return [round(c[1]), round(c[2]), round(c[3])]
    for f in files:
        try: colors[f] = accent('collage/'+f)
        except Exception: pass
except ImportError:
    print('Pillow not installed - colors skipped (pip3 install Pillow)')
with open('collage/manifest.js','w') as out:
    out.write('window.COLLAGE = ' + json.dumps(files, ensure_ascii=False) + ';\n')
    out.write('window.COLLAGE_COLORS = ' + json.dumps(colors) + ';\n')
print(f'{len(files)} files, {len(colors)} colors')
PY
