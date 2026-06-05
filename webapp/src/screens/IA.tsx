import { useRef, useState } from 'react';
import { ImagePlus, Loader2, Sparkles, Trash2, WifiOff, X } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { Tabs } from '@/components/ui/Tabs';
import { EmptyState } from '@/components/ui/EmptyState';
import { Badge } from '@/components/ui/Badge';
import { analisarIA, type TipoAnalise } from '@/services/ia';
import { useConectividadeStore } from '@/stores/conectividade';
import { useIAStore } from '@/stores/ia';
import { tempoRelativo } from '@/lib/format';
import { cx } from '@/lib/cx';

const TIPOS: { id: TipoAnalise; label: string; cor: string }[] = [
  { id: 'geral', label: '🔍 Geral', cor: '#185FA5' },
  { id: 'erro', label: '⚠️ Alarme', cor: '#D94040' },
  { id: 'peca', label: '⚙️ Peça', cor: '#0F6E56' },
  { id: 'programa', label: '💻 Programa', cor: '#534AB7' },
  { id: 'ferramenta', label: '🔧 Ferramenta', cor: '#BA7517' },
  { id: 'parametros', label: '📐 Parâmetros', cor: '#993C1D' },
];

export function IA() {
  const [aba, setAba] = useState('analisar');
  const historico = useIAStore((s) => s.historico);
  return (
    <>
      <TopBar title="Análise com IA" subtitle="Diagnóstico por foto ou texto" icon={Sparkles} />
      <div className="space-y-3 p-4">
        <Tabs
          tabs={[
            { key: 'analisar', label: 'Analisar' },
            { key: 'historico', label: 'Histórico', count: historico.length },
          ]}
          active={aba}
          onChange={setAba}
        />
        {aba === 'analisar' ? <AbaAnalisar /> : <AbaHistorico />}
      </div>
    </>
  );
}

function AbaAnalisar() {
  const online = useConectividadeStore((s) => s.online);
  const add = useIAStore((s) => s.add);
  const fileRef = useRef<HTMLInputElement>(null);

  const [tipo, setTipo] = useState<TipoAnalise>('geral');
  const [texto, setTexto] = useState('');
  const [preview, setPreview] = useState<string | null>(null);
  const [imagemB64, setImagemB64] = useState<string | null>(null);
  const [carregando, setCarregando] = useState(false);
  const [resultado, setResultado] = useState<string | null>(null);

  function onFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      const dataUrl = reader.result as string;
      setPreview(dataUrl);
      setImagemB64(dataUrl.split(',')[1] ?? null);
    };
    reader.readAsDataURL(file);
  }

  async function analisar() {
    if (!texto.trim() && !imagemB64) return;
    setCarregando(true);
    setResultado(null);
    try {
      const r = await analisarIA(tipo, texto, imagemB64 ?? undefined);
      setResultado(r);
      add({ tipo, entrada: texto || '(imagem)', resposta: r, comImagem: !!imagemB64 });
    } catch {
      setResultado('Não foi possível conectar ao servidor de IA. Confirme que o backend (server.py) está rodando.');
    } finally {
      setCarregando(false);
    }
  }

  return (
    <div className="space-y-3">
      {!online && (
        <div className="flex items-center gap-2 rounded-xl bg-amber-50 px-3 py-2 text-xs text-amber-800">
          <WifiOff size={16} /> A análise por IA requer conexão com a internet.
        </div>
      )}

      <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
        {TIPOS.map((t) => (
          <button
            key={t.id}
            type="button"
            onClick={() => setTipo(t.id)}
            className={cx(
              'whitespace-nowrap rounded-full border px-3 py-1.5 text-xs font-medium transition',
              tipo === t.id ? 'border-transparent text-white' : 'border-black/10 bg-white text-gray-600',
            )}
            style={tipo === t.id ? { background: t.cor } : undefined}
          >
            {t.label}
          </button>
        ))}
      </div>

      <textarea
        value={texto}
        onChange={(e) => setTexto(e.target.value)}
        rows={3}
        placeholder="Descreva o problema, cole o programa ou o código do alarme..."
        className="w-full rounded-xl border border-black/10 bg-white px-3 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
      />

      <input ref={fileRef} type="file" accept="image/*" onChange={onFile} className="hidden" />
      {preview ? (
        <div className="relative overflow-hidden rounded-xl border border-black/10">
          <img src={preview} alt="prévia" className="max-h-52 w-full object-contain bg-gray-50" />
          <button
            type="button"
            onClick={() => {
              setPreview(null);
              setImagemB64(null);
              if (fileRef.current) fileRef.current.value = '';
            }}
            className="absolute right-2 top-2 rounded-full bg-black/60 p-1 text-white"
            aria-label="Remover imagem"
          >
            <X size={16} />
          </button>
        </div>
      ) : (
        <button
          type="button"
          onClick={() => fileRef.current?.click()}
          className="flex w-full items-center justify-center gap-2 rounded-xl border border-dashed border-black/20 bg-white py-3 text-sm font-medium text-gray-500"
        >
          <ImagePlus size={18} /> Adicionar foto
        </button>
      )}

      <button
        type="button"
        onClick={analisar}
        disabled={carregando || (!texto.trim() && !imagemB64)}
        className="flex w-full items-center justify-center gap-2 rounded-xl bg-cnc-amber py-3 text-sm font-bold text-cnc-dark disabled:opacity-50"
      >
        {carregando ? <Loader2 size={18} className="animate-spin" /> : <Sparkles size={18} />}
        {carregando ? 'Analisando...' : 'Analisar com IA'}
      </button>

      {resultado && (
        <div className="rounded-2xl border border-black/[0.06] bg-white p-4 shadow-sm">
          <p className="mb-2 text-xs font-bold uppercase tracking-wide text-cnc-amberDark">Resultado</p>
          <p className="whitespace-pre-wrap text-sm leading-relaxed text-gray-700">{resultado}</p>
        </div>
      )}
    </div>
  );
}

function AbaHistorico() {
  const historico = useIAStore((s) => s.historico);
  const limpar = useIAStore((s) => s.limpar);

  if (historico.length === 0)
    return <EmptyState icon={Sparkles} title="Sem análises ainda" subtitle="Suas análises por IA ficam salvas aqui." />;

  return (
    <div className="space-y-2">
      <div className="flex justify-end">
        <button type="button" onClick={limpar} className="flex items-center gap-1 text-xs text-gray-400 hover:text-cnc-red">
          <Trash2 size={14} /> Limpar
        </button>
      </div>
      {historico.map((h) => {
        const cor = TIPOS.find((t) => t.id === h.tipo)?.cor ?? '#185FA5';
        return (
          <details key={h.id} className="rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm">
            <summary className="flex cursor-pointer items-center gap-2">
              <Badge color={cor}>{TIPOS.find((t) => t.id === h.tipo)?.label ?? h.tipo}</Badge>
              <span className="min-w-0 flex-1 truncate text-sm text-gray-700">{h.entrada}</span>
              <span className="shrink-0 text-[11px] text-gray-400">{tempoRelativo(h.data)}</span>
            </summary>
            <p className="mt-2 whitespace-pre-wrap border-t border-black/[0.05] pt-2 text-sm leading-relaxed text-gray-600">
              {h.resposta}
            </p>
          </details>
        );
      })}
    </div>
  );
}
