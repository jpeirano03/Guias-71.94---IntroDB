-- Mostrar las órdenes de venta, el nombre del cliente al que se vendió y la descripción de los productos. Ordenar la consulta por nro. de orden.

SELECT so.order_id AS orden_id,
       cus.name AS nombre_cliente,
       prod.description As descripcion_producto
FROM SALES_ORDER so
JOIN CUSTOMER cus
    ON so.customer_id = cus.customer_id
JOIN ITEM i
    ON so.order_id = i.order_id
JOIN PRODUCT prod
    ON i.product_id = prod.product_id
ORDER BY so.order_id ASC
