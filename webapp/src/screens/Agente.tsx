import { useEffect, useRef, useState } from 'react';
import { Bot, Send, WifiOff } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { consultarAgente, type ChatMsg } from '@/services/ia';
import { useConectividadeStore } from '@/stores/conectividade';
import { cx } from '@/lib/cx';

interface Msg extends ChatMsg {
  welcome?: boolean;
}

const SUGESTOES = [
  'Como fazer furo fundo?',
  'Código para rosca M10',
  'Calcular RPM para Ø25mm em aço 1045',
  'O que é G41/G42?',
  'Diferença entre G0 e G1',
  'G83 ciclo de furação no Fanuc',
];

const BOAS_VINDAS: Msg = {
  role: 'model',
  welcome: true,
  text: 'Sou o Mestre CNC. Pergunte sobre códigos, ciclos, parâmetros de corte ou diagnósticos — e diga o comando da sua máquina (Fanuc, Siemens, Haas...) para eu dar a sintaxe certa.',
};

export function Agente() {
  const online = useConectividadeStore((s) => s.online);
  const [msgs, setMsgs] = useState<Msg[]>([BOAS_VINDAS]);
  const [input, setInput] = useState('');
  const [carregando, setCarregando] = useState(false);
  const fimRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    fimRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [msgs, carregando]);

  async function enviar(texto: string) {
    const t = texto.trim();
    if (!t || carregando) return;
    const novas: Msg[] = [...msgs, { role: 'user', text: t }];
    setMsgs(novas);
    setInput('');
    setCarregando(true);
    try {
      const historico: ChatMsg[] = novas.filter((m) => !m.welcome).map(({ role, text }) => ({ role, text }));
      const r = await consultarAgente(historico);
      setMsgs([...novas, { role: 'model', text: r || 'Não obtive resposta. Tente reformular.' }]);
    } catch {
      setMsgs([...novas, { role: 'model', text: 'Não consegui falar com o servidor de IA. Confirme que o backend (server.py) está rodando.' }]);
    } finally {
      setCarregando(false);
    }
  }

  const soBoasVindas = msgs.length === 1;

  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Agente CNC" subtitle="Assistente conversacional" icon={Bot} back />

      <div className="flex-1 space-y-3 p-4">
        {!online && (
          <div className="flex items-center gap-2 rounded-xl bg-amber-50 px-3 py-2 text-xs text-amber-800">
            <WifiOff size={16} /> O agente precisa de internet para responder.
          </div>
        )}

        {msgs.map((m, i) => (
          <div key={i} className={cx('flex', m.role === 'user' ? 'justify-end' : 'justify-start')}>
            <div
              className={cx(
                'max-w-[85%] whitespace-pre-wrap rounded-2xl px-3.5 py-2.5 text-sm leading-relaxed shadow-sm',
                m.role === 'user' ? 'bg-cnc-amber text-cnc-dark' : 'border border-black/[0.06] bg-white text-gray-700',
              )}
            >
              {m.text}
            </div>
          </div>
        ))}

        {carregando && (
          <div className="flex justify-start">
            <div className="rounded-2xl border border-black/[0.06] bg-white px-4 py-3 shadow-sm">
              <span className="flex gap-1">
                <span className="h-2 w-2 animate-bounce rounded-full bg-gray-300 [animation-delay:-0.3s]" />
                <span className="h-2 w-2 animate-bounce rounded-full bg-gray-300 [animation-delay:-0.15s]" />
                <span className="h-2 w-2 animate-bounce rounded-full bg-gray-300" />
              </span>
            </div>
          </div>
        )}

        {soBoasVindas && (
          <div className="flex flex-wrap gap-2 pt-1">
            {SUGESTOES.map((s) => (
              <button
                key={s}
                type="button"
                onClick={() => enviar(s)}
                className="rounded-full border border-black/10 bg-white px-3 py-1.5 text-xs text-gray-600 hover:border-cnc-amber"
              >
                {s}
              </button>
            ))}
          </div>
        )}

        <div ref={fimRef} />
      </div>

      <div className="sticky bottom-0 flex items-center gap-2 border-t border-black/[0.06] bg-white p-3">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && enviar(input)}
          placeholder="Pergunte ao Mestre CNC..."
          className="min-w-0 flex-1 rounded-full border border-black/10 bg-gray-50 px-4 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
        />
        <button
          type="button"
          onClick={() => enviar(input)}
          disabled={!input.trim() || carregando}
          className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-cnc-dark text-white disabled:opacity-40"
          aria-label="Enviar"
        >
          <Send size={18} />
        </button>
      </div>
    </div>
  );
}
