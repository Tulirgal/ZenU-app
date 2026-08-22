const fs = require('fs');

const data = JSON.parse(fs.readFileSync('D:/zenu/emotion_data.json', 'utf8'));

function dictToDart(d, indent = 2) {
    if (Array.isArray(d)) {
        let s = '[\n';
        for (const v of d) {
            s += ' '.repeat(indent) + dictToDart(v, indent + 2) + ',\n';
        }
        s += ' '.repeat(indent - 2) + ']';
        return s;
    } else if (d !== null && typeof d === 'object') {
        let s = '{\n';
        for (const [k, v] of Object.entries(d)) {
            s += ' '.repeat(indent) + `"${k}": ` + dictToDart(v, indent + 2) + ',\n';
        }
        s += ' '.repeat(indent - 2) + '}';
        return s;
    } else if (typeof d === 'string') {
        return '"' + d.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n') + '"';
    } else if (typeof d === 'boolean') {
        return d ? 'true' : 'false';
    } else if (d === null) {
        return 'null';
    } else {
        return String(d);
    }
}

const tertiary = dictToDart(data.tertiaryData);
const emotions = dictToDart(data.emotions);

const dartCode = `// AUTO-GENERATED from frontend data

const Map<String, dynamic> tertiaryData = ${tertiary};

const Map<String, dynamic> emotions = ${emotions};
`;

fs.writeFileSync('D:/zenu/lib/features/inner_compass/emotion_data.dart', dartCode, 'utf8');
