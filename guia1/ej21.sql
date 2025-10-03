-- Por cada producto mostrar el promedio de su historial de precios. Ordenar por
-- producto y fecha.

-- Entiendo que hace referencia a la fecha en la que arrancó a venderse, osea MIN(price.start_date)
-- Pero no tiene sentido xq si ya ordeno por producto no va a haber dos productos distintos como para ordenar por fecha

SELECT prod.product_id,
       prod.description,
       AVG(price.list_price) AS promedio
FROM PRODUCT prod
JOIN PRICE
    ON prod.product_id = price.product_id
GROUP BY prod.product_id,
         prod.description
ORDER BY prod.product_id
