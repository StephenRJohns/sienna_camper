import os, sys
from reportlab.pdfgen import canvas as pdfcanvas
from reportlab.lib import colors
from reportlab.lib.units import inch
import math

HERE = os.path.dirname(os.path.abspath(__file__))
OUT  = os.path.join(HERE, "assets")
os.makedirs(OUT, exist_ok=True)

STEEL   = colors.HexColor('#9aa3ab'); STEEL_D = colors.HexColor('#6b737a')
PLAS    = colors.HexColor('#3a3f44');  PLAS_L  = colors.HexColor('#585e64')
RED     = colors.HexColor('#c0392b');  NAVY    = colors.HexColor('#16324f')
LBL     = colors.HexColor('#333333');  GRN     = colors.HexColor('#2c7a4b')

# =========================================================
# DIAGRAM 1 — cross-section stack
# =========================================================
W,H = 7.0*inch, 4.35*inch
c = pdfcanvas.Canvas(os.path.join(OUT,"diag_stack.pdf"), pagesize=(W,H))
cx = 2.55*inch
rod_w = 0.10*inch
LX = 1.62*inch      # left label column right edge
RX = 3.42*inch      # right label column left edge

def txt(x,y,s,size=8.0,col=LBL,font='Helvetica',anchor='l'):
    c.setFillColor(col); c.setFont(font,size)
    if anchor=='l': c.drawString(x,y,s)
    elif anchor=='r': c.drawRightString(x,y,s)
    else: c.drawCentredString(x,y,s)

def leader(x1,y1,x2,y2):
    c.setStrokeColor(RED); c.setLineWidth(0.8); c.line(x1,y1,x2,y2)
    c.setFillColor(RED); c.circle(x1,y1,1.5,stroke=0,fill=1)

c.setFillColor(NAVY); c.setFont('Helvetica-Bold',11)
c.drawCentredString(W/2, H-0.34*inch, "How the spring compressor works")
c.setFillColor(colors.HexColor('#666666')); c.setFont('Helvetica',7.6)
c.drawCentredString(W/2, H-0.49*inch, "Cross-section through the mirror fold pivot \u2014 not to scale")

rod_top = H-0.72*inch; rod_bot = 0.30*inch
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.setLineWidth(0.6)
c.rect(cx-rod_w/2, rod_bot, rod_w, rod_top-rod_bot, stroke=1, fill=1)
c.setStrokeColor(colors.HexColor('#7d858c')); c.setLineWidth(0.4)
y=rod_bot+2
while y<rod_top-2:
    c.line(cx-rod_w/2,y,cx+rod_w/2,y+2.4); y+=4.0
txt(cx+0.10*inch, rod_top-8, "threaded rod", 7.0, colors.HexColor('#777777'),'Helvetica-Oblique')

# compression nut
ny=H-1.18*inch; nh=0.19*inch; nw=0.58*inch
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.setLineWidth(0.8)
c.rect(cx-nw/2,ny,nw,nh,stroke=1,fill=1)
c.setFillColor(STEEL); c.rect(cx-rod_w/2,ny,rod_w,nh,stroke=1,fill=1)
leader(cx+nw/2, ny+nh/2, RX-6, ny+nh/2+5)
txt(RX, ny+nh/2+8, "COMPRESSION NUT  (13 mm)", 8.0, RED,'Helvetica-Bold')
txt(RX, ny+nh/2-2, "Run down to squeeze the spring.", 7.4)
txt(RX, ny+nh/2-11, "Only a few mm of travel needed.", 7.4)

# washer
wy=ny-0.10*inch; ww=0.76*inch; wh=0.07*inch
c.setFillColor(colors.HexColor('#aeb6bd')); c.setStrokeColor(STEEL_D)
c.rect(cx-ww/2,wy,ww,wh,stroke=1,fill=1)
leader(cx-ww/2, wy+wh/2, LX+6, wy+wh/2)
txt(LX, wy+wh/2-3, "Flat washer", 7.6, RED,'Helvetica-Bold','r')

# hex boss
by=wy-0.37*inch; bw=0.52*inch; bh=0.37*inch
c.setFillColor(colors.HexColor('#b9c0c6')); c.setStrokeColor(STEEL_D); c.setLineWidth(0.9)
c.rect(cx-bw/2,by,bw,bh,stroke=1,fill=1)
c.setFillColor(STEEL); c.rect(cx-rod_w/2,by,rod_w,bh,stroke=1,fill=1)
leader(cx+bw/2, by+bh/2, RX-6, by+bh/2+4)
txt(RX, by+bh/2+7, "HEX BOSS  (19 mm)", 8.0, RED,'Helvetica-Bold')
txt(RX, by+bh/2-3, "Wrench here to rotate the collar", 7.4)
txt(RX, by+bh/2-12, "a quarter turn once compressed.", 7.4)

