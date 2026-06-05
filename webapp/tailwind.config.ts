import type { Config } from 'tailwindcss';

// Tokens de cor espelhando lib/constants.dart do app Flutter original.
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        cnc: {
          dark: '#1A1A2E',   // kDark  — fundo escuro / app bar
          amber: '#E8A020',  // kAmber — cor de marca / destaque
          bg: '#F5F5F5',     // kBg    — fundo claro
          blue: '#185FA5',   // kBlue
          red: '#D94040',    // kRed
          green: '#0F6E56',  // kGreen
          amberDark: '#BA7517',
          redDark: '#A32D2D',
          purple: '#534AB7',
        },
      },
      fontFamily: {
        sans: ['Roboto', 'system-ui', 'Arial', 'sans-serif'],
        mono: ['"Roboto Mono"', 'ui-monospace', 'SFMono-Regular', 'monospace'],
      },
    },
  },
  plugins: [],
} satisfies Config;
