-- agrupa la primera letra de los apellidos e indica cuantos apellidos empiezan con esa letra
SELECT substr(a.last_name, 1, 1), count(*)
FROM actor AS a
GROUP BY substr(a.last_name, 1, 1);

-- lo mismo que antes, pero ahora solo las cantidades mayores a 10, con un limite de 5 ordenados DESC
SELECT substr(a.last_name, 1, 1), count(*)
FROM actor AS a
GROUP BY substr(a.last_name, 1, 1)
HAVING COUNT(*) > 10
ORDER BY COUNT(*) DESC
LIMIT 5;

-- ################### Sintaxis equivalentes, consultando sobre dos tablas ################### --
SELECT *
FROM store ste, staff stf
WHERE ste.store_id = stf.store_id;

SELECT *
FROM staff stf JOIN store ste
ON stf.store_id = ste.store_id;

SELECT *
FROM staff stf JOIN store ste USING (store_id);

SELECT first_name, last_name, ads.address, c.city
FROM staff stf JOIN store ste
ON stf.store_id = ste.store_id
JOIN address ads
ON ads.address_id = ste.address_id
JOIN city c ON ads.city_id = c.city_id;

-- ################### PAGOS NO ASOCIADOS A UNA RENTA
SELECT *
FROM payment pay
WHERE rental_id IS NULL;

-- pagos con renta
SELECT count(*)
FROM payment pay
JOIN rental r on r.rental_id = pay.rental_id;

-- pagos con y sin renta (diferencia de 5)
SELECT count(*)
FROM payment pay
LEFT JOIN rental r on r.rental_id = pay.rental_id
ORDER BY r.rental_id;

SELECT *
FROM payment pay
RIGHT JOIN rental r on r.rental_id = pay.rental_id





