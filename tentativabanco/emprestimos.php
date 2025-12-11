<?php
include 'config.php';

// Buscar empréstimos com informações dos livros e membros
$sql = "SELECT 
            e.id_emprestimo,
            l.titulo,
            l.autor,
            m.nome as nome_membro,
            m.email as email_membro,
            e.data_emprestimo,
            e.data_devolucao_prevista,
            e.data_devolucao_real,
            CASE 
                WHEN e.data_devolucao_real IS NULL THEN 'Em aberto'
                ELSE 'Devolvido'
            END as status
        FROM Emprestimos e
        JOIN Livros l ON e.fk_id_livro = l.id_livro
        JOIN Membros m ON e.fk_id_membro = m.id_membro
        ORDER BY e.data_emprestimo DESC";

$result = $conn->query($sql);

if (!$result) {
    // Se houver erro na query, mostrar detalhes
    die(json_encode([
        "error" => "Erro na consulta SQL: " . $conn->error,
        "sql" => $sql
    ]));
}

$emprestimos = [];
while($row = $result->fetch_assoc()) {
    $emprestimos[] = $row;
}

// Se não houver empréstimos, retornar array vazio com mensagem
if (empty($emprestimos)) {
    $emprestimos = [
        "message" => "Nenhum empréstimo encontrado",
        "total" => 0
    ];
}

echo json_encode($emprestimos, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

$conn->close();
?>