import { Search, X } from 'lucide-react';

interface SearchBarProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  autoFocus?: boolean;
}

export function SearchBar({ value, onChange, placeholder, autoFocus }: SearchBarProps) {
  return (
    <div className="flex items-center gap-2 rounded-xl bg-white border border-black/[0.08] px-3 py-2.5 shadow-sm">
      <Search size={18} className="shrink-0 text-gray-400" />
      <input
        // eslint-disable-next-line jsx-a11y/no-autofocus
        autoFocus={autoFocus}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="min-w-0 flex-1 bg-transparent text-sm text-cnc-dark placeholder:text-gray-400 outline-none"
      />
      {value && (
        <button
          type="button"
          onClick={() => onChange('')}
          className="shrink-0 text-gray-400 hover:text-gray-600"
          aria-label="Limpar"
        >
          <X size={16} />
        </button>
      )}
    </div>
  );
}
