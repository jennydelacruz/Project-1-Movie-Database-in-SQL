/*JENNIFER DE LA CRUZ*/

/* QUESTION 1
We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children,
Classics, Comedy, Family and Music.

What is the total number of rental orders for family-friendly film categories,
for all available data?*/

SELECT
  c.name category,
  COUNT(rental_id) rental_count
FROM
  category c
  JOIN film_category fc
  ON c.category_id = fc.category_id
  JOIN film f
  ON f.film_id = fc.film_id
  JOIN inventory i
  ON f.film_id = i.film_id
  JOIN rental r
  ON i.inventory_id = r.inventory_id
WHERE
  c.name IN('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY
  1
ORDER BY
  1;

/*QUESTION 2

Provide a table with the family-friendly film category, each of the
quartiles, and the corresponding count of movies within each combination of film
category for each corresponding rental duration category.

Based on rental duration, how do family-friendly films distribute across quartiles?*/

SELECT
  name film_name,
  COUNT(name) film_count,
  quartile
FROM
  (SELECT
    title,
    name,
    rental_duration,
    NTILE(4) OVER (ORDER BY rental_duration) AS quartile
  FROM
      (SELECT
        f.title,
        f.rental_duration,
        c.name
      FROM
        category c
        JOIN film_category fc
        ON c.category_id = fc.category_id
        JOIN film f
        ON f.film_id = fc.film_id) sub
    WHERE name IN('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))t1
GROUP BY
  1,
  3
ORDER BY
  1,
  3;



/*QUESTION 3
 Write a query that returns the store ID for the store, the year and month and
 the number of rental orders each store has fulfilled for that month. Your table
  should include a column for each of the following: year, month, store ID and
  count of rental orders fulfilled during that month.

How do both stores compare in terms of number of rentals by month each year? */

  SELECT
    DATE_PART('month',r.rental_date) AS month,
    DATE_PART('year',r.rental_date) AS year,
    store.store_id,
    COUNT(r.*) count_rentals
  FROM
    store
    JOIN staff
    ON staff.store_id = store.store_id
    JOIN payment p
    ON staff.staff_id = p.staff_id
    JOIN rental r
    ON r.rental_id = p.rental_id
  GROUP BY
    year,
    month,
    store.store_id
  ORDER BY
    count_rentals DESC;


/*QUESTION 4

We want to understand renting patterns per year, for non-family films
(assuming non-family categories as: Action, Drama, Horror, Sci-Fi, Sports, Travel)

What is the total amount of rented films per year, per film category,
for non-family friendly films? What are the most popular categories? */

WITH t1 AS
  (SELECT
    c.name,
    r.rental_id,
    r.rental_date
  FROM
    category c
    JOIN film_category fc
    ON c.category_id = fc.category_id
    JOIN film f
    ON f.film_id = fc.film_id
    JOIN inventory i
    ON f.film_id = i.film_id
    JOIN rental r
    ON i.inventory_id = r.inventory_id)
SELECT
  name,
  COUNT(rental_id),
  DATE_PART('year',rental_date) AS year
FROM
  t1
WHERE
  name IN('Action', 'Drama', 'Horror', 'Sci-Fi', 'Sports', 'Travel')
GROUP BY
  1,
  3
ORDER BY
  1,
  3;
