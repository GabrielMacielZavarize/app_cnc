import { type ReactNode } from 'react';

// Realce de sintaxe leve para blocos de código G/M (porta a coloração manual
// usada na biblioteca/programas do Flutter).
function classeToken(token: string): string {
  if (/^[Gg]\d/.test(token)) return 'text-blue-400';
  if (/^[Mm]\d/.test(token)) return 'text-emerald-400';
  if (/^[Nn]\d/.test(token)) return 'text-purple-300';
  if (/^[A-Za-z]/.test(token)) return 'text-amber-300';
  return 'text-gray-300';
}

function colorizeLinha(linha: string, baseKey: number): ReactNode[] {
  const out: ReactNode[] = [];
  const re = /(\([^)]*\)?)|(\S+)|(\s+)/g;
  let m: RegExpExecArray | null;
  let i = 0;
  while ((m = re.exec(linha)) !== null) {
    const key = `${baseKey}-${i++}`;
    if (m[1] !== undefined) {
      out.push(
        <span key={key} className="italic text-gray-500">
          {m[1]}
        </span>,
      );
    } else if (m[2] !== undefined) {
      out.push(
        <span key={key} className={classeToken(m[2])}>
          {m[2]}
        </span>,
      );
    } else {
      out.push(<span key={key}>{m[3]}</span>);
    }
  }
  return out;
}

export function GcodeView({ code }: { code: string }) {
  return (
    <pre className="overflow-x-auto whitespace-pre rounded-xl bg-cnc-dark px-3 py-3 font-mono text-[13px] leading-relaxed text-gray-200">
      {code.split('\n').map((linha, i) => (
        <div key={i}>{linha ? colorizeLinha(linha, i) : ' '}</div>
      ))}
    </pre>
  );
}
