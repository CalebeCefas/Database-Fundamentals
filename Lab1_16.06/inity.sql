CREATE TABLE produto(
    codigo INT PRIMARY KEY,
    nome VARCHAR(100),
    descricao VARCHAR(255)
);


CREATE TABLE cliente(
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100),
    end_estado CHAR(2),
    end_cidade VARCHAR(255),
    end_bairro VARCHAR(255),
    end_rua VARCHAR(255),
    end_num INT
);

CREATE TABLE atendimento(
    protocolo INT IDENTITY(1,1) PRIMARY KEY,
    situacao VARCHAR(10),
    data_atendimento DATETIME,
    titulo VARCHAR(100),
    descricao VARCHAR(255),
    cpf_cliente CHAR(11) NOT NULL,
    FOREIGN KEY(cpf_cliente) REFERENCES cliente(cpf) ON DELETE CASCADE
);

CREATE TABLE telefone_cliente(
    cliente_cpf CHAR(11),
    telefone CHAR(11),
    FOREIGN KEY(cliente_cpf) REFERENCES cliente(cpf) ON DELETE CASCADE
);

CREATE TABLE cliente_compra_produto(
    cpf_cliente CHAR(11),
    codigo_produto INT,
    data_compra DATE NOT NULL,
    PRIMARY KEY(cpf_cliente, codigo_produto, data_compra),
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE CASCADE,
    FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
);


INSERT INTO produto(Codigo, nome, descricao ) values (1, 'Consul XPTO', 'Geladeira');

INSERT INTO cliente(cpf, nome, end_estado, end_cidade, end_bairro, end_rua, end_num) values ('12345678900', 'Fulano de Zonzois Pereira', 'CE', 'Crateús', 'Venancios', 'Rua Um', 056);

INSERT INTO atendimento(situacao, data_atendimento, titulo, descricao, cpf_cliente) values ('RUIM','2025-03-31', 'Conserto de porta', 'Porta nâo esta vedando o ar dentro da geladeira', '12345678900');

INSERT INTO telefone_cliente(cliente_cpf, telefone) values ('12345678900', '88123456789');

INSERT INTO cliente_compra_produto(cpf_cliente, codigo_produto, data_compra) VALUES ('12345678900', 1, '2000-05-18');

SELECT * FROM produto;
SELECT * FROM cliente;
SELECT * FROM atendimento;
SELECT * FROM telefone_cliente;
SELECT * FROM cliente_compra_produto;