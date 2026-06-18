<?php

use Illuminate\Support\Facades\Route;

// Portada del API. Las rutas reales viven en routes/api.php (/api/*).
// Nota: si SESSION_DRIVER no es 'cookie'/'array', el middleware web de Laravel
// intenta escribir sesión en disco/BD y esta ruta puede dar 500 en Render.
Route::get('/', function () {
    return response()->json([
        'app' => 'Luis370 API',
        'status' => 'ok',
        'docs' => 'usa /api/* para los endpoints',
    ]);
});
