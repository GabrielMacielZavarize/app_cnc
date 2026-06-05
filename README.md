# CNCIA — Assistente Industrial CNC

Aplicativo web para operadores e programadores de CNC: biblioteca de códigos G/M,
alarmes de 7 fabricantes, materiais de usinagem, calculadora de parâmetros de corte,
tabelas técnicas, programas de exemplo, manual ilustrado e análise com IA.

Originalmente em Flutter, o front-end foi reescrito em **React + TypeScript** (pasta
`webapp/`). O back-end em **Python/FastAPI** (`server.py`) faz a ponte com a IA do Google
Gemini, mantendo a chave fora do navegador.

## Estrutura

```
webapp/              Front-end React (Vite + TS + Tailwind + Zustand) — PWA instalável
server.py            Back-end FastAPI: /gerar-programa (chat) e /analisar (IA por foto/texto)
base_conhecimento/   Tabelas técnicas lidas pelo back-end (equivalências de normas)
.env                 GEMINI_API_KEY do back-end
.venv/               Ambiente Python do back-end
```

## Como rodar

### Back-end (necessário para IA e Agente)
```bash
.venv/bin/uvicorn server:app --host 127.0.0.1 --port 8000
# (primeira vez) pip install fastapi "uvicorn[standard]" google-generativeai python-dotenv pydantic
```

### Front-end
```bash
cd webapp
npm install      # primeira vez
npm run dev      # http://localhost:5173  (faz proxy de /api → back-end :8000)
npm run build    # gera dist/ estático (PWA) para deploy
```

## Configuração da IA

Defina a chave do Gemini em `.env`:
```
GEMINI_API_KEY=sua_chave_aqui
```
Gere a chave em https://aistudio.google.com/apikey. Sem uma chave válida, as telas de
IA e Agente exibem uma mensagem de erro amigável; o restante do app funciona offline.
