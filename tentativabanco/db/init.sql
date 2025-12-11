-- Inicializa banco tentativaB1 com tabelas e dados de exemplo

CREATE TABLE IF NOT EXISTS Livros (
  id_livro INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL,
  autor VARCHAR(255) NOT NULL,
  ano_publicacao INT DEFAULT NULL,
  disponivel TINYINT(1) DEFAULT 1
);

CREATE TABLE IF NOT EXISTS Membros (
  id_membro INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS Emprestimos (
  id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
  fk_id_livro INT NOT NULL,
  fk_id_membro INT NOT NULL,
  data_emprestimo DATETIME NOT NULL,
  data_devolucao_prevista DATETIME NOT NULL,
  data_devolucao_real DATETIME DEFAULT NULL,
  FOREIGN KEY (fk_id_livro) REFERENCES Livros(id_livro),
  FOREIGN KEY (fk_id_membro) REFERENCES Membros(id_membro)
);

-- Dados de exemplo
INSERT INTO Livros (titulo, autor, ano_publicacao, disponivel) VALUES
('1984', 'George Orwell', 1949, 1),
('Dom Casmurro', 'Machado de Assis', 1899, 1),
('Clean Code', 'Robert C. Martin', 2008, 1);

INSERT INTO Membros (nome, email) VALUES
('Ana Silva', 'ana@example.com'),
('João Pereira', 'joao@example.com');

-- Um empréstimo exemplo (devolução ainda não feita)
INSERT INTO Emprestimos (fk_id_livro, fk_id_membro, data_emprestimo, data_devolucao_prevista) VALUES
(1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY));
