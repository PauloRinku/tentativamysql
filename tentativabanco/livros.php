<?php
include 'config.php';

// Buscar todos os livros
$sql = "SELECT * FROM Livros ORDER BY titulo";
$result = $conn->query($sql);

$livros = [];
while($row = $result->fetch_assoc()) {
    $livros[] = $row;
}

echo json_encode($livros, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>