/* West Trojan Run — service worker.
 *
 * This exists for one reason: to make the game installable and playable with no
 * signal (a phone in the stands at a game). It is deliberately NOT a
 * cache-everything worker.
 *
 * This project already has a history of stale copies looking identical to a
 * dead script, which is why the build flag exists at all. So the HTML is
 * ALWAYS network-first: online, you get the newest index.html every load,
 * exactly like before. The cache is only a fallback for when the network is
 * gone. Bump CACHE on every release so old entries are purged.
 */
var CACHE = 'wtr-1.9';

var ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icon-192.png',
  './icon-512.png',
  './icon-maskable-512.png',
  './apple-touch-icon.png'
];

self.addEventListener('install', function(e){
  e.waitUntil(
    caches.open(CACHE)
      // addAll is all-or-nothing; one 404 would abort the whole install and
      // leave the game with no offline copy. Cache what we can get.
      .then(function(c){
        return Promise.all(ASSETS.map(function(u){
          return c.add(new Request(u, {cache: 'reload'}))['catch'](function(){});
        }));
      })
      .then(function(){ return self.skipWaiting(); })
  );
});

self.addEventListener('activate', function(e){
  e.waitUntil(
    caches.keys()
      .then(function(keys){
        return Promise.all(keys.map(function(k){
          return k === CACHE ? null : caches['delete'](k);
        }));
      })
      .then(function(){ return self.clients.claim(); })
  );
});

self.addEventListener('message', function(e){
  if(e.data && e.data.type === 'SKIP_WAITING') self.skipWaiting();
});

function isHTML(req){
  if(req.mode === 'navigate') return true;
  var a = req.headers.get('accept') || '';
  return a.indexOf('text/html') !== -1;
}

self.addEventListener('fetch', function(e){
  var req = e.request;
  if(req.method !== 'GET') return;

  var url;
  try { url = new URL(req.url); } catch(err){ return; }
  if(url.origin !== self.location.origin) return;   // never touch third parties

  if(isHTML(req)){
    // Network first. A fresh build always wins when there is a connection.
    e.respondWith(
      fetch(req)
        .then(function(res){
          if(res && res.ok){
            var copy = res.clone();
            caches.open(CACHE).then(function(c){ c.put('./index.html', copy); });
          }
          return res;
        })
        ['catch'](function(){
          return caches.match('./index.html').then(function(hit){
            return hit || caches.match('./') ||
              new Response('<h1>Offline</h1><p>Open this once with a connection to install it.</p>',
                {headers: {'Content-Type': 'text/html'}});
          });
        })
    );
    return;
  }

  // Icons and the manifest: cache first, they change only on a release.
  e.respondWith(
    caches.match(req).then(function(hit){
      return hit || fetch(req).then(function(res){
        if(res && res.ok && res.type === 'basic'){
          var copy = res.clone();
          caches.open(CACHE).then(function(c){ c.put(req, copy); });
        }
        return res;
      });
    })
  );
});
