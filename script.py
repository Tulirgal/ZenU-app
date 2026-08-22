import re
import colorsys
import math

def hsl_to_hex(h, s, l):
    r, g, b = colorsys.hls_to_rgb(h / 360.0, l / 100.0, s / 100.0)
    return f'0xFF{int(r * 255):02X}{int(g * 255):02X}{int(b * 255):02X}'

css = '''
  --zen-bg:             250 28% 98%;
  --zen-bg-subtle:      250 22% 96%;
  --zen-bg-muted:       250 16% 94%;
  --zen-surface:        0 0% 100%;
  --zen-surface-raised: 250 30% 99%;
  --zen-surface-elevated: 0 0% 100%;
  --zen-emotion-sadness:       210 70% 58%;
  --zen-emotion-sadness-soft:  210 70% 96%;
  --zen-emotion-okay:          172 48% 42%;
  --zen-emotion-okay-soft:     172 48% 95%;
  --zen-emotion-calm:          262 48% 58%;
  --zen-emotion-calm-soft:     262 55% 96%;
  --zen-emotion-joy:           42 92% 55%;
  --zen-emotion-joy-soft:      42 92% 96%;
  --zen-emotion-great:         350 72% 62%;
  --zen-emotion-great-soft:    350 72% 96%;
  --zen-emotion-surprise:      24 90% 58%;
  --zen-emotion-surprise-soft: 24 90% 96%;
  --zen-emotion-anger:         8 78% 56%;
  --zen-emotion-anger-soft:    8 78% 96%;
  --zen-emotion-fear:          275 45% 55%;
  --zen-emotion-fear-soft:     275 45% 96%;
  --zen-emotion-disgust:       142 40% 42%;
  --zen-emotion-disgust-soft:  142 40% 95%;
  --zen-fg:             228 30% 16%;
  --zen-fg-muted:       228 18% 42%;
  --zen-fg-subtle:      228 12% 62%;
  --zen-fg-inverse:     0 0% 100%;
  --zen-primary:        221 70% 52%;
  --zen-primary-hover:  221 70% 46%;
  --zen-primary-soft:   221 75% 96%;
  --zen-primary-fg:     0 0% 100%;
  --zen-secondary:      262 48% 58%;
  --zen-secondary-soft: 262 55% 96%;
  --zen-secondary-fg:   0 0% 100%;
  --zen-accent:         172 52% 40%;
  --zen-accent-soft:    172 55% 95%;
  --zen-accent-fg:      0 0% 100%;
  --zen-joy:            40 92% 55%;
  --zen-joy-soft:       40 92% 96%;
  --zen-border:         228 20% 88%;
  --zen-border-soft:    228 20% 93%;
  --zen-border-focus:   221 70% 52%;
  --zen-success:        142 62% 38%;
  --zen-success-soft:   142 62% 95%;
  --zen-warning:        36 88% 50%;
  --zen-warning-soft:   36 88% 96%;
  --zen-destructive:    0 78% 54%;
  --zen-destructive-soft: 0 78% 96%;
'''

for line in css.strip().split('\n'):
    if ':' in line:
        var_name, val = line.split(':', 1)
        var_name = var_name.strip()
        val = val.strip().strip(';')
        if '%' in val:
            parts = val.split()
            h, s, l = float(parts[0]), float(parts[1].strip('%')), float(parts[2].strip('%'))
            hex_val = hsl_to_hex(h, s, l)
            dart_name = ''.join(word.title() if i > 0 else word.lower() for i, word in enumerate(var_name.replace('--', '').split('-')))
            print(f'  static const Color {dart_name} = Color({hex_val}); // from {var_name}')

print('''
  // --- RADII ---
  static const double radiusZenSm  = 8.0;  // from --radius-sm
  static const double radiusZenMd  = 12.0; // from --radius-md
  static const double radiusZenLg  = 16.0; // from --radius-lg
  static const double radiusZenXl  = 24.0; // from --radius-xl
  static const double radiusZen2xl = 32.0; // from --radius-2xl
  static const double radiusZenFull = 9999.0; // from --radius-full
''')

