-- Display the first and last names of all actors from the table actor
SELECT first_name, last_name FROM actor;

-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT CONCAT(first_name, ' ',last_name) AS 'Actor Name' FROM actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT * FROM actor WHERE first_name LIKE 'Joe';

-- Find all actors whose last name contain the letters GEN
SELECT * FROM actor WHERE last_name LIKE '%gen%';

-- Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name;

-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country WHERE country IN ('Afghanistan','Bangladesh','China');

-- You want to keep a description of each actor. You don't think you will be performing queries on a description, soo create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE `actor` 
ADD COLUMN `description` BLOB NOT NULL AFTER `Actor_Name`;

-- Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE `actor` 
DROP COLUMN `description`;

-- List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS 'Count'
WHERE COUNT(last_name) >= 2
FROM actor
GROUP BY last_name;

-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS 'Count'
FROM actor
GROUP BY last_name;

-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record
UPDATE actor SET first_name = 'Harpo' WHERE first_name = 'Groucho';

-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name = 'Groucho' WHERE first_name = 'Harpo';

-- Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
SELECT first_name, last_name, address
FROM staff
JOIN address
USING (address_id);

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
SELECT first_name,last_name,SUM(amount) AS 'Total'
FROM staff
JOIN payment
USING (staff_id)
WHERE payment_date LIKE '2005-08%'
GROUP BY first_name, last_name;

-- List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(actor_id) AS 'Total Actors'
FROM film
INNER JOIN film_actor
USING (film_id)
GROUP BY title;

-- How many copies of the film Hunchback Impossible exist in the inventory sysfilm_idtem?
SELECT title, COUNT(film_id) AS 'Number of copies'
FROM film
JOIN inventory
USING (film_id)
WHERE title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY title;

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name,last_name,SUM(amount) AS 'Total Paid'
FROM customer
JOIN payment
USING (customer_id)
GROUP BY first_name,last_name
ORDER BY last_name;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE language_id IN
(
	SELECT language_id
    FROM language
    WHERE name = 'English');

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
	)
);

-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name,last_name,email
FROM customer
JOIN address
USING (address_id);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
		(
			SELECT category_id
            FROM category
            WHERE name = 'Family')
            );
            
-- Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental_id) AS 'Number of Rentals' 
from film
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
GROUP BY title
ORDER BY COUNT(rental_id) DESC;

-- Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

-- Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country
USING (country_id);

-- List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name, SUM(amount) AS 'Gross'
FROM payment
JOIN rental
USING (rental_id)
JOIN inventory
USING (inventory_id)
JOIN film_category
USING (film_id)
JOIN category
USING (category_id)
GROUP BY name
ORDER BY 'Gross' DESC
LIMIT 5;

-- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_film_genres AS
SELECT name, SUM(amount) AS 'Gross'
FROM payment
JOIN rental
USING (rental_id)
JOIN inventory
USING (inventory_id)
JOIN film_category
USING (film_id)
JOIN category
USING (category_id)
GROUP BY name
ORDER BY 'Gross' DESC
LIMIT 5;

-- How would you display the view that you created in 8a?
SELECT * FROM top_film_genres;

-- You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_film_genres;

