<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'app' => 'Luis370 API',
        'status' => 'ok',
        'docs' => 'usa /api/* para los endpoints',
    ]);
});

// Diagnóstico temporal: ¿el driver mongodb tiene TLS/SSL? Borrar después.
Route::get('/diag', function () {
    ob_start();
    phpinfo(INFO_MODULES);
    $info = ob_get_clean();
    $tls = 'no encontrado';
    foreach (['libmongoc SSL', 'libmongoc crypto', 'SSL library version', 'crypto library'] as $needle) {
        if (preg_match('/' . preg_quote($needle, '/') . '.*$/mi', $info, $m)) {
            $tls = trim($m[0]);
            break;
        }
    }
    return response()->json([
        'mongodb_ext' => phpversion('mongodb'),
        'tls_line' => $tls,
        'openssl_ext' => extension_loaded('openssl'),
    ]);
});