import re
moduleThemesTs = '''
  home: {
    gradient: 'linear-gradient(135deg, #0f0c29 0%, #302b63 40%, #24243e 100%)',
    accentColor: '#a78bfa',
    accentLight: 'rgba(167,139,250,0.12)',
    textPrimary: '#f1f0ff',
    textSecondary: '#c4b5fd',
    cardBg: 'rgba(255,255,255,0.07)',
    cardBorder: 'rgba(167,139,250,0.2)',
    particles: { color: '#c4b5fd', count: 30, size: [1, 3], speed: 0.3 },
    liveEffect: 'aurora',
  },
  breathing: {
    gradient: 'linear-gradient(180deg, #001a2c 0%, #003d5c 40%, #00688b 80%, #0099bb 100%)',
    accentColor: '#38bdf8',
    accentLight: 'rgba(56,189,248,0.12)',
    textPrimary: '#e0f7ff',
    textSecondary: '#7dd3fc',
    cardBg: 'rgba(0,100,150,0.25)',
    cardBorder: 'rgba(56,189,248,0.25)',
    particles: { color: '#38bdf8', count: 20, size: [2, 5], speed: 0.2 },
    liveEffect: 'ripples',
  },
  mindfulness: {
    gradient: 'linear-gradient(160deg, #0d1f12 0%, #1a3a22 35%, #2d5a3d 70%, #1a3a22 100%)',
    accentColor: '#4ade80',
    accentLight: 'rgba(74,222,128,0.1)',
    textPrimary: '#dcfce7',
    textSecondary: '#86efac',
    cardBg: 'rgba(20,60,30,0.4)',
    cardBorder: 'rgba(74,222,128,0.2)',
    particles: { color: '#86efac', count: 25, size: [2, 6], speed: 0.15 },
    liveEffect: 'leaves',
  },
  gratitude: {
    gradient: 'linear-gradient(160deg, #1a0a00 0%, #3d1f00 30%, #7c4000 60%, #c8740a 85%, #f2c14e 100%)',
    accentColor: '#f59e0b',
    accentLight: 'rgba(245,158,11,0.12)',
    textPrimary: '#fef9ee',
    textSecondary: '#fcd34d',
    cardBg: 'rgba(120,60,0,0.3)',
    cardBorder: 'rgba(245,158,11,0.25)',
    particles: { color: '#fcd34d', count: 20, size: [1, 3], speed: 0.2 },
    liveEffect: 'petals',
  },
  diary: {
    gradient: 'linear-gradient(150deg, #0f0817 0%, #1e1035 40%, #2d1b69 75%, #1e1035 100%)',
    accentColor: '#818cf8',
    accentLight: 'rgba(129,140,248,0.12)',
    textPrimary: '#eef2ff',
    textSecondary: '#a5b4fc',
    cardBg: 'rgba(30,16,53,0.5)',
    cardBorder: 'rgba(129,140,248,0.2)',
    particles: { color: '#a5b4fc', count: 40, size: [1, 2], speed: 0.1 },
    liveEffect: 'stars',
  },
  doodle: {
    gradient: 'linear-gradient(135deg, #1a0533 0%, #2d0d5e 25%, #1e3a8a 55%, #065f46 85%, #1a0533 100%)',
    accentColor: '#f0abfc',
    accentLight: 'rgba(240,171,252,0.12)',
    textPrimary: '#fdf4ff',
    textSecondary: '#e879f9',
    cardBg: 'rgba(45,13,94,0.4)',
    cardBorder: 'rgba(240,171,252,0.2)',
    particles: { color: '#f0abfc', count: 35, size: [2, 5], speed: 0.25 },
    liveEffect: 'bubbles',
  },
  bubble: {
    gradient: 'linear-gradient(160deg, #001219 0%, #005f73 40%, #0a9396 75%, #94d2bd 100%)',
    accentColor: '#94d2bd',
    accentLight: 'rgba(148,210,189,0.12)',
    textPrimary: '#e8f8f5',
    textSecondary: '#94d2bd',
    cardBg: 'rgba(0,95,115,0.3)',
    cardBorder: 'rgba(148,210,189,0.25)',
    particles: { color: '#94d2bd', count: 18, size: [8, 24], speed: 0.3 },
    liveEffect: 'bubbles',
  },
  burst: {
    gradient: 'linear-gradient(160deg, #0a0514 0%, #1e1035 35%, #3b1c7a 70%, #2d1b69 100%)',
    accentColor: '#c084fc',
    accentLight: 'rgba(192,132,252,0.12)',
    textPrimary: '#faf5ff',
    textSecondary: '#d8b4fe',
    cardBg: 'rgba(30,16,53,0.5)',
    cardBorder: 'rgba(192,132,252,0.25)',
    particles: { color: '#e9d5ff', count: 45, size: [1, 3], speed: 0.8 },
    liveEffect: 'stars',
  },
  scribble: {
    gradient: 'linear-gradient(150deg, #1c1410 0%, #2d1f14 40%, #3d2a1a 70%, #1c1410 100%)',
    accentColor: '#d97706',
    accentLight: 'rgba(217,119,6,0.12)',
    textPrimary: '#fef3c7',
    textSecondary: '#fcd34d',
    cardBg: 'rgba(45,30,20,0.5)',
    cardBorder: 'rgba(217,119,6,0.2)',
    particles: { color: '#fcd34d', count: 12, size: [1, 3], speed: 0.15 },
    liveEffect: 'none',
  },
  chat: {
    gradient: 'linear-gradient(160deg, #020617 0%, #0f172a 40%, #1e3a5f 75%, #0f172a 100%)',
    accentColor: '#60a5fa',
    accentLight: 'rgba(96,165,250,0.1)',
    textPrimary: '#eff6ff',
    textSecondary: '#93c5fd',
    cardBg: 'rgba(15,23,42,0.6)',
    cardBorder: 'rgba(96,165,250,0.2)',
    particles: { color: '#93c5fd', count: 25, size: [1, 2], speed: 0.1 },
    liveEffect: 'stars',
  },
  "healing-garden": {
    gradient: 'linear-gradient(180deg, #0a1628 0%, #0d2137 30%, #0f3d2a 65%, #0a1628 100%)',
    accentColor: '#4ade80',
    accentLight: 'rgba(74,222,128,0.1)',
    textPrimary: '#f0fff4',
    textSecondary: '#86efac',
    cardBg: 'rgba(10,22,40,0.5)',
    cardBorder: 'rgba(74,222,128,0.15)',
    particles: { color: '#f2c14e', count: 8, size: [3, 5], speed: 0.15 },
    liveEffect: 'fireflies',
  },
  innercompass: {
    gradient: 'linear-gradient(160deg, #FFF0F5 0%, #FFE1E9 50%, #FFD1DF 100%)',
    accentColor: '#ec4899',
    accentLight: 'rgba(236,72,153,0.1)',
    textPrimary: '#831843',
    textSecondary: '#be185d',
    cardBg: 'rgba(255,255,255,0.6)',
    cardBorder: 'rgba(236,72,153,0.2)',
    particles: { color: '#fbcfe8', count: 30, size: [2, 5], speed: 0.15 },
    liveEffect: 'petals',
  },
'''

