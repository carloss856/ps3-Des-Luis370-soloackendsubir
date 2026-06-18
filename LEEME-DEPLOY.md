# backendparasubir — Backend Luis370 listo para Render

Copia limpia del backend Laravel (sin `vendor`, `node_modules`, `.git`, `.env`, zips ni SQLite). Sube ESTA carpeta a un repo de GitHub y conéctala a Render.

## Pasos
1. **MongoDB Atlas**: cluster M0 (free) → DB user → Network Access `0.0.0.0/0` → copia el URI.
2. **APP_KEY**: ejecuta `php artisan key:generate --show` (en tu PC, dentro de esta carpeta tras `composer install`) y copia el valor.
3. **GitHub**: crea repo, sube todo el contenido de esta carpeta.
4. **Render** → New → **Blueprint** → elige el repo (lee `render.yaml`).
5. En Render, añade los **secretos** (Environment):
   - `APP_KEY` = base64:... (paso 2)
   - `APP_URL` = la URL que te da Render (ej. https://luis370-api.onrender.com)
   - `MONGO_DSN` = mongodb+srv://USER:PASS@cluster.../luis370Db?retryWrites=true&w=majority
6. Deploy. La URL final va en el frontend (`VITE_API_URL`).

## Ya configurado
- `Dockerfile`: PHP 8.3 + extensión `mongodb`.
- `render.yaml`: plan free + drivers seguros (`SESSION_DRIVER=cookie`, `CACHE_STORE=array`, `QUEUE_CONNECTION=sync`) → no chocan con Mongo.
- `config/cors.php`: permite `https://luis370.careilabs.store`.
- `.env.render`: plantilla de variables.

## Notas
- NO subas tu `.env` real (no está incluido a propósito).
- Render free duerme tras ~15 min sin uso (1er request lento). Normal.
- Si el frontend usa otro dominio, añádelo en `config/cors.php`.
