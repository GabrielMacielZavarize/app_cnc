#!/usr/bin/env python3
"""
Conversor de dados Dart -> TypeScript para a migração CNCIA (Flutter -> React).

Lê as listas `const` de CodigoItem / AlarmeItem do app Flutter (lib/) e gera
arquivos .ts em webapp/src/data/. É string-aware: preserva escapes, parênteses
dentro de strings e resolve a concatenação implícita de literais adjacentes do
Dart ('a' 'b' -> 'a' + 'b'). Construtores nomeados viram objetos literais e
`Parametro('x','desc')` vira { letra: 'x', descricao: 'desc' }.

Reexecutável: rode `python3 webapp/scripts/convert_dart_data.py` se os dados
Dart mudarem.
"""
import re
import os

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LIB = os.path.join(ROOT, 'lib')
OUT = os.path.join(ROOT, 'webapp', 'src', 'data')

STR = r"'(?:[^'\\]|\\.)*'"


def normalize_triple(s: str) -> str:
    """Converte strings Dart com aspas triplas ('''...''') em strings de aspas
    simples com escapes (\\n etc.), para o resto do pipeline tratá-las normalmente."""
    out, i, n = [], 0, len(s)
    while i < n:
        if s[i:i + 3] == "'''":
            j = s.find("'''", i + 3)
            if j < 0:
                j = n
            conteudo = s[i + 3:j]
            esc = (conteudo.replace('\\', '\\\\').replace("'", "\\'")
                   .replace('\r', '').replace('\n', '\\n'))
            out.append("'" + esc + "'")
            i = j + 3
        else:
            out.append(s[i]); i += 1
    return ''.join(out)


def strip_comments(s: str) -> str:
    """Remove // e /* */ respeitando strings (não quebra https:// em literais)."""
    out = []
    i, n, quote = 0, len(s), None
    while i < n:
        c = s[i]
        if quote:
            out.append(c)
            if c == '\\' and i + 1 < n:
                out.append(s[i + 1]); i += 2; continue
            if c == quote:
                quote = None
            i += 1; continue
        if c in ("'", '"'):
            quote = c; out.append(c); i += 1; continue
        if c == '/' and i + 1 < n and s[i + 1] == '/':
            while i < n and s[i] != '\n':
                i += 1
            continue
        if c == '/' and i + 1 < n and s[i + 1] == '*':
            i += 2
            while i + 1 < n and not (s[i] == '*' and s[i + 1] == '/'):
                i += 1
            i += 2; continue
        out.append(c); i += 1
    return ''.join(out)


def _balanced_array(src: str, start: int) -> str:
    """Conteúdo entre [ ] a partir da posição do '[' inicial (string-aware)."""
    i, n, depth, quote = start, len(src), 0, None
    while i < n:
        c = src[i]
        if quote:
            if c == '\\':
                i += 2; continue
            if c == quote:
                quote = None
            i += 1; continue
        if c in ("'", '"'):
            quote = c; i += 1; continue
        if c == '[':
            depth += 1
        elif c == ']':
            depth -= 1
            if depth == 0:
                return src[start + 1:i]
        i += 1
    raise ValueError('colchete de fechamento não encontrado')


def extract_array(src: str, name: str) -> str:
    """Retorna o conteúdo entre [ ] de `const NOME = [...]`."""
    m = re.search(r'const\s+' + re.escape(name) + r'\s*=\s*(?:<[^>]*>)?\s*\[', src)
    if not m:
        raise ValueError(f'lista const não encontrada: {name}')
    return _balanced_array(src, m.end() - 1)


def extract_array_re(src: str, prefix: str) -> str:
    """Extrai um array após um prefixo arbitrário (regex deve terminar em `\\[`).
    Ex.: listas retornadas por funções `_criar...() => [ ... ]`."""
    m = re.search(prefix, src)
    if not m:
        raise ValueError(f'padrão não encontrado: {prefix}')
    return _balanced_array(src, m.end() - 1)


