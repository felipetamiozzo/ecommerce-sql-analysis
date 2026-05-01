-- ======================================================================================
-- ARQUIVO: 03_queries_basicas.sql
-- OBJETIVO: Consultas básicas, filtros, ordenações, agregações e joins no e-commerce
-- BANCO: ecommerce
-- ======================================================================================

USE ecommerce;

-- ======================================================================================
-- 1. CONSULTAS BÁSICAS
-- Pergunta de Negócio:
-- Quais são os dados cadastrados nas principais tabelas do sistema?
-- ======================================================================================

SELECT *
FROM Cliente;

SELECT *
FROM Produto;

SELECT *
FROM Pedido;


-- ======================================================================================
-- 2. DADOS PRINCIPAIS DOS CLIENTES
-- Pergunta de Negócio:
-- Quais são os nomes e CPFs dos clientes cadastrados?
-- ======================================================================================

SELECT
    Nome,
    CPF
FROM Cliente;


-- ======================================================================================
-- 3. FILTRO POR LOCALIZAÇÃO
-- Pergunta de Negócio:
-- Quais clientes moram em São Paulo?
-- ======================================================================================

SELECT *
FROM Cliente
WHERE Endereco LIKE '%São Paulo%';


-- ======================================================================================
-- 4. FILTRO POR PREÇO
-- Pergunta de Negócio:
-- Quais produtos possuem preço acima de R$ 100?
-- ======================================================================================

SELECT *
FROM Produto
WHERE Preco > 100;


-- ======================================================================================
-- 5. FILTRO POR STATUS DO PEDIDO
-- Pergunta de Negócio:
-- Quais pedidos já foram entregues?
-- ======================================================================================

SELECT *
FROM Pedido
WHERE StatusPedido = 'Entregue';


-- ======================================================================================
-- 6. ORDENAÇÃO DE CLIENTES
-- Pergunta de Negócio:
-- Como listar os clientes em ordem alfabética?
-- ======================================================================================

SELECT
    Nome
FROM Cliente
ORDER BY Nome ASC;


-- ======================================================================================
-- 7. ORDENAÇÃO DE PRODUTOS POR PREÇO
-- Pergunta de Negócio:
-- Quais são os produtos mais caros?
-- ======================================================================================

SELECT
    Nome,
    Categoria,
    Preco
FROM Produto
ORDER BY Preco DESC;


-- ======================================================================================
-- 8. LIMITAÇÃO DE RESULTADOS
-- Pergunta de Negócio:
-- Quais são os 5 primeiros produtos cadastrados?
-- ======================================================================================

SELECT *
FROM Produto
LIMIT 5;


-- ======================================================================================
-- 9. QUANTIDADE DE CLIENTES
-- Pergunta de Negócio:
-- Quantos clientes existem cadastrados?
-- ======================================================================================

SELECT
    COUNT(*) AS TotalClientes
FROM Cliente;


-- ======================================================================================
-- 10. PREÇO MÉDIO DOS PRODUTOS
-- Pergunta de Negócio:
-- Qual é o preço médio dos produtos?
-- ======================================================================================

SELECT
    ROUND(AVG(Preco), 2) AS PrecoMedio
FROM Produto;


-- ======================================================================================
-- 11. MAIOR FRETE
-- Pergunta de Negócio:
-- Qual foi o maior valor de frete registrado?
-- ======================================================================================

SELECT
    MAX(Frete) AS MaiorFrete
FROM Pedido;


-- ======================================================================================
-- 12. PEDIDOS COM NOME DO CLIENTE
-- Pergunta de Negócio:
-- Quais pedidos foram feitos por cada cliente?
-- ======================================================================================

SELECT
    c.Nome,
    p.idPedido,
    p.StatusPedido
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente;


-- ======================================================================================
-- 13. CLIENTE, PEDIDO E FRETE
-- Pergunta de Negócio:
-- Quais pedidos tiveram os maiores valores de frete?
-- ======================================================================================

SELECT
    c.Nome,
    p.idPedido,
    p.Frete
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
ORDER BY p.Frete DESC;


-- ======================================================================================
-- 14. QUANTIDADE DE PEDIDOS POR CLIENTE
-- Pergunta de Negócio:
-- Quantos pedidos cada cliente realizou?
-- ======================================================================================

SELECT
    c.Nome,
    COUNT(p.idPedido) AS TotalPedidos
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
GROUP BY c.idCliente, c.Nome
ORDER BY TotalPedidos DESC;


