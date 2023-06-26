# Consulta para ver en qué películas actúan los actores
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       f.title
FROM actor a
         LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
         LEFT JOIN film f ON f.film_id = fa.film_id;

# Consulta para saber cual es el actor que más films tuvo, primero se tiene que saber en cuantos films actuó cada actor
WITH cte AS (SELECT a.actor_id,
                    a.first_name,
                    a.last_name,
                    COUNT(a.actor_id) AS ctd_films
             FROM actor a
                      LEFT JOIN film_actor fa on a.actor_id = fa.actor_id
                      LEFT JOIN film f on fa.film_id = f.film_id
             GROUP BY a.actor_id)
SELECT *
FROM cte
ORDER BY ctd_films DESC
LIMIT 1;

# Consulta para ver por customer, cuanto monto pago y decir que los que gastaron
# mas que un monto es de tipo alto, medio o bajo
SELECT c.customer_id                                              AS id_cliente,
       c.first_name                                               AS nombre,
       c.last_name                                                AS apellido,
       SUM(p.amount)                                              AS gasto,
       (CASE WHEN SUM(p.amount) > 90 THEN 'ALTO' ELSE 'BAJO' END) AS tipo_gasto
FROM customer c
         LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

# 1) Realizar una consulta donde se listen todos los clientes (customer) con su
#nombre y apellido, y sus direcciones, las direcciones deberan mostrar los campos
# "address" y "address", el nombre de la ciudad y el pais
# una columna con la cantidad de alquileres (rental) por cliente.
# ordenado por ciudad y pais

SELECT ctm.customer_id    AS id_cliente,
       ctm.first_name     AS nombre,
       ctm.last_name      AS apellido,
       a.address          AS direccion,
       a.address2         AS direccion_2,
       city.city          AS ciudad,
       ctry.country       AS pais,
       COUNT(r.rental_id) AS ctd_alquileres
FROM customer ctm
         LEFT JOIN address a on ctm.address_id = a.address_id
         LEFT JOIN city on a.city_id = city.city_id
         LEFT JOIN country ctry on city.country_id = ctry.country_id
         LEFT JOIN rental r on ctm.customer_id = r.customer_id
GROUP BY ctm.customer_id, city.city, ctry.country
ORDER BY city.city, ctry.country;

/* Consulta 1 de ejemplo que salió en un parcial: Implemente una consulta sobre la
base de datos “SAKILA” que retorne un listado donde cada ciudad de la tabla “city”
tendrá un renglón, debiendo figurar todas las ciudades.
El listado tendrá las siguientes columnas:
- Nombre de la ciudad
- Nombre del pais a la que pertenece
- Cantidad de clientes que residen en la ciudad
- Monto total recaudado en esa ciudad */

SELECT cty.city              AS ciudad,
       ctry.country          AS pais,
       COUNT(cm.customer_id) AS ctd_clientes,
       SUM(p.amount)         AS recaudado
FROM city cty
         LEFT JOIN country ctry on ctry.country_id = cty.country_id
         LEFT JOIN address a on cty.city_id = a.city_id
         LEFT JOIN customer cm on a.address_id = cm.address_id
         LEFT JOIN payment p on cm.customer_id = p.customer_id
GROUP BY cty.city_id
ORDER BY recaudado DESC, ctd_clientes;

# Consulta para sacar el promedio de pago por cliente
# Y despues hay que mostrar todos los pagos que se hicieron que fueron mayores al
#promedio de cada cliente

SELECT cm.customer_id                  AS id_cliente,
       cm.first_name                   AS nombre,
       cm.last_name                    AS apellido,
       SUM(p.amount)                   AS gasto_total,
       COUNT(p.amount)                 AS ctd_pagos,
       SUM(p.amount) / COUNT(p.amount) AS promedio_pago,
       MAX(p.amount)                   AS pago_max
FROM customer cm
         LEFT JOIN payment p on cm.customer_id = p.customer_id
GROUP BY cm.customer_id;
