#######################################################################################################################
-- Seleccionar todos los clientes (apellido y nombre) cuyo pagos promedios historicos
-- sean mayores que los pagos promedios de todos los clientes

-- acternativa 1
SELECT c.first_name nombre,
       c.last_name apellido,
       -- SUM(p.amount) pagos_totales,
       -- COUNT(p.amount) ctd_pagos,
       SUM(p.amount)/COUNT(p.amount) promedio_pagos
FROM customer c
JOIN payment p on c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY promedio_pagos DESC ;

#######################################################################################################################
-- Seleccionar el/los actor/es que participo en peliculas de todos las categorias
-- alternativa 1
with cte as (
select fa.actor_id
from film_actor fa
join film_category fc on fa.film_id = fc.film_id
group by fa.actor_id
having count(distinct fc.category_id) = (select count(*) from category c))
select a.first_name nombre,
       a.last_name apellido
from actor a, cte
where a.actor_id = cte.actor_id;

-- alternativas profe
select first_name,last_name from actor ac where ac.actor_id in
(select a.actor_id from
   actor a
   join film_actor fa on a.actor_id = fa.actor_id
   join film_category fc on fc.film_id = fa.film_id
   group by a.actor_id
having count(distinct fc.category_id) = (select count(*) from category)
);
#Mas ineficiente

select first_name,last_name from actor ac,
 (select count(distinct fc.category_id) cancat,a.actor_id aid from
   actor a
   join film_actor fa on a.actor_id = fa.actor_id
   join film_category fc on fc.film_id = fa.film_id
   group by a.actor_id
 having  cancat = (select count(*) from category)
 ) res
where ac.actor_id =res.aid;
#Mas eficiente

#######################################################################################################################
-- Seleccionar el/los actor/es que participo en peliculas de mas de 3 categorias
-- alternativa 1
with cte as (
select fa.actor_id
from film_actor fa
join film_category fc on fa.film_id = fc.film_id
group by fa.actor_id
having count(distinct fc.category_id) > 3)
select a.first_name nombre,
       a.last_name apellido
from actor a, cte
where a.actor_id = cte.actor_id;

-- alternativa profe
select first_name,last_name from actor ac,
 (select count(distinct fc.category_id) cancat,a.actor_id aid from
   actor a
   join film_actor fa on a.actor_id = fa.actor_id
   join film_category fc on fc.film_id = fa.film_id
   group by a.actor_id
 having  cancat >= 3
 ) res
where ac.actor_id =res.aid;

-- Seleccionar los clientes que deben retornar videos
-- alternativa 1
select c.first_name, c.last_name
   from rental r
   join customer c on c.customer_id = r.customer_id
   join inventory i on i.inventory_id = r.inventory_id
   join film f on f.film_id = i.film_id
where return_date is null
    and adddate(r.rental_date, f.rental_duration) < now();