def parse_color(c):
    c = c.strip()
    if c.startswith('#'):
        c = c.lstrip('#')
        if len(c) == 3:
            c = ''.join([x*2 for x in c])
        return f'Color(0xFF{c.upper()})'
    elif c.startswith('rgba'):
        parts = c[5:-1].split(',')
        return f'Color.fromRGBO({parts[0].strip()}, {parts[1].strip()}, {parts[2].strip()}, {parts[3].strip()})'
    return 'Color(0xFF000000)'

def parse_gradient(grad):
    match = re.search(r'linear-gradient\(([\d]+)deg,\s*(.*)\)', grad)
    if not match:
        return 'null'
    deg = int(match.group(1))
    stops_str = match.group(2)
    stops = []
    colors = []
    for part in stops_str.split(', '):
        part = part.strip()
        color, stop = part.split(' ')
        colors.append(parse_color(color))
        stops.append(str(float(stop.replace('%', '')) / 100.0))
    return f"""LinearGradient(
      colors: [{', '.join(colors)}],
      stops: [{', '.join(stops)}],
      transform: const GradientRotation({deg} * math.pi / 180),
    )"""

print('// --- MODULES ---')
import ast
modules = re.findall(r'[\'"]?([a-zA-Z0-9-]+)[\'"]?:\s*\{([^}]*)\}', moduleThemesTs, re.MULTILINE | re.DOTALL)
for mod_name, mod_body in modules:
    print(f"      '{mod_name}': ModuleTheme(")
    
    grad_match = re.search(r"gradient:\s*'([^']+)'", mod_body)
    if grad_match:
        print(f"        gradient: {parse_gradient(grad_match.group(1))},")
        
    accent_match = re.search(r"accentColor:\s*'([^']+)'", mod_body)
    if accent_match:
        print(f"        accentColor: {parse_color(accent_match.group(1))},")
        
    accent_l_match = re.search(r"accentLight:\s*'([^']+)'", mod_body)
    if accent_l_match:
        print(f"        accentLight: {parse_color(accent_l_match.group(1))},")
        
    text_p_match = re.search(r"textPrimary:\s*'([^']+)'", mod_body)
    if text_p_match:
        print(f"        textPrimary: {parse_color(text_p_match.group(1))},")
        
    text_s_match = re.search(r"textSecondary:\s*'([^']+)'", mod_body)
    if text_s_match:
        print(f"        textSecondary: {parse_color(text_s_match.group(1))},")
        
    card_bg_match = re.search(r"cardBg:\s*'([^']+)'", mod_body)
    if card_bg_match:
        print(f"        cardBg: {parse_color(card_bg_match.group(1))},")
        
    card_border_match = re.search(r"cardBorder:\s*'([^']+)'", mod_body)
    if card_border_match:
        print(f"        cardBorder: {parse_color(card_border_match.group(1))},")
        
    part_col_match = re.search(r"particles:\s*\{\s*color:\s*'([^']+)'", mod_body)
    if part_col_match:
        print(f"        particleColor: {parse_color(part_col_match.group(1))},")
        
    part_cnt_match = re.search(r"count:\s*(\d+)", mod_body)
    if part_cnt_match:
        print(f"        particleCount: {part_cnt_match.group(1)},")
        
    live_eff_match = re.search(r"liveEffect:\s*'([^']+)'", mod_body)
    if live_eff_match:
        eff = live_eff_match.group(1)
        if eff == 'none':
            eff = 'LiveEffect.none'
        else:
            eff = f'LiveEffect.{eff}'
        print(f"        liveEffect: {eff},")
        
    print("      ),")