# flange
fy=by-0.09*inch; fw=1.20*inch; fh=0.09*inch
c.setFillColor(colors.HexColor('#b9c0c6')); c.setStrokeColor(STEEL_D)
c.rect(cx-fw/2,fy,fw,fh,stroke=1,fill=1)
leader(cx-fw/2, fy+fh/2, LX+6, fy+fh/2-1)
txt(LX, fy+fh/2-4, "Flange", 7.6, RED,'Helvetica-Bold','r')

# drive lugs
ly=fy-0.15*inch; lw=0.13*inch; lh=0.15*inch
c.setFillColor(colors.HexColor('#8f979e')); c.setStrokeColor(STEEL_D)
for off in (-0.36*inch, 0.36*inch):
    c.rect(cx+off-lw/2,ly,lw,lh,stroke=1,fill=1)
leader(cx-0.36*inch, ly+lh/2, LX+6, ly+lh/2-5)
txt(LX, ly+lh/2-8, "DRIVE LUGS (4)", 7.6, RED,'Helvetica-Bold','r')
txt(LX, ly+lh/2-17, "engage slots in the collar", 7.0, LBL,'Helvetica','r')

# lock collar
cy=ly-0.28*inch; cw=1.32*inch; ch=0.28*inch
c.setFillColor(PLAS); c.setStrokeColor(colors.black); c.setLineWidth(0.8)
c.rect(cx-cw/2,cy,cw,ch,stroke=1,fill=1)
c.setFillColor(colors.HexColor('#15181a'))
for off in (-0.36*inch, 0.36*inch):
    c.rect(cx+off-lw/2, cy+ch-0.05*inch, lw, 0.05*inch, stroke=0, fill=1)
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.rect(cx-rod_w/2,cy,rod_w,ch,stroke=1,fill=1)
leader(cx+cw/2, cy+ch/2, RX-6, cy+ch/2+2)
txt(RX, cy+ch/2+5, "LOCK COLLAR", 8.0, RED,'Helvetica-Bold')
txt(RX, cy+ch/2-5, "Tabs sit in slots in the post;", 7.4)
txt(RX, cy+ch/2-14, "rotating 90\u00b0 walks them free.", 7.4)

# spring
sy_top=cy-0.03*inch; sy_bot=sy_top-0.86*inch
c.setStrokeColor(colors.HexColor('#22262a')); c.setLineWidth(3.0); c.setLineCap(1)
sr=0.36*inch; steps=170; pts=[]
for i in range(steps+1):
    t=i/steps; ang=t*4*2*math.pi
    pts.append((cx+sr*math.cos(ang), sy_top-t*(sy_top-sy_bot)))
pth=c.beginPath(); pth.moveTo(*pts[0])
for q in pts[1:]: pth.lineTo(*q)
c.drawPath(pth,stroke=1,fill=0)
leader(cx-sr, (sy_top+sy_bot)/2, LX+6, (sy_top+sy_bot)/2)
txt(LX, (sy_top+sy_bot)/2-3, "DETENT SPRING", 7.6, RED,'Helvetica-Bold','r')
txt(LX, (sy_top+sy_bot)/2-12, "the load you are fighting", 7.0, LBL,'Helvetica','r')

# pivot post
py=sy_bot-0.05*inch; pw=0.42*inch; ph=0.52*inch
c.setFillColor(PLAS_L); c.setStrokeColor(colors.black); c.setLineWidth(0.8)
c.rect(cx-pw/2,py,pw,ph,stroke=1,fill=1)
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.rect(cx-rod_w/2,py,rod_w,ph,stroke=1,fill=1)
leader(cx+pw/2, py+ph/2, RX-6, py+ph/2+2)
txt(RX, py+ph/2-1, "PIVOT POST (hollow)", 8.0, RED,'Helvetica-Bold')
txt(RX, py+ph/2-10, "rod passes down the centre", 7.4)

# base
ay=py-0.14*inch; aw=1.55*inch; ah=0.14*inch
c.setFillColor(colors.HexColor('#4a5056')); c.setStrokeColor(colors.black)
c.rect(cx-aw/2,ay,aw,ah,stroke=1,fill=1)
txt(cx+0.90*inch, ay+2, "mirror base", 7.0, colors.HexColor('#777777'),'Helvetica-Oblique')

