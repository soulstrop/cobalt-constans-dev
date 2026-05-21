// worker/src/index.ts
export interface Env {
  STAGING_ASSETS: Fetcher;
  STAGING_USER: string;
  STAGING_PASS: string;
}

export default {
  async fetch(req: Request, env: Env, _ctx: ExecutionContext) {
    const url = new URL(req.url);

    // Staging: gated + noindex
    if (url.hostname === "staging.constans.dev") {
      const gate = checkBasicAuth(req, env);
      if (gate) return gate;

      const res = await env.STAGING_ASSETS.fetch(req);
      const headers = new Headers(res.headers);
      headers.set("X-Robots-Tag", "noindex, nofollow");
      return new Response(res.body, {
        status: res.status,
        statusText: res.statusText,
        headers,
      });
    }

    // Production: untouched pass-through to GH Pages (which serves its own 404.html)
    return fetch(req);
  },
};

function checkBasicAuth(req: Request, env: Env): Response | null {
  const auth = req.headers.get("Authorization") ?? "";
  const expected = "Basic " + btoa(`${env.STAGING_USER}:${env.STAGING_PASS}`);
  if (auth === expected) return null;
  return new Response("Authentication required", {
    status: 401,
    headers: { "WWW-Authenticate": 'Basic realm="staging"' },
  });
}
