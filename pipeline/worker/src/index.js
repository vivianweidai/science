// Pass-through Worker for vivianweidai.com static site.
// Astro builds to ../../dist/; Cloudflare Static Assets serves it.
//
// Backwards-compat rewrite: /archives/layout/* now lives at /content/layout/*
// after the convention cleanup. Existing inbound links keep working by
// internally serving the new location. Note: /archives/truth/* is NOT
// rewritten — the Apple/Android apps fetch those via raw.githubusercontent.com,
// so the source files stay canonical at archives/truth/.
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname.startsWith('/archives/layout/')) {
      const rewritten = new URL(request.url);
      rewritten.pathname = '/content/layout/' + url.pathname.slice('/archives/layout/'.length);
      return env.ASSETS.fetch(new Request(rewritten, request));
    }
    return env.ASSETS.fetch(request);
  },
};
