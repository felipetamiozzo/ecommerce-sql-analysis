-- ======================================================================================
-- ARQUIVO: 05_indexes_performance.sql
-- OBJETIVO: Criação de índices e análise de performance no banco de dados ecommerce
-- BANCO: ecommerce
-- ======================================================================================

USE ecommerce;

-- ======================================================================================
-- 1. ANÁLISE DE PERFORMANCE COM EXPLAIN
-- Pergunta Técnica:
-- Como o banco executa a consulta de pedidos por cliente?
-- ======================================================================================

EXPLAIN
SELECT
    c.Nome,
    p.idPedido,
    p.StatusPedido
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente;


-- ======================================================================================
-- 2. ÍNDICE PARA BUSCA DE CLIENTES POR NOME
-- Objetivo:
-- Melhorar consultas que filtram ou ordenam clientes pelo nome.
-- ======================================================================================

CREATE INDEX idx_cliente_nome
ON Cliente (Nome);


-- ======================================================================================
-- 3. ÍNDICE PARA BUSCA DE PRODUTOS POR CATEGORIA
-- Objetivo:
-- Melhorar filtros por categoria de produto.
-- ======================================================================================

CREATE INDEX idx_produto_categoria
ON Produto (Categoria);


-- ======================================================================================
-- 4. ÍNDICE PARA BUSCA DE PRODUTOS POR PREÇO
-- Objetivo:
-- Melhorar filtros e ordenações por preço.
-- ======================================================================================

CREATE INDEX idx_produto_preco
ON Produto (Preco);


-- ======================================================================================
-- 5. ÍNDICE COMPOSTO PARA CATEGORIA E PREÇO
-- Objetivo:
-- Melhorar consultas que filtram por categoria e ordenam/filtram por preço.
-- ======================================================================================

CREATE INDEX idx_produto_categoria_preco
ON Produto (Categoria, Preco);


-- ======================================================================================
-- 6. ÍNDICE PARA STATUS DO PEDIDO
-- Objetivo:
-- Melhorar consultas por status do pedido.
-- ======================================================================================

CREATE INDEX idx_pedido_status
ON Pedido (StatusPedido);


-- ======================================================================================
-- 7. ÍNDICE PARA DATA DO PEDIDO
-- Objetivo:
-- Melhorar consultas por período.
-- ======================================================================================

CREATE INDEX idx_pedido_data
ON Pedido (DataPedido);


-- ======================================================================================
-- 8. ÍNDICE COMPOSTO PARA CLIENTE E STATUS DO PEDIDO
-- Objetivo:
-- Melhorar análises de pedidos por cliente e status.
-- ======================================================================================

CREATE INDEX idx_pedido_cliente_status
ON Pedido (Pedido_idCliente, StatusPedido);


-- ======================================================================================
-- 9. ÍNDICE PARA TIPO DE PAGAMENTO
-- Objetivo:
-- Melhorar agrupamentos e filtros por tipo de pagamento.
-- ======================================================================================

CREATE INDEX idx_pagamento_tipo
ON Pagamento (TipoPagamento);


-- ======================================================================================
-- 10. ÍNDICE PARA DATA DO PAGAMENTO
-- Objetivo:
-- Melhorar análises por período de pagamento.
-- ======================================================================================

CREATE INDEX idx_pagamento_data
ON Pagamento (DataPagamento);


-- ======================================================================================
-- 11. TESTE DE PERFORMANCE APÓS ÍNDICES
-- Pergunta Técnica:
-- A consulta passou a usar índice após a criação?
-- ======================================================================================

EXPLAIN
SELECT
    Nome,
    Categoria,
    Preco
FROM Produto
WHERE Categoria = 'Eletronico'
  AND Preco < 300
ORDER BY Preco ASC;


EXPLAIN
SELECT
    StatusPedido,
    COUNT(*) AS TotalPedidos
FROM Pedido
GROUP BY StatusPedido;


EXPLAIN
SELECT
    TipoPagamento,
    COUNT(*) AS QtdTransacoes,
    SUM(Valor) AS FaturamentoTotal
FROM Pagamento
GROUP BY TipoPagamento;


-- ======================================================================================
-- 12. VISUALIZAR ÍNDICES CRIADOS
-- Objetivo:
-- Verificar os índices existentes em cada tabela.
-- ======================================================================================

SHOW INDEX FROM Cliente;

SHOW INDEX FROM Produto;

SHOW INDEX FROM Pedido;

SHOW INDEX FROM Pagamento;