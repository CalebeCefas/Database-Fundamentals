-- ========================
-- PARTE 1: Remoção de Tabelas Existentes
-- ========================
DROP TABLE IF EXISTS produtos;   -- Remove a tabela produtos, caso exista
DROP TABLE IF EXISTS marcas;     -- Remove a tabela marcas, caso exista
DROP TABLE IF EXISTS controle;   -- Remove a tabela controle, caso exista

-- ========================
-- PARTE 2: Criação das Tabelas de Produtos
-- ========================
CREATE TABLE marcas (
    id INT AUTO_INCREMENT PRIMARY KEY,              -- ID da marca, chave primária e autoincremento
    nome VARCHAR(100) NOT NULL UNIQUE,              -- Nome da marca (único e obrigatório)
    site VARCHAR(100),                              -- Site da marca (opcional)
    telefone VARCHAR(15)                            -- Telefone de contato (opcional)
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,              -- ID do produto, chave primária e autoincremento
    nome VARCHAR(100) NOT NULL,                     -- Nome do produto (obrigatório)
    preco DECIMAL(10,2),                            -- Preço do produto
    estoque INT DEFAULT 0,                          -- Quantidade disponível em estoque
    id_marca INT NOT NULL,                          -- ID da marca do produto (chave estrangeira)
    FOREIGN KEY (id_marca) REFERENCES marcas(id)    -- Define a relação com a tabela marcas
);

CREATE TABLE controle (
    id INT AUTO_INCREMENT PRIMARY KEY,              -- ID de controle, chave primária e autoincremento
    data_entrada DATE                               -- Data de entrada de produtos
);

-- ========================
-- PARTE 3: Inserção de Dados nas Tabelas marcas e produtos
-- ========================
INSERT INTO marcas (nome, site, telefone) VALUES
    ('Apple', 'apple.com', '0800-761-0867'),
    ('Dell', 'Dell.com.br', '0800-970-0867'),
    ('Herman Miller', 'hermanmiller.com.br', '(11) 3473-0843'),
    ('Shure', 'shure.com', '0800-761-3355');

INSERT INTO produtos (nome, preco, estoque, id_marca) VALUES
    ('iPhone 15 Pro', 8999.90, 12, 1),
    ('MacBook Air M2', 10999.00, 5, 1),
    ('Notebook Dell XPS 13', 8499.99, 8, 2),
    ('Monitor Dell UltraSharp 27"', 2799.00, 15, 2),
    ('Cadeira Aeron', 12800.00, 3, 3),
    ('Cadeira Sayl', 6500.00, 6, 3),
    ('Microfone Shure SM7B', 2899.90, 20, 4),
    ('Fone Shure SE215', 1199.00, 30, 4);

-- ========================
-- PARTE 4: Tabela temporária para produtos Apple
-- ========================
CREATE TABLE produtos_apple (
    nome VARCHAR(150) NOT NULL,
    estoque INT DEFAULT 0
);

INSERT INTO produtos_apple
SELECT nome, estoque FROM produtos WHERE id_marca = 1;  -- Copia os produtos da Apple para a tabela temporária

SELECT * FROM produtos_apple;  -- Visualiza os produtos Apple

DROP TABLE produtos_apple;     -- Remove a tabela temporária

-- ========================
-- PARTE 5: Atualizações e exclusões
-- ========================
UPDATE produtos
SET nome = 'Microfone Shure SM7B Preto'
WHERE id = 7;  -- Altera o nome do produto de ID 7

UPDATE produtos
SET estoque = estoque + 10
WHERE id_marca = 1;  -- Adiciona 10 unidades no estoque de todos os produtos da marca Apple

DELETE FROM produtos
WHERE id = 1;  -- Exclui o produto com ID 1 (iPhone 15 Pro)

-- ========================
-- PARTE 6: Consultas diversas com SELECT
-- ========================
SELECT * FROM produtos
WHERE estoque < 4 AND preco > 1000;  -- Produtos com pouco estoque e alto valor

