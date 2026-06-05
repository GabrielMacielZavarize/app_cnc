import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { VitePWA } from 'vite-plugin-pwa';
import { fileURLToPath, URL } from 'node:url';
// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        react(),
        VitePWA({
            registerType: 'autoUpdate',
            includeAssets: ['icon.svg', 'apple-touch-icon.png'],
            manifest: {
                name: 'CNCIA — Assistente CNC',
                short_name: 'CNCIA',
                description: 'Assistente industrial CNC: códigos G/M, alarmes, materiais, calculadora e IA.',
                lang: 'pt-BR',
                theme_color: '#1A1A2E',
                background_color: '#1A1A2E',
                display: 'standalone',
                orientation: 'portrait',
                icons: [
                    { src: 'pwa-192.png', sizes: '192x192', type: 'image/png' },
                    { src: 'pwa-512.png', sizes: '512x512', type: 'image/png' },
                    { src: 'pwa-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
                ],
            },
            workbox: {
                globPatterns: ['**/*.{js,css,html,svg,png,woff2}'],
                // Chamadas à IA (/api) nunca são servidas do cache — sempre vão à rede.
                navigateFallbackDenylist: [/^\/api/],
                maximumFileSizeToCacheInBytes: 4 * 1024 * 1024,
            },
        }),
    ],
    resolve: {
        alias: {
            '@': fileURLToPath(new URL('./src', import.meta.url)),
        },
    },
    server: {
        port: 5173,
        host: true,
        // Encaminha as chamadas de IA/backend para o FastAPI (server.py em :8000).
        // O front usa caminhos /api/... e o Vite reescreve para a raiz do backend.
        proxy: {
            '/api': {
                target: 'http://localhost:8000',
                changeOrigin: true,
                rewrite: function (path) { return path.replace(/^\/api/, ''); },
            },
        },
    },
});
