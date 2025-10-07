-- Realice una consulta SQL que muestre el ID de producto, descripción del producto, precio mínimo, 
-- precio de lista y la cantidad de items vendidos para aquellos productos que han sido vendidos en 
-- más de 5 órdenes (SALES_ORDER). Ordenar los resultados por cantidad de items vendidos de forma descendente.


SELECT prod.product_id,
       prod.description,
       price.min_price,
       price.list_price,
       SUM(it.quantity) AS items_vendidos
FROM PRODUCT prod
JOIN PRICE
    ON (prod.product_id = price.product_id) AND (price.end_date IS NULL)
JOIN ITEM it
    ON prod.product_id = it.product_id
GROUP BY prod.product_id,
         prod.description,
         price.min_price,
         price.list_price
HAVING COUNT(DISTINCT it.order_id) > 5
ORDER BY items_vendidos DESC
