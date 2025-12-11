<?php
include 'config.php';

// Buscar todos os membros
$sql = "SELECT * FROM Membros ORDER BY nome";
$result = $conn->query($sql);

$membros = [];
while($row = $result->fetch_assoc()) {
    $membros[] = $row;
}

echo json_encode($membros, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>