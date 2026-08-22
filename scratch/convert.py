import json

with open('D:/zenu/emotion_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

def dict_to_dart(d, indent=2):
    if isinstance(d, dict):
        s = '{\n'
        for k, v in d.items():
            s += ' ' * indent + f'"{k}": {dict_to_dart(v, indent + 2)},\n'
        s += ' ' * (indent - 2) + '}'
        return s
    elif isinstance(d, list):
        s = '[\n'
        for v in d:
            s += ' ' * indent + f'{dict_to_dart(v, indent + 2)},\n'
        s += ' ' * (indent - 2) + ']'
        return s
    elif isinstance(d, str):
        return '"' + d.replace('"', '\\"').replace('\n', '\\n') + '"'
    elif isinstance(d, bool):
        return str(d).lower()
    elif d is None:
        return 'null'
    else:
        return str(d)

tertiary = dict_to_dart(data['tertiaryData'])
emotions = dict_to_dart(data['emotions'])

dart_code = f'''// AUTO-GENERATED from frontend data

const Map<String, dynamic> tertiaryData = {tertiary};

const Map<String, dynamic> emotions = {emotions};
'''

with open('D:/zenu/lib/features/inner_compass/emotion_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)
