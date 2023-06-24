-- ****************************************************************************************************************** --
--
-- desarrolle una consulta sql sobre la base de datos de ejemplo SAKILA que recupere la actuacion de los clientes
-- generando un listado de los clientes por la cantidad de alquileres realizados, cada renglon debera contener lo siguiente
-- * apellido del cliente
-- * nombre del cliente
-- * cantidad total de alquileres realizados
-- * mes y año en el que ese cliente realizo mas alquileres (si hay mas de uno mayor, mostrar solo uno)
-- * cantidad de alquileres que realizo en ese mes y año
-- solo mostrar los clientes que no tengan alquileres no devueltos.
-- ordenar por apellido y nombre
-- formato: APELLIDO | NOMBRE | CTD_TOTAL | MES_MAYOR | ANIO_MAYOR | CANTIDAD
--
-- ****************************************************************************************************************** --

-- EXPLAIN ANALYZE
WITH cte AS (SELECT r.customer_id,
                    COUNT(r.rental_id)   AS count,
                    MONTH(r.rental_date) AS month,
                    YEAR(r.rental_date)  AS year
             FROM rental r
             GROUP BY r.customer_id,
                      MONTH(r.rental_date),
                      YEAR(r.rental_date)
             HAVING COUNT(r.rental_id) = (SELECT MAX(count)
                                          FROM (SELECT r.customer_id,
                                                       COUNT(r.rental_id) AS count
                                                FROM rental r
                                                GROUP BY r.customer_id,
                                                         MONTH(r.rental_date),
                                                         YEAR(r.rental_date)) AS counts
                                          WHERE counts.customer_id = r.customer_id))
SELECT c.customer_id     id_cliente,
       c.last_name    AS apellido,
       c.first_name   AS nombre,
       ctd.CTD_TOTAL  AS ctd_total,
       MAX(cte.month) AS mes_mayor,
       MAX(cte.year)  AS anio_mayor,
       MAX(cte.count) AS cantidad
FROM customer c
         JOIN (SELECT r.customer_id,
                      COUNT(r.rental_id) AS CTD_TOTAL
               FROM rental r
               GROUP BY r.customer_id) ctd ON c.customer_id = ctd.customer_id
         JOIN cte
              ON c.customer_id = cte.customer_id
WHERE c.customer_id NOT IN (SELECT r.customer_id FROM rental r WHERE r.return_date IS NULL)
GROUP BY c.customer_id, ctd.CTD_TOTAL, APELLIDO, NOMBRE
ORDER BY APELLIDO, NOMBRE;