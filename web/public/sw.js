/* Cleanup service worker to remove stale registrations and caches. */
self.addEventListener("install", (event) => {
  self.skipWaiting();
  event.waitUntil(Promise.resolve());
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(keys.map((key) => caches.delete(key)));

      await self.registration.unregister();

      const clientsList = await self.clients.matchAll({
        includeUncontrolled: true,
        type: "window",
      });

      for (const client of clientsList) {
        client.navigate(client.url);
      }
    })()
  );
});
