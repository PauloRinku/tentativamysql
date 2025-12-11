<?php
include 'config.php';  // Já usa tentativaB1

echo "<h1>Verificando Empréstimos no Banco</h1>";

// Verificar se a tabela Emprestimos existe
$result = $conn->query("SHOW TABLES LIKE 'Emprestimos'");
if ($result->num_rows == 0) {
    die("❌ A tabela Emprestimos NÃO existe!");
}
echo "✅ Tabela Emprestimos existe<br>";

// Verificar quantos empréstimos existem
$result = $conn->query("SELECT COUNT(*) as total FROM Emprestimos");
$row = $result->fetch_assoc();
echo "📊 Total de empréstimos: " . $row['total'] . "<br>";

// Verificar a estrutura da tabela
$result = $conn->query("DESCRIBE Emprestimos");
echo "<h3>Estrutura da tabela Emprestimos:</h3>";
while($row = $result->fetch_assoc()) {
    echo "• {$row['Field']} - {$row['Type']}<br>";
}

// Mostrar alguns empréstimos
$result = $conn->query("SELECT * FROM Emprestimos LIMIT 5");
echo "<h3>Primeiros 5 empréstimos:</h3>";
while($row = $result->fetch_assoc()) {
    echo "ID: {$row['id_emprestimo']} | Livro: {$row['fk_id_livro']} | Membro: {$row['fk_id_membro']} | Data: {$row['data_emprestimo']}<br>";
}

$conn->close();
?>