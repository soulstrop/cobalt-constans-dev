/ worker/src/index.ts
export default {
  async fetch(req: Request, env: Env, ctx: ExecutionContext) {
    const url = new URL(req.url);

    if (url.hostname === "staging.constans.dev") {
      // 1. Gate
      const gate = checkBasicAuth(req, env);
      if (gate) return gate;

      // 2. Serve from bundled assets
      const res = await env.STAGING_ASSETS.fetch(req);

      // 3. Stamp noindex on every response
      const headers = new Headers(res.headers);
      headers.set("X-Robots-Tag", "noindex, nofollow");
      return new Response(res.body, { status: res.status, headers });
    }

    // Production: pass through to GH Pages origin, with custom 404
    const res = await fetch(req);
    if (res.status === 404) {
      // Serve your styled 404 (could also live in assets)
      return new Response(await get404Html(), {
        status: 404,
        headers: { "content-type": "text/html; charset=utf-8" },
      });
    }
    return res;
  },
};

function checkBasicAuth(req: Request, env: Env): Response | null {
  const auth = req.headers.get("Authorization") || "";
  const expected = "Basic " + btoa(`${env.STAGING_USER}:${env.STAGING_PASS}`);
  if (auth === expected) return null;
  return new Response("Auth required", {
    status: 401,
    headers: { "WWW-Authenticate": 'Basic realm="staging"' },
  });
}
