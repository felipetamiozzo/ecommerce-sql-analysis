USE ecommerce;

DELETE FROM Pagamento;
DELETE FROM Pedido;
DELETE FROM Cliente;

ALTER TABLE Cliente AUTO_INCREMENT = 1;
-- =========================
-- CLIENTES
-- =========================
INSERT INTO Cliente (Nome, CPF, Endereco, DataNascimento) VALUES
('Maria Silva', '12345678901', 'Rua Silva de Prata, 29 - Belo Horizonte/MG', '1992-05-14'),
('Matheus Pimentel', '98765432100', 'Rua Alameda, 289 - São Paulo/SP', '1995-09-21'),
('Ricardo Silva', '45678912300', 'Av. Alameda Vinha, 1009 - Rio de Janeiro/RJ', '1988-02-10'),
('Julia França', '78912345600', 'Rua das Laranjeiras, 861 - Curitiba/PR', '1999-11-03'),
('Roberta Assis', '98745631200', 'Av. Koller, 19 - Porto Alegre/RS', '1990-07-18'),
('Isabela Cruz', '65478912300', 'Rua das Flores, 28 - Campinas/SP', '1997-04-25'),
('Lucas Almeida', '32165498700', 'Rua Central, 45 - Recife/PE', '1993-12-08'),
('Fernanda Costa', '74185296300', 'Av. Brasil, 500 - Salvador/BA', '1986-06-30'),
('Pedro Martins', '85296374100', 'Rua Primavera, 77 - Florianópolis/SC', '2000-01-12'),
('Camila Rocha', '15975348600', 'Rua dos Pinheiros, 120 - São Paulo/SP', '1994-08-09');

-- =========================
-- PRODUTOS
-- =========================
INSERT INTO Produto (idProduto, Nome, Categoria, Avaliacao, Dimensao, Preco) VALUES
(1, 'Fone de ouvido Bluetooth', 'Eletronico', 4.60, '10x10x5', 199.90),
(2, 'Boneca Elsa', 'Brinquedos', 4.20, '30x15x8', 89.90),
(3, 'Body Infantil Carters', 'Vestimenta', 4.80, '30x20x2', 59.90),
(4, 'Microfone USB para Streaming', 'Eletronico', 4.50, '20x8x8', 249.90),
(5, 'Sofá Retrátil 3 Lugares', 'Moveis', 4.10, '200x90x85', 1899.90),
(6, 'Farinha de Arroz 1kg', 'Alimentos', 3.90, '15x10x25', 12.90),
(7, 'Fire Stick Smart TV', 'Eletronico', 4.70, '12x4x2', 329.90),
(8, 'Camiseta Básica Masculina', 'Vestimenta', 4.30, '40x30x2', 49.90),
(9, 'Carrinho Hot Wheels', 'Brinquedos', 4.60, '8x3x3', 24.90),
(10, 'Mesa de Escritório', 'Moveis', 4.40, '120x60x75', 499.90),
(11, 'Teclado Mecânico', 'Eletronico', 4.80, '45x15x4', 349.90),
(12, 'Café Gourmet 500g', 'Alimentos', 4.50, '12x8x20', 39.90);

-- =========================
-- ESTOQUE
-- =========================
INSERT INTO Estoque (idEstoque, Localizacao) VALUES
(1, 'São Paulo'),
(2, 'Rio de Janeiro'),
(3, 'Belo Horizonte'),
(4, 'Curitiba');

-- =========================
-- FORNECEDORES
-- =========================
INSERT INTO Fornecedor (idFornecedor, RazaoSocial, CNPJ, Contato) VALUES
(1, 'Almeida e Filhos LTDA', '12345678000190', 'contato@almeida.com'),
(2, 'Eletrônicos Silva LTDA', '85451964000145', 'vendas@eletronicosilva.com'),
(3, 'Valma Distribuidora LTDA', '93456789000169', 'comercial@valma.com'),
(4, 'Móveis Brasil LTDA', '11222333000155', 'atendimento@moveisbrasil.com'),
(5, 'Alimentos Premium LTDA', '99888777000166', 'sac@alimentospremium.com');

-- =========================
-- VENDEDORES TERCEIROS
-- =========================
INSERT INTO Vendedor_Terceiro (idTerceiro, RazaoSocial, Localizacao, NomeFantasia, CNPJ, CPF) VALUES
(1, 'Tech Eletronics LTDA', 'Rio de Janeiro', 'Tech Eletronics', '22334455000199', NULL),
(2, 'Boutique Durgas ME', 'São Paulo', 'Boutique Durgas', '33445566000188', NULL),
(3, 'Kids World LTDA', 'São Paulo', 'Kids World', '44556677000177', NULL),
(4, 'João Marketplace', 'Curitiba', 'João Store', NULL, '12312312399');

