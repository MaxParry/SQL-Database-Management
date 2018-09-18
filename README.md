# SQL Database Management
![SQL Graphic](images/SQL_graphic.jpg)

In this demonstration, I will run a variety of SQL queries to manage a DVD rental database. I will ask a question in plain english, then write an SQL query to answer it.

## Database
The Sakila database is a sample database created in 2006, included with MySQL. It represents a DVD rental store.

## Schema

* A schema is also available as `sakila_schema.svg` in the images folder. Open it with a browser to view. The following tables are present in the database:

```sql
	'actor'
	'actor_info'
	'address'
	'category'
	'city'
	'country'
	'customer'
	'customer_list'
	'film'
	'film_actor'
	'film_category'
	'film_list'
	'film_text'
	'inventory'
	'language'
	'nicer_but_slower_film_list'
	'payment'
	'rental'
	'sales_by_film_category'
	'sales_by_store'
	'staff'
	'staff_list'
	'store'
```

## Queries

### Basic Query and Column Manipulation

* 1a. Display the first and last names of all actors from the table `actor`. 

```sql
    USE sakila;
    SELECT first_name, last_name FROM actor;
```

* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 

```sql
    SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name FROM actor;
```
### Database Search

* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

```sql
   SELECT first_name, last_name, actor_id FROM actor WHERE first_name='Joe'; 
```
  	
* 2b. Find all actors whose last name contain the letters `GEN`:

```sql
    SELECT first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
```
  	
* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

```sql
    SELECT first_name, last_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY first_name, last_name;
```

* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

```sql
    SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
```

### Database Alteration

* 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`.

```sql
    ALTER TABLE actor
    ADD middle_name VARCHAR(30);
```
  	
* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

```sql
    ALTER TABLE actor
    MODIFY COLUMN middle_name BLOB;
```

* 3c. Now delete the `middle_name` column.

```sql
    ALTER TABLE actor
    DROP COLUMN middle_name;
```

### Counting and Record Remediation

* 4a. List the last names of actors, as well as how many actors have that last name.

```sql
    SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;
```
  	
* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

```sql
    SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;
```
  	
* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

```sql
    SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'GROUCHO';

    UPDATE actor
    SET first_name = 'HARPO'
    WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
```
  	
* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

```sql
    UPDATE actor
    SET first_name = 'GROUCHO'
    WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
```

### Schema Viewing

* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

```sql
    DESCRIBE sakila.address;
```

### Filtering and Data Aggregation with JOINs
* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

```sql
    SELECT staff.first_name, staff.last_name, address.address FROM staff JOIN address ON staff.address_id = address.address_id;
```

* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

```sql
    SELECT staff.first_name, staff.last_name, SUM(payment.amount) FROM staff JOIN payment ON staff.staff_id = payment.staff_id GROUP BY staff.staff_id;
```
  	
* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

```sql
    SELECT film.title, COUNT(film_actor.actor_id) FROM film JOIN film_actor ON film.film_id = film_actor.actor_id GROUP BY film.film_id;
```
  	
* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

```sql
    SELECT film.title, COUNT(inventory.film_id) FROM inventory JOIN film ON inventory.film_id = film.film_id GROUP BY film.title HAVING film.title = 'HUNCHBACK IMPOSSIBLE';
```

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

```sql
    SELECT customer.first_name, customer.last_name, SUM(payment.amount) FROM customer JOIN payment ON customer.customer_id = payment.customer_id GROUP BY customer.customer_id ORDER BY customer.last_name;
```

![Total amount paid](images/total_payment.png)

### Filtering and Data Aggregation with Subqueries

* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

```sql
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
```

* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

```sql
    SELECT actor.first_name, actor.last_name 
    FROM actor 
    WHERE actor.actor_id IN (
	    SELECT film_actor.actor_id
        FROM film_actor
        WHERE film_actor.film_id IN (
		    SELECT film.film_id
            FROM film
            WHERE film.title = 'Alone Trip'));
```
   
* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

```sql
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
```

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

```sql
    SELECT film.title
    FROM film
    WHERE film.film_id IN (
	    SELECT film_category.film_id
        FROM film_category
        WHERE film_category.category_id IN (
		    SELECT category.category_id
            FROM category
            WHERE category.name = 'Family'));
```

* 7e. Display the most frequently rented movies in descending order.

```sql
    SELECT film.title, COUNT(rental.rental_id) AS times_rented
    FROM rental
    LEFT JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
    LEFT JOIN film
    ON inventory.film_id = film.film_id
    GROUP BY film.title
    ORDER BY COUNT(rental.rental_id) DESC;
```
  	
* 7f. Write a query to display how much business, in dollars, each store brought in.

```sql
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
```

* 7g. Write a query to display for each store its store ID, city, and country.

```sql
    SELECT store.store_id, city.city, country.country
    FROM store
    LEFT JOIN address
    ON store.address_id = address.address_id
    LEFT JOIN city
    ON address.city_id = city.city_id
    LEFT JOIN country
    ON city.country_id = country.country_id
    GROUP BY store.store_id;
```
  	
* 7h. List the top five genres in gross revenue in descending order.

```sql
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
```

### Creating and Deleting Views

* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Create a view for easy reference.

```sql
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
```
  	
* 8b. How would you display the view that you just created?

```sql
    SELECT * FROM top_5_grossing;
```

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

```sql
    DROP VIEW top_5_grossing;
```

