<?php
$host = "127.0.0.1";
$user = "root"; 
$password = "";
$database = "tentativaB1";  // ALTERADO AQUI

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("❌ Erro: " . $conn->connect_error);
}

echo "🎉 CONECTADO AO BANCO 'tentativaB1'!<br>";

// Ver tabelas
$result = $conn->query("SHOW TABLES");
echo "<h3>📊 Tabelas no banco 'tentativaB1':</h3>";
while($row = $result->fetch_array()) {
    echo "• " . $row[0] . "<br>";
}

// Ver dados de exemplo
echo "<h3>📖 Primeiros livros:</h3>";
$livros = $conn->query("SELECT * FROM Livros LIMIT 5");
while($livro = $livros->fetch_assoc()) {
    echo "📚 " . $livro['titulo'] . " - " . $livro['autor'] . "<br>";
}

$conn->close();
?>