# anchor nut
an=ay-0.30*inch; anw=0.52*inch; anh=0.16*inch
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.setLineWidth(0.8)
c.rect(cx-anw/2,an,anw,anh,stroke=1,fill=1)
leader(cx-anw/2, an+anh/2, LX+6, an+anh/2)
txt(LX, an+anh/2-3, "ANCHOR NUT", 7.6, RED,'Helvetica-Bold','r')
txt(LX, an+anh/2-12, "hold with a wrench so", 7.0, LBL,'Helvetica','r')
txt(LX, an+anh/2-21, "the rod cannot spin", 7.0, LBL,'Helvetica','r')

# force arrow
c.setStrokeColor(RED); c.setLineWidth(1.4)
ax_=cx-0.78*inch
c.line(ax_, ny+nh/2+14, ax_, ny+nh/2-20)
p2=c.beginPath(); p2.moveTo(ax_-3.2,ny+nh/2-20); p2.lineTo(ax_+3.2,ny+nh/2-20); p2.lineTo(ax_,ny+nh/2-27); p2.close()
c.setFillColor(RED); c.drawPath(p2,stroke=0,fill=1)
c.saveState(); c.translate(ax_-5, ny+nh/2-3); c.rotate(90)
c.setFillColor(RED); c.setFont('Helvetica-Bold',6.2); c.drawCentredString(0,0,"CLAMPING FORCE")
c.restoreState()
c.showPage(); c.save()

# =========================================================
# DIAGRAM 2 — parts list / build drawing for the shop-made tool
# =========================================================
W2,H2 = 7.0*inch, 3.9*inch
c = pdfcanvas.Canvas(os.path.join(OUT,"diag_build.pdf"), pagesize=(W2,H2))

c.setFillColor(NAVY); c.setFont('Helvetica-Bold',11)
c.drawCentredString(W2/2, H2-0.33*inch, "Shop-made replacement \u2014 parts and assembly order")
c.setFillColor(colors.HexColor('#666666')); c.setFont('Helvetica',7.6)
c.drawCentredString(W2/2, H2-0.48*inch, "Reuses the kit's lugged head; replaces only the screw that strips")

# ---- exploded horizontal layout ----
baseY = H2-1.42*inch
rodL = 5.0*inch
rodX0 = 1.00*inch
rw = 0.075*inch

# rod
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.setLineWidth(0.6)
c.rect(rodX0, baseY-rw/2, rodL, rw, stroke=1, fill=1)
c.setStrokeColor(colors.HexColor('#7d858c')); c.setLineWidth(0.4)
x=rodX0+3
while x<rodX0+rodL-3:
    c.line(x, baseY-rw/2, x+2.2, baseY+rw/2); x+=3.6
# carriage head
c.setFillColor(colors.HexColor('#aeb6bd')); c.setStrokeColor(STEEL_D); c.setLineWidth(0.8)
c.circle(rodX0-0.02*inch, baseY, 0.13*inch, stroke=1, fill=1)
c.rect(rodX0, baseY-0.055*inch, 0.09*inch, 0.11*inch, stroke=1, fill=1)

def calldown(x, label, sub, dy=0.62*inch):
    c.setStrokeColor(RED); c.setLineWidth(0.7)
    c.line(x, baseY-0.20*inch, x, baseY-dy)
    c.setFillColor(RED); c.circle(x, baseY-0.20*inch, 1.4, stroke=0, fill=1)
    c.setFillColor(RED); c.setFont('Helvetica-Bold',7.6)
    c.drawCentredString(x, baseY-dy-8, label)
    c.setFillColor(LBL); c.setFont('Helvetica',6.9)
    yy = baseY-dy-17
    for line in sub:
        c.drawCentredString(x, yy, line); yy -= 8

def callup(x, label, sub, dy=0.55*inch):
    c.setStrokeColor(RED); c.setLineWidth(0.7)
    c.line(x, baseY+0.20*inch, x, baseY+dy)
    c.setFillColor(RED); c.circle(x, baseY+0.20*inch, 1.4, stroke=0, fill=1)
    c.setFillColor(RED); c.setFont('Helvetica-Bold',7.6)
    c.drawCentredString(x, baseY+dy+4, label)
    c.setFillColor(LBL); c.setFont('Helvetica',6.9)
    yy = baseY+dy-5
    for line in sub:
        c.drawCentredString(x, yy, line); yy -= 8

