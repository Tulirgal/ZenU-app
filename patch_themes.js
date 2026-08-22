const fs = require('fs');

let content = fs.readFileSync('lib/core/theme/module_themes.dart', 'utf8');

// 1. Add fields to class
content = content.replace(
  '  final int particleCount;',
  '  final int particleCount;\n  final double particleSizeMin;\n  final double particleSizeMax;\n  final double particleSpeed;'
);
content = content.replace(
  '    required this.particleCount,',
  '    required this.particleCount,\n    required this.particleSizeMin,\n    required this.particleSizeMax,\n    required this.particleSpeed,'
);

// 2. Add values to each theme
const params = {
  home: { min: 1.0, max: 3.0, spd: 0.3 },
  breathing: { min: 2.0, max: 5.0, spd: 0.2 },
  mindfulness: { min: 2.0, max: 6.0, spd: 0.15 },
  gratitude: { min: 1.0, max: 3.0, spd: 0.2 },
  diary: { min: 1.0, max: 2.0, spd: 0.1 },
  doodle: { min: 2.0, max: 5.0, spd: 0.25 },
  bubble: { min: 8.0, max: 24.0, spd: 0.3 },
  burst: { min: 1.0, max: 3.0, spd: 0.8 },
  scribble: { min: 1.0, max: 3.0, spd: 0.15 },
  chat: { min: 1.0, max: 2.0, spd: 0.1 },
  'healing-garden': { min: 3.0, max: 5.0, spd: 0.15 },
  innercompass: { min: 2.0, max: 5.0, spd: 0.15 },
};

for (const [key, val] of Object.entries(params)) {
  const r = new RegExp(`('${key}': const ModuleTheme\\([\\s\\S]*?particleCount: \\d+,)`);
  content = content.replace(r, `$1\n      particleSizeMin: ${val.min},\n      particleSizeMax: ${val.max},\n      particleSpeed: ${val.spd},`);
}

fs.writeFileSync('lib/core/theme/module_themes.dart', content);
