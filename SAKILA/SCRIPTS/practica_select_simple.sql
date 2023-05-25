-- 1) Realizar una consulta donde se listen todos los clientes (customer) con su nombre y apellido, y sus direcciones,
--    las direcciones deberan mostrar los campos "address" y "address", el nombre de la ciudad y el pais.
select c.first_name as nombre,
       c.last_name  as apellido,
       a.address    as direccion,
       a.district   as distrito,
       cty.city     as ciudad,
       ctr.country  as pais
from customer c
         join address a on a.address_id = c.address_id
         join city cty on a.city_id = cty.city_id
         join country ctr on cty.country_id = ctr.country_id;

-- 2) Mostrar el listado del punto 1 ordenado por ciudad y pais
select c.first_name as nombre,
       c.last_name  as apellido,
       a.address    as direccion,
       a.district   as distrito,
       cty.city     as ciudad,
       ctr.country  as pais
from customer c
         join address a on a.address_id = c.address_id
         join city cty on a.city_id = cty.city_id
         join country ctr on cty.country_id = ctr.country_id
order by ctr.country, cty.city;

-- 3) Mostrar el listado del punto anterior agregando una columna con la cantidad de alquileres (rental) por cliente.
select c.first_name    as nombre,
       c.last_name     as apellido,
       a.address       as direccion,
       a.district      as distrito,
       cty.city        as ciudad,
       ctr.country     as pais,
       (r.customer_id) as ctdAlquileres
from customer c
         join address a on a.address_id = c.address_id
         join city cty on a.city_id = cty.city_id
         join country ctr on cty.country_id = ctr.country_id
         join rental r ON r.customer_id = c.customer_id
group by r.customer_id
having count(r.customer_id)
order by ctr.country, cty.city;

-- 4) Mostrar el listado del pto. anterior agregando una columna con el total de pagos hecho por cada cliente,
--    (no tomar en cuenta el atributo "customer_id" de la tabla "payments")
select c.first_name    as nombre,
       c.last_name     as apellido,
       a.address       as direccion,
       a.district      as distrito,
       cty.city        as ciudad,
       ctr.country     as pais,
       (r.customer_id) as ctdAlquileres,
       sum(p.amount)   as totalPagos
from customer c
         join address a on a.address_id = c.address_id
         join city cty on a.city_id = cty.city_id
         join country ctr on cty.country_id = ctr.country_id
         join rental r ON r.customer_id = c.customer_id
         left join payment p on r.rental_id = p.rental_id
group by r.customer_id
having count(r.customer_id)
order by ctr.country, cty.city;

-- 5) Mostrar el listado del punto anterior dejando solo aquellos registros que correspondan a alquileres realizados durante el mes de mayo.
select c.first_name    as nombre,
       c.last_name     as apellido,
       a.address       as direccion,
       a.district      as distrito,
       cty.city        as ciudad,
       ctr.country     as pais,
       (r.customer_id) as ctdAlquileres,
       sum(p.amount)   as totalPagos
from customer c
         join address a on a.address_id = c.address_id
         join city cty on a.city_id = cty.city_id
         join country ctr on cty.country_id = ctr.country_id
         join rental r ON r.customer_id = c.customer_id
         left join payment p on r.rental_id = p.rental_id
WHERE month(r.rental_date) = 5
group by r.customer_id
having count(r.customer_id)
order by ctr.country, cty.city;

-- 6) Mostrar el listado del punto anterior mostrando solo los clientes de ese listado que gastaron mas de 10 pesos.
select c.first_name    as nombre,
       c.last_name     as apellido,
       a.address       as direccion,
       a.district      as distrito,
       cty.city        as ciudad,
       ctr.country     as pais,
       (r.customer_id) as ctdAlquileres,
       sum(p.amount)   as totalPagos
from customer c
         join address a on a.address_id = c.address_id
         join city cty on a.city_id = cty.city_id
         join country ctr on cty.country_id = ctr.country_id
         join rental r ON r.customer_id = c.customer_id
         left join payment p on r.rental_id = p.rental_id
WHERE month(r.rental_date) = 5
group by r.customer_id
having count(r.customer_id) AND totalPagos > 10
order by ctr.country, cty.city;

-- 7) Mostrar el listado del punto anterior mostrando solo los 10 clientes de ese listado que mas gastaron.

WITH cte AS (
select c.first_name    as nombre,
       c.last_name     as apellido,
       a.address       as direccion,
       a.district      as distrito,
       cty.city        as ciudad,
       ctr.country     as pais,
       (r.customer_id) as ctdAlquileres,
       sum(p.amount)   as totalPagos
from customer c
         join address a on a.address_id = c.address_id
         join city cty on a.city_id = cty.city_id
         join country ctr on cty.country_id = ctr.country_id
         join rental r ON r.customer_id = c.customer_id
         left join payment p on r.rental_id = p.rental_id
WHERE month(r.rental_date) = 5
group by r.customer_id
having count(r.customer_id) AND totalPagos > 10
order by totalPagos desc
LIMIT 10 OFFSET 0)
SELECT *
FROM cte
ORDER BY pais, ciudad;