def convert_parametro(s: str) -> str:
    return re.sub(
        r"Parametro\(\s*(" + STR + r")\s*,\s*(" + STR + r")\s*\)",
        r"{ letra: \1, descricao: \2 }",
        s,
    )


def convert_paramcorte(s: str) -> str:
    return re.sub(
        r"ParamCorte\(\s*(" + STR + r")\s*,\s*(" + STR + r")\s*,\s*(" + STR + r")\s*,\s*(" + STR + r")\s*\)",
        r"{ operacao: \1, vc: \2, fz: \3, ap: \4 }",
        s,
    )


def convert_flutter_ui(s: str) -> str:
    """Color(0xFFRRGGBB) -> '#RRGGBB' ; Icons.nome -> 'nome'."""
    s = re.sub(r"Color\(0x[Ff][Ff]([0-9A-Fa-f]{6})\)", r"'#\1'", s)
    s = re.sub(r"Icons\.([A-Za-z0-9_]+)", r"'\1'", s)
    return s


def convert_linha_explicada(s: str) -> str:
    """LinhaExplicada('cod', explicacao: .., isComentario: ..) -> { codigo: 'cod', ... }.
    O 1º argumento é posicional; o `)` final é fechado depois por convert()."""
    return re.sub(r"LinhaExplicada\(\s*(" + STR + r")", r"{ codigo: \1", s)


def convert(s: str) -> str:
    """Construtores Ident(...) -> {...}; resolve concatenação implícita de strings."""
    out = []
    i, n, quote = 0, len(s), None
    while i < n:
        c = s[i]
        if quote:
            out.append(c)
            if c == '\\' and i + 1 < n:
                out.append(s[i + 1]); i += 2; continue
            if c == quote:
                quote = None
                k = i + 1
                while k < n and s[k] in ' \t\r\n':
                    k += 1
                if k < n and s[k] in ("'", '"'):
                    out.append(' +')  # literais adjacentes -> concatenação JS
            i += 1; continue
        if c in ("'", '"'):
            quote = c; out.append(c); i += 1; continue
        if c == ')':
            out.append('}'); i += 1; continue
        if c.isalpha() or c == '_':
            j = i
            while j < n and (s[j].isalnum() or s[j] == '_'):
                j += 1
            k = j
            while k < n and s[k] in ' \t\r\n':
                k += 1
            if k < n and s[k] == '(':
                out.append('{'); i = k + 1; continue
            palavra = s[i:j]
            if palavra == 'const':
                i = j; continue  # descarta a keyword const interna do Dart
            out.append(palavra); i = j; continue
        out.append(c); i += 1
    return ''.join(out)


# ── Construtores POSICIONAIS (telas Guia, Tabelas) ───────────────────
# Mapeia a ordem dos argumentos posicionais de cada classe para nomes de campo.
POSICIONAIS = {
    '_Equivalencia': ['operacao', 'fanuc', 'siemens', 'haas', 'descricao', 'nota'],
    '_Endereco': ['letra', 'nome', 'descricao', 'maquina'],
    '_GrupoEnderecos': ['nome', 'cor', 'enderecos'],
    '_Problema': ['problema', 'solucao', 'codigo', 'dica', 'tags', 'comandos', 'cor', 'icone'],
    '_RoscaMetrica': ['nome', 'passo', 'furoBroca', 'diametroMedio', 'diametroExterno',
                      'alturaFilete', 'chave', 'passoFino'],
}


def split_args(s: str):
    """Divide argumentos top-level por vírgula, respeitando (), [], {} e strings."""
    args, cur = [], []
    i, n, quote, depth = 0, len(s), None, 0
    while i < n:
        c = s[i]
        if quote:
            cur.append(c)
            if c == '\\' and i + 1 < n:
                cur.append(s[i + 1]); i += 2; continue
            if c == quote:
                quote = None
            i += 1; continue
        if c in ("'", '"'):
            quote = c; cur.append(c); i += 1; continue
        if c in '([{':
            depth += 1; cur.append(c); i += 1; continue
        if c in ')]}':
            depth -= 1; cur.append(c); i += 1; continue
        if c == ',' and depth == 0:
            args.append(''.join(cur).strip()); cur = []; i += 1; continue
        cur.append(c); i += 1
    if ''.join(cur).strip():
        args.append(''.join(cur).strip())
    return args