-- =========================
-- PRODUTO x ESTOQUE
-- =========================
INSERT INTO Produto_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) VALUES
(1, 1, 120),
(1, 2, 80),
(2, 1, 60),
(2, 3, 30),
(3, 1, 100),
(4, 2, 45),
(5, 4, 12),
(6, 3, 300),
(7, 1, 70),
(8, 2, 150),
(9, 3, 200),
(10, 4, 25),
(11, 1, 50),
(12, 3, 180);

-- =========================
-- PRODUTO x FORNECEDOR
-- =========================
INSERT INTO Produto_Fornecedor (Fornecedor_idFornecedor, Produto_idProduto, QuantidadePadrao) VALUES
(2, 1, 100),
(3, 2, 80),
(3, 3, 120),
(2, 4, 60),
(4, 5, 15),
(5, 6, 300),
(2, 7, 90),
(3, 8, 150),
(3, 9, 200),
(4, 10, 40),
(2, 11, 70),
(5, 12, 250);

-- =========================
-- PRODUTO x VENDEDOR TERCEIRO
-- =========================
INSERT INTO Produto_Terceiro (Vendedor_idTerceiro, Produto_idProduto, Quantidade) VALUES
(1, 1, 40),
(1, 4, 20),
(1, 7, 35),
(1, 11, 25),
(2, 8, 60),
(3, 2, 50),
(3, 9, 90),
(4, 6, 30),
(4, 12, 45);

-- =========================
-- PEDIDOS
-- =========================
INSERT INTO Pedido (idPedido, Pedido_idCliente, StatusPedido, Descricao, Frete, DataPedido) VALUES
(1, 1, 'Entregue', 'Compra via aplicativo', 19.90, '2025-01-10 10:30:00'),
(2, 2, 'Entregue', 'Compra via website', 25.00, '2025-01-18 15:45:00'),
(3, 3, 'Processando', 'Compra via aplicativo', 15.00, '2025-02-02 09:10:00'),
(4, 4, 'Enviado', 'Compra via website', 39.90, '2025-02-20 18:20:00'),
(5, 5, 'Cancelado', 'Cliente solicitou cancelamento', 0.00, '2025-03-01 11:00:00'),
(6, 6, 'Entregue', 'Compra via aplicativo', 12.90, '2025-03-12 14:35:00'),
(7, 7, 'Pendente', 'Aguardando confirmação de pagamento', 22.50, '2025-04-03 08:40:00'),
(8, 8, 'Entregue', 'Compra corporativa', 59.90, '2025-04-15 16:05:00'),
(9, 9, 'Enviado', 'Compra via marketplace', 18.90, '2025-05-04 13:15:00'),
(10, 10, 'Processando', 'Compra via website', 29.90, '2025-05-19 20:10:00');

-- =========================
-- ITENS DO PEDIDO
-- =========================
INSERT INTO Pedido_Produto (Produto_idProduto, Pedido_idPedido, Quantidade, PrecoUnitario) VALUES
(1, 1, 2, 199.90),
(7, 1, 1, 329.90),
(2, 2, 1, 89.90),
(3, 2, 2, 59.90),
(4, 3, 1, 249.90),
(11, 3, 1, 349.90),
(5, 4, 1, 1899.90),
(6, 5, 5, 12.90),
(12, 6, 3, 39.90),
(8, 6, 2, 49.90),
(10, 7, 1, 499.90),
(1, 8, 5, 199.90),
(11, 8, 3, 349.90),
(9, 9, 4, 24.90),
(2, 9, 1, 89.90),
(7, 10, 2, 329.90),
(4, 10, 1, 249.90);

-- =========================
-- PAGAMENTOS
-- =========================
INSERT INTO Pagamento (idPagamento, Valor, TipoPagamento, Pagamento_idPedido, DataPagamento) VALUES
(1, 749.60, 'Cartao', 1, '2025-01-10 10:35:00'),
(2, 234.70, 'Pix', 2, '2025-01-18 15:50:00'),
(3, 614.80, 'Cartao', 3, '2025-02-02 09:15:00'),
(4, 1939.80, 'Boleto', 4, '2025-02-20 18:30:00'),
(5, 64.50, 'Pix', 5, '2025-03-01 11:05:00'),
(6, 232.40, 'Pix', 6, '2025-03-12 14:40:00'),
(7, 522.40, 'Boleto', 7, '2025-04-03 08:50:00'),
(8, 2109.10, 'Cartao', 8, '2025-04-15 16:10:00'),
(9, 208.40, 'Pix', 9, '2025-05-04 13:20:00'),
(10, 939.60, 'Cartao', 10, '2025-05-19 20:15:00');

-- =========================
-- TESTES RÁPIDOS
-- =========================
SELECT * FROM Cliente;
SELECT * FROM Produto;
SELECT * FROM Pedido;
SELECT * FROM Pedido_Produto;
SELECT * FROM Pagamento;