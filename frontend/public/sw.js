// tombstone SW: desregistra cualquier SW viejo y borra todas las caches.
// reemplaza versiones anteriores de next-pwa que dejaban precaches inválidos
// (chunks de builds previos → fetch 404 → reload loop → RAM explota).
// cuando reactives PWA, borrá este archivo y sacá la excepción del .gitignore.
self.addEventListener('install', () => {
  self.skipWaiting()
})

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const keys = await caches.keys()
    await Promise.all(keys.map((k) => caches.delete(k)))
    await self.registration.unregister()
    const clients = await self.clients.matchAll({ type: 'window' })
    clients.forEach((c) => c.navigate(c.url))
  })())
})

self.addEventListener('fetch', () => {})
