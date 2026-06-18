<?php
// Router para el servidor embebido de PHP (php -S). Sirve archivos estáticos
// de /public y enruta el resto a public/index.php (front controller de Laravel).
$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

if ($uri !== '/' && file_exists(__DIR__.'/public'.$uri)) {
    return false; // deja que php -S sirva el archivo estático
}

$_SERVER['SCRIPT_NAME'] = '/index.php';
require_once __DIR__.'/public/index.php';