CORES_CONST = {
    'kDark': '#1A1A2E', 'kAmber': '#E8A020', 'kBg': '#F5F5F5',
    'kBlue': '#185FA5', 'kRed': '#D94040', 'kGreen': '#0F6E56',
}


def conv_arg(arg: str) -> str:
    arg = arg.strip()
    if arg in CORES_CONST:
        return f"'{CORES_CONST[arg]}'"
    if arg.startswith('Color(') or arg.startswith('Icons.') or arg.startswith('const Color('):
        return convert_flutter_ui(arg.replace('const ', ''))
    if arg.startswith('['):
        elems = [e for e in split_args(arg[1:arg.rfind(']')]) if e.strip()]
        return '[' + ', '.join(conv_arg(e) for e in elems) + ']'
    if arg.startswith('{'):
        return convert(arg)
    m = re.match(r'(?:const\s+)?(_\w+)\((.*)\)$', arg, re.S)
    if m and m.group(1) in POSICIONAIS:
        return conv_construtor(m.group(1), m.group(2))
    return convert(arg)  # string/número: resolve concatenação implícita


def conv_construtor(classe: str, args_str: str) -> str:
    campos = POSICIONAIS[classe]
    args = split_args(args_str)
    pares = [f'{campo}: {conv_arg(args[i])}' for i, campo in enumerate(campos) if i < len(args)]
    return '{ ' + ', '.join(pares) + ' }'


def convert_positional_array(array_content: str, classe: str) -> str:
    out = []
    for it in split_args(array_content):
        m = re.match(r'(?:const\s+)?(_\w+)\((.*)\)$', it.strip(), re.S)
        if m and m.group(1) == classe:
            out.append(conv_construtor(m.group(1), m.group(2)))
    return '[\n  ' + ',\n  '.join(out) + ',\n]'


def lista_posicional_ts(src: str, name: str, classe: str, ts_type: str, out_name=None) -> str:
    conteudo = convert_positional_array(extract_array(src, name), classe)
    return f'export const {out_name or name}: {ts_type}[] = {conteudo};\n'


def lista_ts(src: str, name: str, ts_type: str) -> str:
    conteudo = convert(convert_parametro(extract_array(src, name)))
    return f'export const {name}: {ts_type}[] = [{conteudo}];\n'


def lista_ts_material(src: str, name: str) -> str:
    conteudo = extract_array(src, name)
    conteudo = convert_paramcorte(conteudo)
    conteudo = convert_flutter_ui(conteudo)
    conteudo = convert(conteudo)
    return f'export const {name}: MaterialCNC[] = [{conteudo}];\n'


def lista_ts_programa(src: str, name: str, out_name: str) -> str:
    conteudo = extract_array(src, name)
    conteudo = convert_linha_explicada(conteudo)
    conteudo = convert_flutter_ui(conteudo)
    conteudo = convert(conteudo)
    return f'const {out_name}: ProgramaCNC[] = [{conteudo}];\n'


