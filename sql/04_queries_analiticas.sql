-- ======================================================================================
-- ARQUIVO: 04_queries_analiticas.sql
-- OBJETIVO: Análises de negócio para o sistema de e-commerce
-- BANCO: ecommerce
-- ======================================================================================

USE ecommerce;

-- ======================================================================================
-- 1. EXTRAÇÃO E FILTRO BÁSICO
-- Pergunta de Negócio:
-- Quais produtos da categoria 'Eletronico' custam menos de R$ 300?
-- ======================================================================================

SELECT
    Nome,
    Preco,
    Avaliacao
FROM Produto
WHERE Categoria = 'Eletronico'
  AND Preco < 300
ORDER BY Preco ASC;


-- ======================================================================================
-- 2. CLASSIFICAÇÃO DE FRETE (CASE WHEN)
-- Pergunta de Negócio:
-- Como categorizar os custos logísticos dos pedidos?
-- ======================================================================================

SELECT
    idPedido,
    Frete,
    CASE
        WHEN Frete = 0 THEN 'Frete Grátis'
        WHEN Frete <= 20 THEN 'Frete Baixo'
        ELSE 'Frete Alto'
    END AS CategoriaFrete
FROM Pedido;


-- ======================================================================================
-- 3. TRATAMENTO DE DADOS NULOS
-- Pergunta de Negócio:
-- Existem pedidos sem descrição? Como padronizar?
-- ======================================================================================

SELECT
    idPedido,
    COALESCE(Descricao, 'Sem descrição') AS DescricaoTratada
FROM Pedido;


-- ======================================================================================
-- 4. AGREGAÇÕES DE PAGAMENTO
-- Pergunta de Negócio:
-- Qual faturamento e ticket médio por tipo de pagamento?
-- ======================================================================================

SELECT
    TipoPagamento,
    COUNT(idPagamento) AS QtdTransacoes,
    SUM(Valor) AS FaturamentoTotal,
    ROUND(AVG(Valor), 2) AS TicketMedio
FROM Pagamento
GROUP BY TipoPagamento
ORDER BY FaturamentoTotal DESC;


-- ======================================================================================
-- 5. JOIN: CLIENTES COM PEDIDOS CANCELADOS
-- Pergunta de Negócio:
-- Quais clientes tiveram pedidos cancelados?
-- ======================================================================================

SELECT
    c.Nome,
    p.idPedido,
    p.StatusPedido,
    p.Descricao
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
WHERE p.StatusPedido = 'Cancelado';


-- ======================================================================================
-- 6. MANIPULAÇÃO DE TEXTO: EXTRAÇÃO DE CIDADE
-- Pergunta de Negócio:
-- De que cidades vêm os clientes?
-- ======================================================================================

SELECT
    Nome,
    SUBSTRING(Endereco, LOCATE('-', Endereco) + 2) AS Cidade
FROM Cliente;


-- ======================================================================================
-- 7. MANIPULAÇÃO DE TEXTO: NOME REDUZIDO
-- Pergunta de Negócio:
-- Como padronizar nomes para exibição reduzida em dashboards?
-- ======================================================================================

SELECT
    Nome,
    SUBSTRING(Nome, 1, 5) AS NomeCurto
FROM Cliente;


-- ======================================================================================
-- 8. CLASSIFICAÇÃO DE PRODUTOS POR AVALIAÇÃO
-- Pergunta de Negócio:
-- Como segmentar produtos por avaliação?
-- ======================================================================================

SELECT
    Nome,
    Categoria,
    Avaliacao,
    CASE
        WHEN Avaliacao >= 4.6 THEN 'Excelente'
        WHEN Avaliacao >= 4.0 THEN 'Bom'
        ELSE 'Revisar'
    END AS StatusAceitacao
FROM Produto
ORDER BY Avaliacao DESC;


-- ======================================================================================
-- 9. MANIPULAÇÃO DE DATAS: DETALHAMENTO DOS PEDIDOS
-- Pergunta de Negócio:
-- Como analisar o comportamento dos pedidos ao longo do tempo?
-- ======================================================================================

SELECT
    idPedido,
    Pedido_idCliente,
    StatusPedido,
    DataPedido,
    YEAR(DataPedido) AS AnoPedido,
    MONTH(DataPedido) AS MesPedido,
    DAY(DataPedido) AS DiaPedido
FROM Pedido
ORDER BY DataPedido;


-- ======================================================================================
-- 10. MANIPULAÇÃO DE DATAS: PEDIDOS POR MÊS
-- Pergunta de Negócio:
-- Em quais meses tivemos mais pedidos realizados?
-- ======================================================================================

SELECT
    YEAR(DataPedido) AS AnoPedido,
    MONTH(DataPedido) AS MesPedido,
    COUNT(idPedido) AS TotalPedidos
FROM Pedido
GROUP BY YEAR(DataPedido), MONTH(DataPedido)
ORDER BY AnoPedido, MesPedido;