calldown(rodX0+0.02*inch, "1  CARRIAGE BOLT", ["3/8\" x 6\" or M10 x 150","dome head reacts against","the underside of the base"], 0.34*inch)

# lugged head
hx = rodX0+3.30*inch
c.setFillColor(colors.HexColor('#b9c0c6')); c.setStrokeColor(STEEL_D); c.setLineWidth(0.9)
c.rect(hx-0.05*inch, baseY-0.33*inch, 0.10*inch, 0.66*inch, stroke=1, fill=1)   # flange edge-on
c.rect(hx-0.20*inch, baseY-0.16*inch, 0.15*inch, 0.32*inch, stroke=1, fill=1)   # hex boss
c.setFillColor(colors.HexColor('#8f979e'))
c.rect(hx+0.05*inch, baseY-0.31*inch, 0.075*inch, 0.09*inch, stroke=1, fill=1)  # lug
c.rect(hx+0.05*inch, baseY+0.22*inch, 0.075*inch, 0.09*inch, stroke=1, fill=1)  # lug
callup(hx-0.05*inch, "3  LUGGED HEAD (reused)", ["salvage from the kit tool, or cut", "4 lugs into a 1/4\" plate welded", "to a 19 mm nut"], 0.78*inch)

# washer
wx = rodX0+2.55*inch
c.setFillColor(colors.HexColor('#aeb6bd')); c.setStrokeColor(STEEL_D); c.setLineWidth(0.8)
c.rect(wx-0.035*inch, baseY-0.24*inch, 0.07*inch, 0.48*inch, stroke=1, fill=1)
calldown(wx, "4  THRUST WASHER", ["hardened, sized to the rod"], 0.34*inch)

# drive nut
dx = rodX0+1.95*inch
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.setLineWidth(0.8)
c.rect(dx-0.09*inch, baseY-0.18*inch, 0.18*inch, 0.36*inch, stroke=1, fill=1)
callup(dx, "2  DRIVE NUT", ["this is the one you turn","to compress the spring"], 0.34*inch)

# jam nut
jx = rodX0+1.40*inch
c.setFillColor(STEEL); c.setStrokeColor(STEEL_D); c.setLineWidth(0.8)
c.rect(jx-0.09*inch, baseY-0.18*inch, 0.18*inch, 0.36*inch, stroke=1, fill=1)
calldown(jx, "5  JAM NUT", ["locks against the drive nut", "so the rod can't spin"], 0.86*inch)

# assembly order strip
c.setFillColor(colors.HexColor('#eef3fa')); c.setStrokeColor(colors.HexColor('#1a5fb4')); c.setLineWidth(0.7)
c.rect(0.42*inch, 0.30*inch, W2-0.84*inch, 0.72*inch, stroke=1, fill=1)
c.setFillColor(NAVY); c.setFont('Helvetica-Bold',8.2)
c.drawString(0.58*inch, 0.86*inch, "Assembly order, bolt head first:")
c.setFillColor(LBL); c.setFont('Helvetica',7.6)
c.drawString(0.58*inch, 0.71*inch,
 "carriage bolt  \u2192  up through the hollow pivot post  \u2192  lugged head onto the collar  \u2192  thrust washer  \u2192  drive nut  \u2192  jam nut")
c.setFillColor(colors.HexColor('#8a5a00')); c.setFont('Helvetica-Oblique',7.2)
c.drawString(0.58*inch, 0.54*inch,
 "Grease the washer face and the rod threads. Nearly all of the effort you feel at the wrench is friction, not spring load.")
c.setFillColor(colors.HexColor('#b03a2e')); c.setFont('Helvetica-Bold',7.2)
c.drawString(0.58*inch, 0.40*inch,
 "Never substitute a thin all-thread rod \u2014 it is the part that fails, and it fails while the spring is loaded.")
c.showPage(); c.save()
print("both diagrams built")


# ---- rasterise to PNG for the PDF builder ----
try:
    import pypdfium2 as pdfium
    for n in ("diag_stack", "diag_build"):
        src = os.path.join(OUT, n + ".pdf")
        pdfium.PdfDocument(src)[0].render(scale=3.0).to_pil().save(os.path.join(OUT, n + ".png"))
        os.remove(src)
        print("  " + n + ".png")
except ImportError:
    print("  (pypdfium2 not installed - diagrams left as PDF)", file=sys.stderr)
