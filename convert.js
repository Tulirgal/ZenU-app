
function hslToHex(h, s, l) {
  l /= 100;
  const a = s * Math.min(l, 1 - l) / 100;
  const f = n => {
    const k = (n + h / 30) % 12;
    const color = l - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
    return Math.round(255 * color).toString(16).padStart(2, '0');
  };
  return '#' + f(0) + f(8) + f(4);
}
const colors = {
  bg: [250, 28, 98], bgSubtle: [250, 22, 96], bgMuted: [250, 16, 94], surface: [0, 0, 100], surfaceRaised: [250, 30, 99],
  fg: [228, 30, 16], fgMuted: [228, 18, 42], fgSubtle: [228, 12, 62], primary: [221, 70, 52], secondary: [262, 48, 58],
  accent: [172, 52, 40], border: [228, 20, 88], borderSoft: [228, 20, 93],
};
for (const [k, v] of Object.entries(colors)) { console.log(k + ': ' + hslToHex(v[0], v[1], v[2])); }

