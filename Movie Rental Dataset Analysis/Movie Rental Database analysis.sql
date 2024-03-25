Use movie_rentals;

/*
1	Extract a count of active customers for each of your stores. (Separately) 
*/

SELECT
store_id AS Store,
COUNT(CASE
WHEN active =1 THEN customer_id ELSE NULL END) AS Active_Customers
FROM customer
GROUP BY store_id;


# Alternative Solution -

SELECT
store_id AS Store,
COUNT(customer_id) AS Active_Customers
FROM customer
WHERE active = 1
GROUP BY store_id;


/*
2.	Provide a count of unique film titles in the inventory at each store 
and then provide a count of the unique categories of films you provide. 
*/

SELECT 
store_id AS Store,
COUNT(DISTINCT film_id) AS Unique_films
FROM inventory
GROUP BY store_id;

SELECT 
COUNT(DISTINCT category_id) AS Unique_categories
FROM film_category;

/*
3.	Provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry.
*/

SELECT
MAX(replacement_cost) AS Film_with_max_replacement_cost,
MIN(replacement_cost) AS Film_with_min_replacement_cost,
AVG(replacement_cost) AS Film_with_max_replacement_cost
FROM film;

/*
4. Provide the average payment processed and the maximum payment processed.
*/

SELECT 
AVG(amount) AS Avg_payment_processed,
MAX(amount) AS Max_payment_processed
FROM payment;

/*
5. Provide a list of all customer identification values, with a count of rentals 
they have made all-time, with the highest volume customers at the top of the list.
*/

SELECT 
customer_id,
COUNT(rental_id) AS Total_rentals
FROM rental
GROUP BY customer_id
ORDER BY COUNT(rental_id) DESC;

/* 
6. Provide managers’ names at each store, with the full address 
of each property (street address, district, city, and country). [Use Left Join]
*/ 

SELECT 
store.store_id AS Store,
CONCAT(staff.first_name, " ", staff.last_name) AS Manager_name,
address.address,
address.district,
city.city, 
country.country
FROM store
LEFT JOIN staff
ON store.store_id = staff.store_id
LEFT JOIN Address
ON store.address_id = Address.address_id
LEFT JOIN city
ON address.city_id = city.city_id
LEFT JOIN country 
ON city.country_id = country.country_id;

/*
7. Provide a list of each inventory item in the stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate 
and replacement cost. [Use Left Join]
*/

SELECT 
inventory.store_id AS Store,
inventory.inventory_id,
film.title,
film.rating,
film.rental_rate,
film.replacement_cost
FROM inventory
LEFT JOIN film
ON inventory.film_id = film.film_id;

/* 
8.	Provide quantity of inventory items with each rating at each store. 
*/

SELECT
inventory.store_id AS Store,
film.rating,
COUNT(inventory.inventory_id) AS Total_items
FROM 
inventory, 
film
WHERE inventory.film_id = film.film_id
GROUP BY 
inventory.store_id, 
film.rating
ORDER BY inventory.store_id;

/* 
9. Provide the number of films, as well as the average replacement cost, 
and total replacement cost, sliced by store and film category. 
*/ 

SELECT
inventory.store_id AS Store,
category.name AS Film_category,
COUNT(inventory.inventory_id) AS Total_films,
AVG(film.replacement_cost) AS Avg_repalcement_cost,
SUM(film.replacement_cost) AS Total_replacement_cost
FROM 
inventory,
film,
film_category,
category
WHERE 
inventory.film_id = film.film_id
AND
film.film_id = film_category.film_id
AND 
film_category.category_id = category.category_id
GROUP BY 
inventory.store_id,
category.name
ORDER BY inventory.store_id;

/*
10.	Provide a list of all customer names, which store they go to, whether or not 
they are currently active, and their full addresses – street address, city, and country. 
*/

SELECT 
customer.store_id AS Store,
CONCAT(customer.first_name, " ", customer.last_name) AS Customer_name,
CASE
WHEN customer.active = 1 THEN "Acitve"
WHEN customer.active = 0 THEN "inactive"
ELSE NULL 
END AS Customer_Status,
address.address,
city.city,
country.country
FROM 
customer,
address,
city,
country
WHERE
customer.address_id = address.address_id
AND 
address.city_id = city.city_id
AND 
city.country_id = country.country_id
ORDER BY 1, 2;

/*
11. Provide a list of customer names, their total lifetime rentals, and the sum of 
all payments you have collected from them. Order this on total lifetime value, with 
the most valuable customers at the top of the list. [Use Left Join]
*/

SELECT
CONCAT(customer.first_name, " ", customer.last_name) AS Customer_name,
COUNT(rental.rental_id) AS Total_Rentals,
SUM(payment.amount) AS Total_payments
FROM customer
LEFT JOIN rental
ON customer.customer_id = rental.customer_id
LEFT JOIN payment
ON rental.customer_id = payment.customer_id
GROUP BY 1
ORDER BY 3 DESC; 

/*
12. Provide a list of Investor and Advisor names in one table and note whether they are an 
Investor or an Advisor, and for the Investors, provide the name of company they are working with. 
*/
SELECT
"Investor" AS Designation,
CONCAT(first_name, " ", last_name) AS Name,
company_name
FROM investor

UNION 

SELECT
"Advisor" AS Designation,
CONCAT(first_name, " ", last_name) AS Name,
"N/A" 
FROM advisor;

/*
13. Provide of all actors with three types of awards, along with actors with two types of awards 
and actors with just one award. Also find percentage of the actors in respect to the number of awards.
*/

SELECT
CASE 
WHEN awards = 'Emmy, Oscar, Tony ' THEN '3'
WHEN awards IN ('Emmy, Oscar', 'Emmy, Tony','Oscar, Tony') THEN '2'
ELSE '1'
END AS Awards_won,
ROUND(
(AVG
(CASE
WHEN actor_id IS NULL THEN 0
ELSE 1 END)
),2)*100 AS Percentage_of_actors_with_this_award
FROM actor_award
GROUP BY 1
ORDER BY 1
