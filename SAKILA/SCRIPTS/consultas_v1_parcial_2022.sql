# Realizar una consulta que genere un reporte de la perfomance de cada tienda
# (store), empleado y film por cada combinación válida de estos tres
# (tener en cuenta que un empleado sólo trabaja en una tienda )
# indicar cuanto se recaudó y cuantos alquileres se realizaron,
# si para una combinación válida de tienda, empleado y film no se registran alquileres y/o recaudación se deberá poner 0, no se admitirá null.

-- yo entendi que pedia el total de cada tienda...
WITH cte AS (
    SELECT p.staff_id,
           SUM(amount) AS recaudado
    FROM payment p
    GROUP BY p.staff_id
)
SELECT str.store_id AS id_tienda,
       stf.staff_id AS id_personal,
       stf.first_name AS nombre,
       stf.last_name AS apellido,
       COUNT(r.rental_id) AS ctd_alquileres,
       recaudado
FROM store str
    LEFT JOIN staff stf ON str.store_id = stf.store_id
    LEFT JOIN rental r on stf.staff_id = r.staff_id
    LEFT JOIN cte ON stf.staff_id = cte.staff_id
GROUP BY stf.staff_id, str.store_id, stf.first_name, stf.last_name;

-- pero el profe lo hizo por pelicula asique vamo a juga
WITH cte AS (
    SELECT fi.film_id,
           fi.title,
           COALESCE(sum(pay.amount), 0) monto_recaudado,
           COALESCE(COUNT(re.rental_id), 0) AS ctd_alquileres,
           inv.store_id
FROM film fi
LEFT JOIN inventory inv USING (film_id)
LEFT JOIN rental re USING(inventory_id)
LEFT JOIN payment pay USING(rental_id)
GROUP BY film_id, store_id
)
SELECT str.store_id,
       stf.first_name,
       stf.last_name,
       cte.title,
       monto_recaudado,
       ctd_alquileres
FROM staff stf
    LEFT JOIN store str on stf.staff_id = str.manager_staff_id
    LEFT JOIN cte ON str.store_id = cte.store_id;

-- para chequear, descomentar la sig. linea y debe haber 2 rtdos (1 por cada tienda)
-- WHERE cte.title = 'ACADEMY DINOSAUR';
