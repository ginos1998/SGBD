-- ############# SELECCIONAR LOS ACTORES QUE ACTUARON AL MENOS EN UNA PELICULA QUE DURE MENOS DE 70 min ############# --

-- alternativa 1
SELECT a.first_name nombre,
       a.last_name  apellido
FROM actor a
WHERE EXISTS(SELECT 1
             FROM film_actor fa
             WHERE fa.actor_id = a.actor_id
               AND EXISTS(SELECT 1 FROM film f WHERE f.film_id = fa.film_id AND f.length < 70))
ORDER BY nombre, apellido;
-- alternativa 2
SELECT a.first_name nombre,
       a.last_name  apellido
FROM actor a
WHERE EXISTS(SELECT 1
             FROM film f
                      JOIN film_actor fa on f.film_id = fa.film_id
             WHERE fa.actor_id = a.actor_id
               AND f.length < 70)
ORDER BY nombre, apellido;

-- #########  SELECCIONAR LOS 5 ACTORES QUE MAS TIEMPO ACTUARON SUMANDO LA DURACION DE TODAS SUS PELICULAS ######### --
-- alternativa 1
explain analyze
select a.first_name       nombre,
       a.last_name        apellido,
       count(fa.actor_id) participaciones,
       sum(f.length)      duracion
from actor a
         left join film_actor fa on a.actor_id = fa.actor_id
         left join film f on f.film_id = fa.film_id
group by fa.actor_id, a.first_name, a.last_name
order by duracion desc
LIMIT 5 OFFSET 0;

-- alternativa 2
select a.first_name,
       a.last_name,
       duracion_total
from actor a,
     (select sum(length) duracion_total, actor_id
      from film f
               join film_actor fa
                    on f.film_id = fa.film_id
      group by actor_id) len
where a.actor_id = len.actor_id
order by duracion_total desc
limit 5;

-- ################## SELECCIONAR LA/S PELICULA/S EN LA QUE ACTUARON MAS ACTORES ################## --
-- alternativa 1
WITH cte AS (SELECT count(fa.actor_id) ctd_part, fa.film_id
             FROM actor a
                      LEFT JOIN film_actor fa on a.actor_id = fa.actor_id
             GROUP BY fa.film_id)
SELECT title        titulo,
       cte.ctd_part participaciones
FROM film f
         LEFT JOIN cte ON f.film_id = cte.film_id
ORDER BY participaciones DESC
LIMIT 1;

-- ################# MOSTRAR LOS ACTORES QUE ACTUARON EN LA/S PELICULA/S MAS LARGA/S ################# --
-- alternativa 1
SELECT *
FROM actor a
WHERE EXISTS(SELECT 1
             FROM film_actor fa
             WHERE fa.actor_id = a.actor_id
               AND EXISTS(
                     WITH cte AS (SELECT MAX(f.length) dur_max FROM film f)
                     SELECT 1
                     FROM film f,
                          cte
                     WHERE f.length = cte.dur_max
                       AND f.film_id = fa.film_id
                 ))
ORDER BY a.first_name;