def read(path: str) -> str:
    with open(path, encoding='utf-8') as f:
        return strip_comments(f.read())


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    models = read(os.path.join(LIB, 'models.dart'))
    fabricantes = read(os.path.join(LIB, 'data', 'codigos_g_fabricantes.dart'))
    extras = read(os.path.join(LIB, 'data', 'codigos_extras.dart'))
    alarmes_ex = read(os.path.join(LIB, 'data', 'alarmes_extras.dart'))

    # ---- CÓDIGOS ----
    cod = ["import type { CodigoItem } from '@/types';\n",
           '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n']
    cod.append(lista_ts(models, 'codigosG', 'CodigoItem'))
    cod.append(lista_ts(models, 'codigosM', 'CodigoItem'))
    cod.append(lista_ts(models, 'codigosGExtras', 'CodigoItem'))
    cod.append(lista_ts(fabricantes, 'codigosGFabricantes', 'CodigoItem'))
    cod.append(lista_ts(extras, 'codigosMExtras', 'CodigoItem'))
    cod.append(
        '\nexport const todosCodigos: CodigoItem[] = [\n'
        '  ...codigosG, ...codigosGExtras, ...codigosGFabricantes,\n'
        '  ...codigosM, ...codigosMExtras,\n'
        '];\n'
    )
    with open(os.path.join(OUT, 'codigos.ts'), 'w', encoding='utf-8') as f:
        f.write(''.join(cod))

    # ---- ALARMES ----
    listas_models = ['alarmesFanuc', 'alarmesSiemens', 'alarmesHaas', 'alarmesMazak',
                     'alarmesMitsubishi', 'alarmesHeidenhain', 'alarmesOkuma', 'alarmesRomi']
    listas_extra = ['alarmesFanucPS', 'alarmesFanucOT', 'alarmesFanucSV', 'alarmesFanucOH',
                    'alarmesFanucPSExtra', 'alarmesHaasExtras', 'alarmesSiemensExtras',
                    'alarmesHaasBank2', 'alarmesSiemensBank2', 'alarmesOkumaBank2',
                    'alarmesFanucSW', 'alarmesHaasBank3', 'alarmesSiemensBank3']
    al = ["import type { AlarmeItem } from '@/types';\n",
          '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n']
    for nome in listas_models:
        al.append(lista_ts(models, nome, 'AlarmeItem'))
    for nome in listas_extra:
        al.append(lista_ts(alarmes_ex, nome, 'AlarmeItem'))

    por_fab = {
        'Fanuc': ['alarmesFanuc', 'alarmesFanucPS', 'alarmesFanucOT', 'alarmesFanucSV',
                  'alarmesFanucOH', 'alarmesFanucPSExtra', 'alarmesFanucSW'],
        'Siemens': ['alarmesSiemens', 'alarmesSiemensExtras', 'alarmesSiemensBank2', 'alarmesSiemensBank3'],
        'Haas': ['alarmesHaas', 'alarmesHaasExtras', 'alarmesHaasBank2', 'alarmesHaasBank3'],
        'Mazak': ['alarmesMazak'],
        'Mitsubishi': ['alarmesMitsubishi'],
        'Heidenhain': ['alarmesHeidenhain'],
        'Okuma': ['alarmesOkuma', 'alarmesOkumaBank2'],
        'Romi': ['alarmesRomi'],
    }
    al.append('\nexport const alarmesPorFabricante: Record<string, AlarmeItem[]> = {\n')
    for fab, nomes in por_fab.items():
        spread = ', '.join('...' + n for n in nomes)
        al.append(f"  {fab}: [{spread}],\n")
    al.append('};\n')
    al.append('\nexport const todosAlarmes: AlarmeItem[] = Object.values(alarmesPorFabricante).flat();\n')
    with open(os.path.join(OUT, 'alarmes.ts'), 'w', encoding='utf-8') as f:
        f.write(''.join(al))

    # ---- MATERIAIS ----
    materiais = read(os.path.join(LIB, 'materias', 'materiais_data.dart'))
    mat = ["import type { MaterialCNC } from '@/types';\n",
           '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n']
    for nome in ['materiaisFresamento', 'materiaisTorneamento', 'materiaisFuracao']:
        mat.append(lista_ts_material(materiais, nome))
    mat.append(
        '\nexport const todosMateriais: MaterialCNC[] = [\n'
        '  ...materiaisFresamento, ...materiaisTorneamento, ...materiaisFuracao,\n'
        '];\n'
    )
    with open(os.path.join(OUT, 'materiais.ts'), 'w', encoding='utf-8') as f:
        f.write(''.join(mat))

    # ---- DICIONÁRIO (dados embutidos na tela) ----
    dic = read(os.path.join(LIB, 'screens', 'dicionario_screen.dart'))
    termos = convert(convert_parametro(extract_array(dic, '_termos')))
    with open(os.path.join(OUT, 'dicionario.ts'), 'w', encoding='utf-8') as f:
        f.write(
            "import type { Termo } from '@/types';\n"
            '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n'
            f'export const termos: Termo[] = [{termos}];\n'
        )

    # ---- GUIA (dados embutidos, construtores posicionais) ----
    guia = read(os.path.join(LIB, 'screens', 'guia_screen.dart'))
    g = ["import type { Problema, Equivalencia, GrupoEnderecos } from '@/types';\n",
         '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n']
    g.append(lista_posicional_ts(guia, '_problemas', '_Problema', 'Problema', 'problemas'))
    g.append(lista_posicional_ts(guia, '_equivalencias', '_Equivalencia', 'Equivalencia', 'equivalencias'))
    g.append(lista_posicional_ts(guia, '_grupos', '_GrupoEnderecos', 'GrupoEnderecos', 'grupos'))
    with open(os.path.join(OUT, 'guia.ts'), 'w', encoding='utf-8') as f:
        f.write(''.join(g))

    # ---- TABELAS — roscas métricas ----
    tabelas = read(os.path.join(LIB, 'screens', 'tabelas_screen.dart'))
    t = ["import type { RoscaMetrica } from '@/types';\n",
         '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n']
    t.append(lista_posicional_ts(tabelas, '_roscasMetricas', '_RoscaMetrica', 'RoscaMetrica', 'roscasMetricas'))
    with open(os.path.join(OUT, 'tabelas.ts'), 'w', encoding='utf-8') as f:
        f.write(''.join(t))

    # ---- PROGRAMAS CNC (campo `codigo` usa aspas triplas multilinha) ----
    with open(os.path.join(LIB, 'screens', 'programas_screen.dart'), encoding='utf-8') as fp:
        prog = strip_comments(normalize_triple(fp.read()))
    p = ["import type { ProgramaCNC } from '@/types';\n",
         '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n']
    p.append(lista_ts_programa(prog, '_programasFresamento', 'fresBase'))
    p.append(lista_ts_programa(prog, '_programasFresamentoExtras', 'fresExtra'))
    p.append(lista_ts_programa(prog, '_programasTorneamento', 'tornBase'))
    p.append(lista_ts_programa(prog, '_programasTorneamentoExtras', 'tornExtra'))
    p.append(lista_ts_programa(prog, '_programasEspeciais', 'espBase'))
    p.append(lista_ts_programa(prog, '_programasEspeciaisExtras', 'espExtra'))
    p.append(
        '\nexport const programasFresamento: ProgramaCNC[] = [...fresBase, ...fresExtra];\n'
        'export const programasTorneamento: ProgramaCNC[] = [...tornBase, ...tornExtra];\n'
        'export const programasEspeciais: ProgramaCNC[] = [...espBase, ...espExtra];\n'
    )
    with open(os.path.join(OUT, 'programas.ts'), 'w', encoding='utf-8') as f:
        f.write(''.join(p))

    # ---- CHECKLIST (lista retornada por _criarChecklist) ----
    chk = read(os.path.join(LIB, 'screens', 'checklist_screen.dart'))
    itens = convert(extract_array_re(chk, r'_criarChecklist\(\)\s*=>\s*\['))
    with open(os.path.join(OUT, 'checklist.ts'), 'w', encoding='utf-8') as f:
        f.write(
            "import type { CheckItem } from '@/types';\n"
            '// Gerado por scripts/convert_dart_data.py — não editar à mão.\n\n'
            f'export const checklistItens: CheckItem[] = [{itens}];\n'
        )

    print('OK: codigos, alarmes, materiais, dicionario, guia, tabelas e checklist gerados em', OUT)


if __name__ == '__main__':
    main()
