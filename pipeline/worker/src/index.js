// Pass-through Worker for vivianweidai.com static site.
// Astro builds to ../../dist/; Cloudflare Static Assets serves it.
// All URLs match disk paths under content/, so no rewrites are needed.
export default {
  async fetch(request, env) {
    return env.ASSETS.fetch(request);
  },
};
