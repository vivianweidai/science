import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://vivianweidai.com',
  trailingSlash: 'always',
  build: {
    format: 'directory',
  },
});
