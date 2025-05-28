CREATE TABLE usuarios(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nome, email) VALUES
    ('João Silva', 'joão@example.com'),
    ('Maria Souza', 'maria@example.com'),
    ('Carlos Pereira', 'carlos@exemple.com');