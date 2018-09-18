-- SQL Database Management Demonstration

-- 1a:

USE sakila;

SELECT first_name, last_name FROM actor;

-- 1b:

SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name FROM actor;

-- 2a:

SELECT first_name, last_name, actor_id FROM actor WHERE first_name='Joe';

-- 2b:

SELECT first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';

-- 2c:

SELECT first_name, last_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY first_name, last_name;

-- 2d:

SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a*:

ALTER TABLE actor
ADD middle_name VARCHAR(30);

-- 3b:

ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- 3c:

ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a:

SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;

-- 4b:

SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;

-- 4c:

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'GROUCHO';

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d:

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a:

DESCRIBE sakila.address;

-- 6a:

SELECT staff.first_name, staff.last_name, address.address FROM staff JOIN address ON staff.address_id = address.address_id;

-- 6b:

SELECT staff.first_name, staff.last_name, SUM(payment.amount) FROM staff JOIN payment ON staff.staff_id = payment.staff_id GROUP BY staff.staff_id;

-- 6c:

SELECT film.title, COUNT(film_actor.actor_id) FROM film JOIN film_actor ON film.film_id = film_actor.actor_id GROUP BY film.film_id;

-- 6d:

SELECT film.title, COUNT(inventory.film_id) FROM inventory JOIN film ON inventory.film_id = film.film_id GROUP BY film.title HAVING film.title = 'HUNCHBACK IMPOSSIBLE';

-- 6e:

SELECT customer.first_name, customer.last_name, SUM(payment.amount) FROM customer JOIN payment ON customer.customer_id = payment.customer_id GROUP BY customer.customer_id ORDER BY customer.last_name;

-- 7a:

SELECT film.title 
FROM film 
WHERE film.title LIKE 'K%' 
OR film.title LIKE 'Q%' 
AND film.title IN (
		SELECT film.title 
		FROM film 
		WHERE film.language_id
		IN (
			SELECT language_id 
            FROM language
            WHERE language.name = 'english'));
            
-- 7b:

SELECT actor.first_name, actor.last_name 
FROM actor 
WHERE actor.actor_id IN (
	SELECT film_actor.actor_id
    FROM film_actor
    WHERE film_actor.film_id IN (
		SELECT film.film_id
        FROM film
        WHERE film.title = 'Alone Trip'));
        
-- 7c:

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address
ON customer.address_id = address.address_id
WHERE address.city_id IN (
	SELECT city.city_id
    FROM city
    WHERE city.country_id IN (
		SELECT country.country_id
        FROM country
        WHERE country.country = 'Canada'));
        
-- 7d:

SELECT film.title
FROM film
WHERE film.film_id IN (
	SELECT film_category.film_id
    FROM film_category
    WHERE film_category.category_id IN (
		SELECT category.category_id
        FROM category
        WHERE category.name = 'Family'));

-- 7e:

SELECT film.title, COUNT(rental.rental_id) AS times_rented
FROM rental
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film
ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f:

SELECT store.store_id, SUM(payment.amount)
FROM payment
LEFT JOIN rental
ON payment.rental_id = rental.rental_id
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
LEFT JOIN store
ON inventory.store_id = store.store_id
GROUP BY store.store_id
ORDER BY SUM(payment.amount) DESC;

-- 7g:

SELECT store.store_id, city.city, country.country
FROM store
LEFT JOIN address
ON store.address_id = address.address_id
LEFT JOIN city
ON address.city_id = city.city_id
LEFT JOIN country
ON city.country_id = country.country_id
GROUP BY store.store_id;

-- 7h:

SELECT category.name, SUM(payment.amount)
FROM payment
LEFT JOIN rental
ON payment.rental_id = rental.rental_id
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film_category
ON inventory.film_id = film_category.film_id
LEFT JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC;

-- 8a:

CREATE VIEW top_5_grossing AS
SELECT category.name, SUM(payment.amount)
FROM payment
LEFT JOIN rental
ON payment.rental_id = rental.rental_id
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film_category
ON inventory.film_id = film_category.film_id
LEFT JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC;

-- 8b:

SELECT * FROM top_5_grossing;

-- 8c:

DROP VIEW top_5_grossing;
