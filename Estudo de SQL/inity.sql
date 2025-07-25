DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS marcas;
DROP TABLE IF EXISTS controle;

CREATE TABLE marcas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    site VARCHAR(100),
    telefone VARCHAR(15)
);

CREATE TABLE produtos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2),
    estoque INT DEFAULT 0,
    id_marca INT NOT NULL,
    FOREIGN KEY (id_marca) REFERENCES marcas(id)
);

CREATE TABLE controle (
    id INT IDENTITY(1,1) PRIMARY KEY,
    data_entrada DATE
);


INSERT INTO marcas
    (nome, site, telefone)
VALUES
    ('Apple', 'apple.com', '0800-761-0867'),
    ('Dell', 'Dell.com.br', '0800-970-0867'),
    ('Herman Miller', 'hermanmiller.com.br', '(11) 3473-0843'),
    ('Shure', 'shure.com', '0800-761-3355');

INSERT INTO produtos 
    (nome, preco, estoque, id_marca)
VALUES
    ('iPhone 15 Pro', 8999.90, 12, 1),                -- Apple
    ('MacBook Air M2', 10999.00, 5, 1),               -- Apple
    ('Notebook Dell XPS 13', 8499.99, 8, 2),          -- Dell
    ('Monitor Dell UltraSharp 27"', 2799.00, 15, 2),  -- Dell
    ('Cadeira Aeron', 12800.00, 3, 3),                -- Herman Miller
    ('Cadeira Sayl', 6500.00, 6, 3),                  -- Herman Miller
    ('Microfone Shure SM7B', 2899.90, 20, 4),         -- Shure
    ('Fone Shure SE215', 1199.00, 30, 4);             -- Shure


CREATE TABLE produtos_apple (
    nome VARCHAR(150) NOT NULL,
    estoque INT DEFAULT 0
);


INSERT INTO produtos_apple
SELECT nome, estoque FROM produtos WHERE id_marca = 1;


SELECT * FROM produtos_apple;


DROP TABLE produtos_apple; 


UPDATE produtos
SET nome = 'Microfone Shure SM7B Preto'
WHERE id = 7;


UPDATE produtos
SET estoque = estoque + 10
WHERE id_marca = 1;


DELETE FROM produtos
WHERE id = 1;  -- Exclui o iPhone 15 Pro

SELECT *
FROM produtos
WHERE estoque < 4 AND preco > 1000;


SELECT *
FROM produtos
WHERE nome LIKE '%iPhone%';


SELECT *
from produtos
ORDER BY estoque ASC
LIMIT 2;


CREATE TABLE clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    cidade VARCHAR(100),
    data_nascimento DATE
);

CREATE TABLE pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    data_pedido DATE DEFAULT (NOW()),
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


-- Clientes
INSERT INTO clientes (nome, email, cidade, data_nascimento) VALUES
('Ana Silva', 'ana.silva@email.com', 'São Paulo', '1990-05-12'),
('Bruno Costa', 'bruno.costa@email.com', 'Rio de Janeiro', '1985-11-23'),
('Carla Souza', 'carla.souza@email.com', 'Belo Horizonte', '1992-07-07'),
('Diego Santos', 'diego.santos@email.com', 'Curitiba', '1988-02-28'),
('Elisa Ferreira', 'elisa.ferreira@email.com', 'Fortaleza', '1995-09-15');

-- Pedidos
INSERT INTO pedidos (data_pedido, id_cliente, valor_total) VALUES
('2025-07-20', 1, 149.80),
('2025-07-21', 2, 179.80),
('2025-07-22', 3, 89.90),
('2025-07-22', 1, 59.80),
('2025-07-23', 5, 149.90);

-- Itens Pedido
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 49.90),  -- Ana comprou 2 camisetas
(1, 4, 1, 29.90),  -- Ana comprou 1 boné
(2, 3, 1, 149.90), -- Bruno comprou 1 tênis
(2, 5, 1, 89.90),  -- Bruno comprou 1 mochila
(3, 5, 1, 89.90),  -- Carla comprou 1 mochila
(4, 2, 1, 99.90),  -- Ana comprou 1 calça jeans
(4, 4, 1, 29.90),  -- Ana comprou 1 boné
(5, 3, 1, 149.90); -- Elisa comprou 1 tênis


SELECT
    clientes.nome,
    pedidos
FROM
    clientes
    INNER JOIN pedidos ON clientes.id = pedidos.id_clientes;


SELECT
    nome, preco
FROM
    produtos
WHERE
    id_marca IN (SELECT id FROM marcas WHERE nome = 'Apple' OR nome = 'Dell')

UNION

SELECT
    nome, preco
FROM
    produtos
WHERE
    id_marca IN (SELECT id FROM marcas WHERE nome = 'Herman Miller' OR nome = 'Shure')


SELECT
    cidade
    COUNT(*) AS total_clientes
FROM
    clientes
GROUP BY
    cidade


SELECT
    DATE_FORMAT(data_pedido, 'yyyy-MM') AS mes,
    AVG(valor_total) AS media_valor
FROM
    pedidos
GROUP BY mes


SELECT SUM(valor_total)/COUNT(valor_total)
FROM pedidos


SELECT MAX(valor_total) AS maior_valor, MIN(valor_total) AS menor_valor
FROM pedidos;


SELECT
    nome,
    estoque
FROM
    produtos
WHERE
    estoque < (SELECT AVG(estoque) FROM produtos)


SELECT
    c.cidade,
    SUM(p.valor_total) AS total_vendas
FROM
    clientes AS c