-- ======================================================================================
-- 11. MANIPULAÇÃO DE DATAS: TEMPO ENTRE PEDIDO E PAGAMENTO
-- Pergunta de Negócio:
-- Quantos dias se passaram entre a realização do pedido e o pagamento?
-- ======================================================================================

SELECT
    p.idPedido,
    c.Nome AS NomeCliente,
    p.DataPedido,
    pg.DataPagamento,
    TIMESTAMPDIFF(DAY, p.DataPedido, pg.DataPagamento) AS DiasAtePagamento
FROM Pedido p
JOIN Pagamento pg
    ON p.idPedido = pg.Pagamento_idPedido
JOIN Cliente c
    ON c.idCliente = p.Pedido_idCliente
ORDER BY DiasAtePagamento DESC;


-- ======================================================================================
-- 12. MANIPULAÇÃO DE DATAS: IDADE DOS CLIENTES
-- Pergunta de Negócio:
-- Qual é a idade dos clientes cadastrados?
-- ======================================================================================

SELECT
    Nome,
    DataNascimento,
    TIMESTAMPDIFF(YEAR, DataNascimento, CURDATE()) AS Idade
FROM Cliente
ORDER BY Idade DESC;


-- ======================================================================================
-- 13. MANIPULAÇÃO DE DATAS: CLIENTES ACIMA DE 30 ANOS
-- Pergunta de Negócio:
-- Quais clientes têm mais de 30 anos?
-- ======================================================================================

SELECT
    Nome,
    DataNascimento,
    TIMESTAMPDIFF(YEAR, DataNascimento, CURDATE()) AS Idade
FROM Cliente
WHERE TIMESTAMPDIFF(YEAR, DataNascimento, CURDATE()) > 30
ORDER BY Idade DESC;


-- ======================================================================================
-- 14. CTE + RANK: PRODUTOS MAIS CAROS POR CATEGORIA
-- Pergunta de Negócio:
-- Quais são os 2 produtos mais caros por categoria?
-- ======================================================================================

WITH RankingProdutos AS (
    SELECT
        Categoria,
        Nome,
        Preco,
        RANK() OVER (
            PARTITION BY Categoria
            ORDER BY Preco DESC
        ) AS RankPreco
    FROM Produto
)
SELECT
    Categoria,
    Nome,
    Preco
FROM RankingProdutos
WHERE RankPreco <= 2;


-- ======================================================================================
-- 15. CTE: CLIENTES QUE MAIS COMPRAM
-- Pergunta de Negócio:
-- Quais clientes mais compram?
-- ======================================================================================

WITH PedidosPorCliente AS (
    SELECT
        Pedido_idCliente,
        COUNT(*) AS TotalPedidos
    FROM Pedido
    GROUP BY Pedido_idCliente
)
SELECT
    c.Nome,
    p.TotalPedidos
FROM PedidosPorCliente p
JOIN Cliente c
    ON c.idCliente = p.Pedido_idCliente
ORDER BY p.TotalPedidos DESC;


-- ======================================================================================
-- 16. WINDOW FUNCTION: ROW_NUMBER
-- Pergunta de Negócio:
-- Qual a ordem dos pedidos realizados por cada cliente?
-- ======================================================================================

SELECT
    idPedido,
    Pedido_idCliente,
    ROW_NUMBER() OVER (
        PARTITION BY Pedido_idCliente
        ORDER BY idPedido
    ) AS OrdemPedido
FROM Pedido;


-- ======================================================================================
-- 17. WINDOW FUNCTION: RANK
-- Pergunta de Negócio:
-- Quais são os clientes mais valiosos com base no número de pedidos?
-- ======================================================================================

SELECT
    Nome,
    TotalPedidos,
    RANK() OVER (ORDER BY TotalPedidos DESC) AS RankingClientes
FROM (
    SELECT
        c.Nome,
        COUNT(p.idPedido) AS TotalPedidos
    FROM Cliente c
    JOIN Pedido p
        ON c.idCliente = p.Pedido_idCliente
    GROUP BY c.idCliente, c.Nome
) AS sub;


-- ======================================================================================
-- 18. SEGMENTAÇÃO DE CLIENTES
-- Pergunta de Negócio:
-- Como segmentar clientes com base no volume de compras?
-- ======================================================================================

WITH ResumoClientes AS (
    SELECT
        c.idCliente,
        c.Nome,
        COUNT(p.idPedido) AS TotalPedidos,
        SUM(p.Frete) AS TotalFrete
    FROM Cliente c
    JOIN Pedido p
        ON c.idCliente = p.Pedido_idCliente
    GROUP BY c.idCliente, c.Nome
)
SELECT
    Nome,
    TotalPedidos,
    TotalFrete,
    CASE
        WHEN TotalPedidos >= 3 THEN 'Cliente Frequente'
        ELSE 'Cliente Ocasional'
    END AS SegmentoCliente,
    RANK() OVER (ORDER BY TotalPedidos DESC) AS Ranking
FROM ResumoClientes;