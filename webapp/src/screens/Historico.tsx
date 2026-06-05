import { useState } from 'react';
import { History, Plus, StickyNote, Trash2 } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { Tabs } from '@/components/ui/Tabs';
import { Badge } from '@/components/ui/Badge';
import { EmptyState } from '@/components/ui/EmptyState';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Field } from '@/components/ui/Field';
import { useHistoricoStore, type NotaPessoal } from '@/stores/historico';
import { corPorTipo } from '@/theme/tokens';
import { tempoRelativo } from '@/lib/format';

const CORES = ['#E8A020', '#185FA5', '#0F6E56', '#A32D2D', '#534AB7'];

export function Historico() {
  const [aba, setAba] = useState('historico');
  const historico = useHistoricoStore((s) => s.historico);
  const notas = useHistoricoStore((s) => s.notas);

  return (
    <>
      <TopBar title="Histórico & Notas" subtitle="Seu uso do app" icon={History} back />
      <div className="space-y-3 p-4">
        <Tabs
          tabs={[
            { key: 'historico', label: 'Histórico', count: historico.length },
            { key: 'notas', label: 'Notas', count: notas.length },
          ]}
          active={aba}
          onChange={setAba}
        />
        {aba === 'historico' ? <AbaHistorico /> : <AbaNotas />}
      </div>
    </>
  );
}

function AbaHistorico() {
  const historico = useHistoricoStore((s) => s.historico);
  const limpar = useHistoricoStore((s) => s.limparHistorico);

  if (historico.length === 0)
    return <EmptyState icon={History} title="Nenhuma consulta ainda" subtitle="Códigos, alarmes e materiais que você abrir aparecem aqui." />;

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between px-1">
        <span className="text-xs text-gray-400">{historico.length} consultas</span>
        <button type="button" onClick={limpar} className="text-xs text-gray-400 hover:text-cnc-red">
          Limpar tudo
        </button>
      </div>
      {historico.map((h) => {
        const cor = corPorTipo(h.tipo);
        return (
          <div key={h.id} className="flex items-center gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm">
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-medium text-cnc-dark">{h.titulo}</p>
              <div className="mt-0.5 flex items-center gap-2">
                <Badge color={cor}>{h.tipo}</Badge>
                <span className="text-[11px] text-gray-400">{tempoRelativo(h.data)}</span>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}

function AbaNotas() {
  const notas = useHistoricoStore((s) => s.notas);
  const addNota = useHistoricoStore((s) => s.addNota);
  const editarNota = useHistoricoStore((s) => s.editarNota);
  const deletarNota = useHistoricoStore((s) => s.deletarNota);

  const [edicao, setEdicao] = useState<NotaPessoal | 'nova' | null>(null);
  const [titulo, setTitulo] = useState('');
  const [conteudo, setConteudo] = useState('');
  const [cor, setCor] = useState(CORES[0]);

  function abrirNova() {
    setEdicao('nova');
    setTitulo('');
    setConteudo('');
    setCor(CORES[0]);
  }
  function abrirEdicao(n: NotaPessoal) {
    setEdicao(n);
    setTitulo(n.titulo);
    setConteudo(n.conteudo);
    setCor(n.cor);
  }
  function salvar() {
    if (!titulo.trim()) return;
    if (edicao === 'nova') addNota({ titulo, conteudo, cor });
    else if (edicao) editarNota(edicao.id, titulo, conteudo);
    setEdicao(null);
  }

  return (
    <>
      <button
        type="button"
        onClick={abrirNova}
        className="flex w-full items-center justify-center gap-2 rounded-xl bg-cnc-dark py-2.5 text-sm font-semibold text-white"
      >
        <Plus size={18} /> Nova nota
      </button>

      {notas.length === 0 ? (
        <EmptyState icon={StickyNote} title="Nenhuma nota ainda" subtitle="Guarde offsets, zero-peças e dicas pessoais." />
      ) : (
        <div className="mt-3 space-y-2">
          {notas.map((n) => (
            <div
              key={n.id}
              onClick={() => abrirEdicao(n)}
              className="cursor-pointer rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm"
              style={{ borderLeft: `4px solid ${n.cor}` }}
            >
              <div className="flex items-center justify-between">
                <p className="text-sm font-semibold text-cnc-dark">{n.titulo}</p>
                <span className="text-[11px] text-gray-400">{tempoRelativo(n.data)}</span>
              </div>
              {n.conteudo && <p className="mt-1 line-clamp-3 whitespace-pre-wrap text-xs text-gray-600">{n.conteudo}</p>}
            </div>
          ))}
        </div>
      )}

      <BottomSheet open={edicao !== null} onClose={() => setEdicao(null)} title={edicao === 'nova' ? 'Nova nota' : 'Editar nota'}>
        <div className="space-y-3">
          <Field label="Título" value={titulo} onChange={setTitulo} placeholder="Ex.: Zero-peça torno 2" />
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-gray-500">Conteúdo</span>
            <textarea
              value={conteudo}
              onChange={(e) => setConteudo(e.target.value)}
              rows={4}
              placeholder="Ex.: G54 X=-250.5, broca Ø8mm F=0.05..."
              className="w-full rounded-xl border border-black/10 bg-white px-3 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
            />
          </label>
          <div className="flex items-center gap-2">
            <span className="text-xs text-gray-500">Cor:</span>
            {CORES.map((c) => (
              <button
                key={c}
                type="button"
                onClick={() => setCor(c)}
                className="h-6 w-6 rounded-full"
                style={{ background: c, outline: cor === c ? '2px solid #1A1A2E' : 'none', outlineOffset: 2 }}
                aria-label={`Cor ${c}`}
              />
            ))}
          </div>
          <div className="flex gap-2">
            <button type="button" onClick={salvar} className="flex-1 rounded-xl bg-cnc-dark py-3 text-sm font-semibold text-white">
              Salvar
            </button>
            {edicao !== 'nova' && edicao && (
              <button
                type="button"
                onClick={() => {
                  deletarNota(edicao.id);
                  setEdicao(null);
                }}
                className="flex items-center justify-center rounded-xl bg-cnc-red/10 px-4 text-cnc-red"
                aria-label="Excluir nota"
              >
                <Trash2 size={18} />
              </button>
            )}
          </div>
        </div>
      </BottomSheet>
    </>
  );
}
