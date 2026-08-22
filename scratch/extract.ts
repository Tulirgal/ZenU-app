import { tertiaryData, emotions } from 'D:/tulirgal/Zenu-frontend/src/components/inner-compass/emotionData';
import fs from 'fs';
fs.writeFileSync('D:/zenu/emotion_data.json', JSON.stringify({ tertiaryData, emotions }));
