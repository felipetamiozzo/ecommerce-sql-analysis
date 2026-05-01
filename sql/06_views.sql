-- ======================================================================================
-- ARQUIVO: 06_views.sql
-- OBJETIVO: Criação de views para facilitar análises recorrentes no e-commerce
-- BANCO: ecommerce
-- ======================================================================================

USE ecommerce;

-- ======================================================================================
-- 1. VIEW: CLIENTES E SEUS PEDIDOS
-- Objetivo:
-- Consolidar informações de clientes com seus respectivos pedidos.
-- ======================================================================================

CREATE OR REPLACE VIEW vw_clientes_pedidos AS
SELECT
    c.idCliente,
    c.Nome AS NomeCliente,
    c.CPF,
    p.idPedido,
    p.StatusPedido,
    p.Frete,
    p.DataPedido
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente;


-- ======================================================================================
-- 2. VIEW: DETALHES DOS PEDIDOS
-- Objetivo:
-- Exibir pedidos com produtos, quantidades e valores.
-- ======================================================================================

CREATE OR REPLACE VIEW vw_detalhes_pedidos AS
SELECT
    p.idPedido,
    c.Nome AS NomeCliente,
    pr.Nome AS NomeProduto,
    pr.Categoria,
    pp.Quantidade,
    pp.PrecoUnitario,
    (pp.Quantidade * pp.PrecoUnitario) AS ValorItem,
    p.Frete,
    p.StatusPedido,
    p.DataPedido
FROM Pedido p
JOIN Cliente c
    ON c.idCliente = p.Pedido_idCliente
JOIN Pedido_Produto pp
    ON p.idPedido = pp.Pedido_idPedido
JOIN Produto pr
    ON pr.idProduto = pp.Produto_idProduto;


-- ======================================================================================
-- 3. VIEW: FATURAMENTO POR PEDIDO
-- Objetivo:
-- Calcular o valor total de cada pedido.
-- ======================================================================================

CREATE OR REPLACE VIEW vw_faturamento_pedido AS
SELECT
    p.idPedido,
    c.Nome AS NomeCliente,
    SUM(pp.Quantidade * pp.PrecoUnitario) AS ValorProdutos,
    p.Frete,
    SUM(pp.Quantidade * pp.PrecoUnitario) + p.Frete AS ValorTotalPedido,
    p.StatusPedido,
    p.DataPedido
FROM Pedido p
JOIN Cliente c
    ON c.idCliente = p.Pedido_idCliente
JOIN Pedido_Produto pp
    ON p.idPedido = pp.Pedido_idPedido
GROUP BY
    p.idPedido,
    c.Nome,
    p.Frete,
    p.StatusPedido,
    p.DataPedido;


-- ======================================================================================
-- 4. VIEW: ESTOQUE POR PRODUTO
-- Objetivo:
-- Consolidar a quantidade disponível de cada produto em estoque.
-- ======================================================================================

CREATE OR REPLACE VIEW vw_estoque_produto AS
SELECT
    pr.idProduto,
    pr.Nome AS NomeProduto,
    pr.Categoria,
    SUM(pe.Quantidade) AS QuantidadeTotalEstoque
FROM Produto pr
JOIN Produto_Estoque pe
    ON pr.idProduto = pe.Produto_idProduto
GROUP BY
    pr.idProduto,
    pr.Nome,
    pr.Categoria;


-- ======================================================================================
-- 5. VIEW: PAGAMENTOS POR PEDIDO
-- Objetivo:
-- Unificar dados de pedidos com informações de pagamento.
-- ======================================================================================

CREATE OR REPLACE VIEW vw_pagamentos_pedidos AS
SELECT
    p.idPedido,
    c.Nome AS NomeCliente,
    pg.TipoPagamento,
    pg.Valor AS ValorPago,
    pg.DataPagamento,
    p.StatusPedido
FROM Pagamento pg
JOIN Pedido p
    ON p.idPedido = pg.Pagamento_idPedido
JOIN Cliente c
    ON c.idCliente = p.Pedido_idCliente;


-- ======================================================================================
-- 6. TESTES DAS VIEWS
-- ======================================================================================

SELECT *
FROM vw_clientes_pedidos;

SELECT *
FROM vw_detalhes_pedidos;

SELECT *
FROM vw_faturamento_pedido;

SELECT *
FROM vw_estoque_produto;

SELECT *
FROM vw_pagamentos_pedidos;