SELECT * FROM produtos
WHERE nome LIKE '%iPhone%';  -- Busca por produtos com "iPhone" no nome

SELECT * FROM produtos
ORDER BY estoque ASC
LIMIT 2;  -- Retorna os 2 produtos com menor estoque

-- ========================
-- PARTE 7: Criação de clientes, pedidos e itens do pedido
-- ========================
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    cidade VARCHAR(100),
    data_nascimento DATE
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    valor_total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE TABLE itens_pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

-- ========================
-- PARTE 8: Inserção de dados em clientes, pedidos e itens
-- ========================
INSERT INTO clientes (nome, email, cidade, data_nascimento) VALUES
('Ana Silva', 'ana.silva@email.com', 'São Paulo', '1990-05-12'),
('Bruno Costa', 'bruno.costa@email.com', 'Rio de Janeiro', '1985-11-23'),
('Carla Souza', 'carla.souza@email.com', 'Belo Horizonte', '1992-07-07'),
('Diego Santos', 'diego.santos@email.com', 'Curitiba', '1988-02-28'),
('Elisa Ferreira', 'elisa.ferreira@email.com', 'Fortaleza', '1995-09-15');

INSERT INTO pedidos (data_pedido, id_cliente, valor_total) VALUES
('2025-07-20', 1, 149.80),
('2025-07-21', 2, 179.80),
('2025-07-22', 3, 89.90),
('2025-07-22', 1, 59.80),
('2025-07-23', 5, 149.90);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 49.90),
(1, 4, 1, 29.90),
(2, 3, 1, 149.90),
(2, 5, 1, 89.90),
(3, 5, 1, 89.90),
(4, 2, 1, 99.90),
(4, 4, 1, 29.90),
(5, 3, 1, 149.90);

-- ========================
-- PARTE 9: Consultas com JOIN e agregações
-- ========================

-- Produtos de marcas específicas (Apple, Dell, Herman Miller, Shure)
SELECT nome, preco
FROM produtos
WHERE id_marca IN (SELECT id FROM marcas WHERE nome IN ('Apple', 'Dell'))
UNION
SELECT nome, preco
FROM produtos
WHERE id_marca IN (SELECT id FROM marcas WHERE nome IN ('Herman Miller', 'Shure'));
-- Consulta que retorna produtos cujas marcas estão entre as listadas. Usa UNION para combinar duas consultas.

-- Contagem de clientes por cidade
SELECT cidade, COUNT(*) AS total_clientes
FROM clientes
GROUP BY cidade;
-- Agrupa os clientes por cidade e conta quantos existem em cada uma.

-- Média de valor dos pedidos por mês
SELECT DATE_FORMAT(data_pedido, '%Y-%m') AS mes, AVG(valor_total) AS media_valor
FROM pedidos
GROUP BY mes;
-- Agrupa os pedidos por ano-mês e calcula a média do valor total em cada mês.

-- Média do valor total de todos os pedidos
SELECT SUM(valor_total)/COUNT(valor_total)
FROM pedidos;
-- Calcula a média manualmente dividindo a soma pelo total de pedidos (alternativa ao AVG).

-- Maior e menor valor total de pedidos
SELECT MAX(valor_total) AS maior_valor, MIN(valor_total) AS menor_valor
FROM pedidos;
-- Mostra o maior e menor valor total entre os pedidos feitos.

-- Produtos com estoque abaixo da média
SELECT nome, estoque
FROM produtos
WHERE estoque < (SELECT AVG(estoque) FROM produtos);
-- Compara o estoque de cada produto com a média geral e retorna os que têm menos do que essa média.

-- Total de vendas por cidade com filtro de valor
SELECT c.cidade, SUM(p.valor_total) AS total_vendas
FROM clientes AS c
INNER JOIN pedidos AS p ON c.id = p.id_cliente
WHERE c.cidade IN ('São Paulo', 'Rio de Janeiro')
GROUP BY c.cidade
HAVING total_vendas < 1000;
-- Junta clientes e pedidos, soma os valores por cidade (apenas SP e RJ) e retorna aquelas com vendas abaixo de R$1000.
