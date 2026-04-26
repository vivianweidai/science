import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://vivianweidai.com',
  trailingSlash: 'always',
  // Tuck the build output inside pipeline/worker/ so it co-locates with
  // the Cloudflare Worker that serves it via the ASSETS binding.
  // Also keeps the root tree cleaner — no top-level dist/.
  outDir: './pipeline/worker/dist',
  build: {
    format: 'directory',
  },
});
