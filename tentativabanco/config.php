<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');

// Ler credenciais do ambiente, com fallback para valores locais
$host = getenv('DB_HOST') ?: '127.0.0.1';
$port = getenv('DB_PORT') ?: '';
$user = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASS') ?: '';
$database = getenv('DB_NAME') ?: 'tentativaB1';

if ($port) {
    $conn = new mysqli($host, $user, $password, $database, intval($port));
} else {
    $conn = new mysqli($host, $user, $password, $database);
}

if ($conn->connect_error) {
    http_response_code(500);
    die(json_encode(["error" => "Conexão falhou: " . $conn->connect_error]));
}

$conn->set_charset("utf8mb4");
?>