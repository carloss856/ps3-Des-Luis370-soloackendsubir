<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    // TEMP: marcador de build + captura del error real de la raíz.
    try {
        if (request()->boolean('whoami')) {
            return response()->json([
                'build' => 'b7',
                'session_driver' => config('session.driver'),
                'cache' => config('cache.default'),
                'mongo_db' => config('database.connections.mongodb.database'),
            ]);
        }
        return response()->json([
            'app' => 'Luis370 API',
            'status' => 'ok',
            'docs' => 'usa /api/* para los endpoints',
        ]);
    } catch (\Throwable $e) {
        return response()->json([
            'error' => $e->getMessage(),
            'where' => $e->getFile() . ':' . $e->getLine(),
        ], 500);
    }
});