-- ======================================================================================
-- 15. TOTAL DE FRETE POR CLIENTE
-- Pergunta de Negócio:
-- Quanto cada cliente pagou no total de frete?
-- ======================================================================================

SELECT
    c.Nome,
    SUM(p.Frete) AS TotalFrete
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
GROUP BY c.idCliente, c.Nome
ORDER BY TotalFrete DESC;


-- ======================================================================================
-- 16. CLIENTES QUE POSSUEM PEDIDOS
-- Pergunta de Negócio:
-- Quais clientes já realizaram pelo menos um pedido?
-- ======================================================================================

SELECT DISTINCT
    c.Nome
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente;


-- ======================================================================================
-- 17. PEDIDOS COM FRETE MAIOR QUE R$ 20
-- Pergunta de Negócio:
-- Quais pedidos possuem frete acima de R$ 20?
-- ======================================================================================

SELECT *
FROM Pedido
WHERE Frete > 20;


-- ======================================================================================
-- 18. TOTAL DE PEDIDOS ENTREGUES
-- Pergunta de Negócio:
-- Quantos pedidos foram entregues?
-- ======================================================================================

SELECT
    COUNT(*) AS TotalPedidosEntregues
FROM Pedido
WHERE StatusPedido = 'Entregue';


-- ======================================================================================
-- 19. CLIENTE COM MAIS PEDIDOS
-- Pergunta de Negócio:
-- Qual cliente realizou mais pedidos?
-- ======================================================================================

SELECT
    c.Nome,
    COUNT(p.idPedido) AS TotalPedidos
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
GROUP BY c.idCliente, c.Nome
ORDER BY TotalPedidos DESC
LIMIT 1;


-- ======================================================================================
-- 20. MÉDIA DE FRETE POR CLIENTE
-- Pergunta de Negócio:
-- Qual é a média de frete paga por cada cliente?
-- ======================================================================================

SELECT
    c.Nome,
    ROUND(AVG(p.Frete), 2) AS MediaFrete
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
GROUP BY c.idCliente, c.Nome
ORDER BY MediaFrete DESC;


-- ======================================================================================
-- 21. TOTAL DE PEDIDOS POR CLIENTE E STATUS
-- Pergunta de Negócio:
-- Quantos pedidos cada cliente possui em cada status?
-- ======================================================================================

SELECT
    c.Nome,
    p.StatusPedido,
    COUNT(p.idPedido) AS TotalPedidos
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
GROUP BY c.idCliente, c.Nome, p.StatusPedido
ORDER BY c.Nome;


-- ======================================================================================
-- 22. CLIENTES COM MAIS DE UM PEDIDO
-- Pergunta de Negócio:
-- Quais clientes realizaram mais de um pedido?
-- ======================================================================================

SELECT
    c.Nome,
    COUNT(p.idPedido) AS TotalPedidos
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
GROUP BY c.idCliente, c.Nome
HAVING COUNT(p.idPedido) > 1;


-- ======================================================================================
-- 23. RANKING DE CLIENTES POR TOTAL DE FRETE
-- Pergunta de Negócio:
-- Quais clientes mais gastaram com frete?
-- ======================================================================================

SELECT
    c.Nome,
    COUNT(p.idPedido) AS TotalPedidos,
    SUM(p.Frete) AS TotalFrete
FROM Cliente c
JOIN Pedido p
    ON c.idCliente = p.Pedido_idCliente
GROUP BY c.idCliente, c.Nome
ORDER BY TotalFrete DESC;


-- ======================================================================================
-- 24. PREÇO MÉDIO DOS PRODUTOS POR CATEGORIA
-- Pergunta de Negócio:
-- Qual é o preço médio dos produtos em cada categoria?
-- ======================================================================================

SELECT
    Categoria,
    COUNT(idProduto) AS TotalProdutos,
    ROUND(AVG(Preco), 2) AS PrecoMedio
FROM Produto
GROUP BY Categoria
ORDER BY PrecoMedio DESC;


-- ======================================================================================
-- 25. PRODUTO MAIS CARO POR CATEGORIA
-- Pergunta de Negócio:
-- Qual é o maior preço registrado em cada categoria?
-- ======================================================================================

SELECT
    Categoria,
    MAX(Preco) AS MaiorPreco
FROM Produto
GROUP BY Categoria
ORDER BY MaiorPreco DESC;