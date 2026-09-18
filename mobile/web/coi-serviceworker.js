/* coi-serviceworker v0.1.7 - https://github.com/gzuidhof/coi-serviceworker */
/* License: MIT */

/* Injects Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy headers
   so that SharedArrayBuffer / WebAssembly.instantiate work on GitHub Pages. */

self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", (event) =>
  event.waitUntil(self.clients.claim())
);

async function handleFetch(request) {
  if (
    request.cache === "only-if-cached" &&
    request.mode !== "same-origin"
  ) {
    return;
  }

  const response = await fetch(request).catch((err) => {
    console.error("[coi-sw] fetch error:", err);
    throw err;
  });

  if (response.status === 0) {
    return response;
  }

  const newHeaders = new Headers(response.headers);
  newHeaders.set("Cross-Origin-Opener-Policy", "same-origin");
  newHeaders.set("Cross-Origin-Embedder-Policy", "require-corp");
  newHeaders.set("Cross-Origin-Resource-Policy", "cross-origin");

  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers: newHeaders,
  });
}

self.addEventListener("fetch", (event) => {
  event.respondWith(handleFetch(event.request));
});
