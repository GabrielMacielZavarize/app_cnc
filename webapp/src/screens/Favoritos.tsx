import { useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Heart } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { Tabs } from '@/components/ui/Tabs';
import { Badge } from '@/components/ui/Badge';
import { EmptyState } from '@/components/ui/EmptyState';
import { todosCodigos } from '@/data/codigos';
import { todosAlarmes } from '@/data/alarmes';
import { corPorGravidade } from '@/theme/tokens';
import { useFavoritosStore } from '@/stores/favoritos';

export function Favoritos() {
  const [aba, setAba] = useState<'G' | 'M' | 'A'>('G');
  const navigate = useNavigate();

  const favCodigos = useFavoritosStore((s) => s.codigos);
  const favAlarmes = useFavoritosStore((s) => s.alarmes);
  const toggleCodigo = useFavoritosStore((s) => s.toggleCodigo);
  const toggleAlarme = useFavoritosStore((s) => s.toggleAlarme);

  const codigos = useMemo(
    () => favCodigos.map((c) => todosCodigos.find((x) => x.codigo === c)).filter((x) => x != null),
    [favCodigos],
  );
  const alarmes = useMemo(
    () => favAlarmes.map((a) => todosAlarmes.find((x) => x.codigo === a)).filter((x) => x != null),
    [favAlarmes],
  );

  const gFav = codigos.filter((c) => c!.isG);
  const mFav = codigos.filter((c) => !c!.isG);

  return (
    <>
      <TopBar title="Favoritos" subtitle="Códigos e alarmes salvos" icon={Heart} back />
      <div className="space-y-3 p-4">
        <Tabs
          tabs={[
            { key: 'G', label: 'Códigos G', count: gFav.length },
            { key: 'M', label: 'Códigos M', count: mFav.length },
            { key: 'A', label: 'Alarmes', count: alarmes.length },
          ]}
          active={aba}
          onChange={(k) => setAba(k as 'G' | 'M' | 'A')}
        />

        {aba !== 'A' &&
          (() => {
            const lista = aba === 'G' ? gFav : mFav;
            if (lista.length === 0)
              return <EmptyState icon={Heart} title="Nenhum favorito" subtitle="Toque no coração na Biblioteca para salvar." />;
            return (
              <div className="space-y-2">
                {lista.map((c) => (
                  <div
                    key={c!.codigo + c!.nome}
                    onClick={() => navigate(`/biblioteca?q=${encodeURIComponent(c!.codigo)}`)}
                    className="flex cursor-pointer items-center gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm"
                  >
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-2">
                        <span className="font-bold text-cnc-dark">{c!.codigo}</span>
                        <span className="truncate text-sm text-gray-700">{c!.nome}</span>
                      </div>
                      <p className="truncate text-xs text-gray-500">{c!.descricao}</p>
                    </div>
                    <button
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation();
                        toggleCodigo(c!.codigo);
                      }}
                      className="shrink-0 p-1"
                      aria-label="Remover favorito"
                    >
                      <Heart size={18} className="fill-cnc-red text-cnc-red" />
                    </button>
                  </div>
                ))}
              </div>
            );
          })()}

        {aba === 'A' &&
          (alarmes.length === 0 ? (
            <EmptyState icon={Heart} title="Nenhum alarme favoritado" subtitle="Toque no coração em Alarmes para salvar." />
          ) : (
            <div className="space-y-2">
              {alarmes.map((a) => {
                const cor = corPorGravidade(a!.gravidade);
                return (
                  <div
                    key={a!.codigo + a!.titulo}
                    onClick={() => navigate(`/alarmes?q=${encodeURIComponent(a!.codigo)}`)}
                    className="flex cursor-pointer items-center gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm"
                  >
                    <div className="w-1 self-stretch rounded-full" style={{ background: cor }} />
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-2">
                        <span className="font-mono font-bold text-cnc-dark">{a!.codigo}</span>
                        <Badge color={cor}>{a!.gravidade}</Badge>
                      </div>
                      <p className="truncate text-sm text-gray-700">{a!.titulo}</p>
                    </div>
                    <button
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation();
                        toggleAlarme(a!.codigo);
                      }}
                      className="shrink-0 p-1"
                      aria-label="Remover favorito"
                    >
                      <Heart size={18} className="fill-cnc-red text-cnc-red" />
                    </button>
                  </div>
                );
              })}
            </div>
          ))}
      </div>
    </>
  );
}
