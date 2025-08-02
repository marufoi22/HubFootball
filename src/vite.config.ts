import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  build: {
    // manifest: true,
    manifest: 'manifest.json', 
    outDir: path.resolve(__dirname, '../wwwroot/js'),
    emptyOutDir: true,
    rollupOptions: {
      input: 'src/main.ts'
    }
  }
})