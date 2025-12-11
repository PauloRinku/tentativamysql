-- Dump SQL gerado para importar o schema e dados do projeto
-- Inclui CREATE DATABASE e USE

CREATE DATABASE IF NOT EXISTS `tentativaB1` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `tentativaB1`;

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for `Livros`
-- ----------------------------
DROP TABLE IF EXISTS `Livros`;
CREATE TABLE `Livros` (
  `id_livro` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `autor` varchar(255) NOT NULL,
  `ano_publicacao` int DEFAULT NULL,
  `disponivel` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id_livro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for `Membros`
-- ----------------------------
DROP TABLE IF EXISTS `Membros`;
CREATE TABLE `Membros` (
  `id_membro` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for `Emprestimos`
-- ----------------------------
DROP TABLE IF EXISTS `Emprestimos`;
CREATE TABLE `Emprestimos` (
  `id_emprestimo` int NOT NULL AUTO_INCREMENT,
  `fk_id_livro` int NOT NULL,
  `fk_id_membro` int NOT NULL,
  `data_emprestimo` datetime NOT NULL,
  `data_devolucao_prevista` datetime NOT NULL,
  `data_devolucao_real` datetime DEFAULT NULL,
  PRIMARY KEY (`id_emprestimo`),
  KEY `fk_livro_idx` (`fk_id_livro`),
  KEY `fk_membro_idx` (`fk_id_membro`),
  CONSTRAINT `fk_emprestimos_livros` FOREIGN KEY (`fk_id_livro`) REFERENCES `Livros` (`id_livro`),
  CONSTRAINT `fk_emprestimos_membros` FOREIGN KEY (`fk_id_membro`) REFERENCES `Membros` (`id_membro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- Data for table `Livros`
-- ----------------------------
INSERT INTO `Livros` (`id_livro`, `titulo`, `autor`, `ano_publicacao`, `disponivel`) VALUES
(1, '1984', 'George Orwell', 1949, 1),
(2, 'Dom Casmurro', 'Machado de Assis', 1899, 1),
(3, 'Clean Code', 'Robert C. Martin', 2008, 1);

-- ----------------------------
-- Data for table `Membros`
-- ----------------------------
INSERT INTO `Membros` (`id_membro`, `nome`, `email`) VALUES
(1, 'Ana Silva', 'ana@example.com'),
(2, 'João Pereira', 'joao@example.com');

-- ----------------------------
-- Data for table `Emprestimos`
-- ----------------------------
INSERT INTO `Emprestimos` (`id_emprestimo`, `fk_id_livro`, `fk_id_membro`, `data_emprestimo`, `data_devolucao_prevista`, `data_devolucao_real`) VALUES
(1, 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), NULL);

-- End of dump
