<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'app' => 'Luis370 API',
        'status' => 'ok',
        'docs' => 'usa /api/* para los endpoints',
    ]);
});
