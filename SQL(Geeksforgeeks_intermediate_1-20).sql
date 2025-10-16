/*1. Sales Table
The Sales table records information about product sales, including the quantity sold, sale date, and total price for each sale. It serves as a transactional data source for analyzing sales trends.

Query:

-- Create Sales table

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample data into Sales table

INSERT INTO Sales (sale_id, product_id, quantity_sold, sale_date, total_price) VALUES
(1, 101, 5, '2024-01-01', 2500.00),
(2, 102, 3, '2024-01-02', 900.00),
(3, 103, 2, '2024-01-02', 60.00),
(4, 104, 4, '2024-01-03', 80.00),
(5, 105, 6, '2024-01-03', 90.00);

sale_id	product_id	quantity_sold	sale_date	  total_price
1	      101	        5	            2024-01-01	2500.00
2	      102	        3	            2024-01-02	900.00
3	      103	        2	            2024-01-02	60.00
4	      104	        4	            2024-01-03	80.00
5	      105	        6	            2024-01-03	90.00

2. Products Table
The Products table contains details about products, including their names, categories, and unit prices. It provides reference data for linking product information to sales transactions.

Query:

-- Create Products table

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

-- Insert sample data into Products table

INSERT INTO Products (product_id, product_name, category, unit_price) VALUES
(101, 'Laptop', 'Electronics', 500.00),
(102, 'Smartphone', 'Electronics', 300.00),
(103, 'Headphones', 'Electronics', 30.00),
(104, 'Keyboard', 'Electronics', 20.00),
(105, 'Mouse', 'Electronics', 15.00);

product_id	product_name	category	   unit_price
101	        Laptop	      Electronics	 500.00
102	        Smartphone	  Electronics	 300.00
103	        Headphones	  Electronics	 30.00
104	        Keyboard	    Electronics	 20.00
105	        Mouse	        Electronics	 15.00
*/

--1. Calculate the total quantity_sold of products in the 'Electronics' category.
SELECT SUM(Sales.quantity_sold) AS total_quantity_sold FROM Sales JOIN Products ON Sales.product_id = Products.product_id WHERE Products.category = 'Electronics';
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Retrieve the product_name and total_price from the Sales table, calculating the total_price as quantity_sold multiplied by unit_price.
SELECT
    product_name,
    quantity_sold * unit_price AS total_price
FROM
    Sales
JOIN
    Products ON Sales.product_id = Products.product_id;
--or,
SELECT
    P.product_name,
    S.quantity_sold * P.unit_price AS total_price
FROM
    Sales AS S
JOIN
    Products AS P ON S.product_id = P.product_id;
-----------------------------------------------------------------------------------------------------------------------------------------------------
--3. Identify the Most Frequently Sold Product from Sales table
SELECT 
    P.product_name, 
    SUM(S.quantity_sold) AS Most_Frequently_Sold
FROM 
    Products AS P
JOIN 
    Sales AS S ON P.product_id = S.product_id
GROUP BY 
    P.product_name
ORDER BY 
    Most_Frequently_Sold DESC
LIMIT 1;
--or,
SELECT 
    product_id,
    COUNT(*) AS sales_count 
FROM 
    Sales 
GROUP BY 
    product_id 
ORDER BY 
    sales_count DESC 
LIMIT 1;
----------------------------------------------------------------------------------------------------------------------------------------------
--4. Find the Products Not Sold from Products table
SELECT
    product_id,
    product_name
FROM
    Products
WHERE
    product_id NOT IN (
        -- Subquery returns the IDs of all sold products
        SELECT DISTINCT product_id
        FROM Sales
    );
--or,
SELECT
    P.product_id,
    P.product_name
FROM
    Products P
LEFT JOIN
    Sales S ON P.product_id = S.product_id
WHERE
S.sale_id IS NULL;
--or,
SELECT
    P.product_id,
    P.product_name
FROM
    Products P
WHERE
    NOT EXISTS (
        -- Correlated subquery checks if a sale exists for the current product (P)
        SELECT 1
        FROM Sales S
        WHERE S.product_id = P.product_id
    );
---------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Calculate the total revenue generated from sales for each product category.
SELECT P.category, SUM(S.total_price) AS total_revenue FROM Sales AS S JOIN Products AS P ON S.product_id = P.product_id GROUP BY P.category;
----------------------------------------------------------------------------------------------------------------------------------------------------------
--6. Find the product category with the highest average unit price.
SELECT category, unit_price AS highest_average_unit_price FROM Products GROUP BY category ORDER BY AVG(unit_price) DESC LIMIT 1;
--or,
WITH CategoryAverages AS (
    -- Step 1: Calculate the average unit price for each category
    SELECT
        category,
        AVG(unit_price) AS avg_price
    FROM
        Products
    GROUP BY
        category
)
-- Step 2: Select the category(s) whose average price equals the maximum average price found
SELECT
    category
FROM
    CategoryAverages
WHERE
    avg_price = (SELECT MAX(avg_price) FROM CategoryAverages);
------------------------------------------------------------------------------------------------------------------------------------------
--7. Identify products with total sales exceeding 30.
SELECT DISTINCT P.product_name
FROM Products AS P
JOIN Sales AS S ON P.product_id = S.product_id
WHERE S.total_price > 30;
--or,
SELECT P.product_name
FROM Products AS P
JOIN Sales AS S ON P.product_id = S.product_id
GROUP BY P.product_name
HAVING SUM(S.total_price) > 30;
------------------------------------------------------------------------------------------------------------------------------------------
--8. Count the number of sales made in each month.
SELECT 
    strftime('%Y', sale_date) AS sale_year,
    strftime('%m', sale_date) AS sale_month,
    COUNT(*) AS total_sales
FROM Sales
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;
----------------------------------------------------------------------------------------------------------------------------------------
--9. Retrieve Sales Details for Products with 'Smart' in Their Name
SELECT s.sale_id, p.product_name, s.total_price
FROM Sales AS s JOIN Products AS P ON s.product_id = p.product_id 
WHERE p.product_name LIKE 'Smart%';
----------------------------------------------------------------------------------------------------------------------------------------
--10. Determine the average quantity sold for products with a unit price greater than $100.
SELECT s.product_id, AVG(s.quantity_sold) AS average_quantity_sold FROM Sales AS s
JOIN Products AS p ON s.product_id = p.product_id 
WHERE p.unit_price > 100;
---------------------------------------------------------------------------------------------------
--11. Retrieve the product name and total sales revenue for each product.
SELECT p.product_name, SUM(s.total_price) AS total_sales_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales_revenue DESC;
--------------------------------------------------------------------------------------------------------------------------------------------
--12. List all sales along with the corresponding product names.
SELECT s.sale_id, p.product_name
FROM Sales AS s
JOIN Products AS p
ON s.product_id = p.product_id
GROUP BY sale_id
ORDER BY sale_id;
------------------------------------------------------------------------------------------------------------------------------------------
--13. Retrieve the product name and total sales revenue for each product. (Same question as 11)
SELECT p.product_name, SUM(total_price) AS total_sales_revenue
FROM Sales AS s
JOIN Products AS p
ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY total_sales_revenue DESC;
----------------------------------------------------------------------------------------------------------------------------------------
--14. Rank products based on total sales revenue.
SELECT 
    p.product_name,
    SUM(s.total_price) AS total_sales_revenue,
    RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS revenue_rank  --Handles ties (equal revenues get the same rank)
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name;
--or,
SELECT 
    p.product_name,
    SUM(s.total_price) AS total_sales_revenue,
    DENSE_RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS revenue_rank --If two products tie for rank 1, the next rank will be 2 (not 3).
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name;
--or,
SELECT 
    p.product_name,
    SUM(s.total_price) AS total_sales_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(s.total_price) DESC) AS revenue_rank  --If two products have the same revenue, they’ll still get different ranks (1 and 2)
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name;
----------------------------------------------------------------------------------------------------------------------------------------
--15. Calculate the running total revenue for each product category.
SELECT                                                    --True row-wise running total
    p.category,
    p.product_name,
    s.sale_date,
    SUM(s.total_price) OVER (
        PARTITION BY p.category 
        ORDER BY s.sale_date                              
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW   --optional line
    ) AS running_total_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id              
ORDER BY p.category, s.sale_date;
--or,
SELECT p.category, p.product_name, s.sale_date,            --running total revenue for each product category (per date)
       SUM(s.total_price) OVER (PARTITION BY p.category ORDER BY s.sale_date) AS running_total_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id;
----------------------------------------------------------------------------------------------------------------------------------------
--16. Categorize sales as "High", "Medium", or "Low" based on total price (e.g., > $200 is High, $100-$200 is Medium, < $100 is Low).
SELECT sale_id,
CASE
WHEN total_price > 200 THEN 'High'
WHEN total_price BETWEEN 100 AND 200 THEN 'Medium'
ELSE 'Low'
END AS sales_category
FROM Sales;
-------------------------------------------------------------------------------------------------------------------------------------------
--17. Identify sales where the quantity sold is greater than the average quantity sold.
SELECT sale_id, product_id, quantity_sold FROM Sales WHERE quantity_sold > (SELECT AVG(quantity_sold) FROM Sales);
-------------------------------------------------------------------------------------------------------------------------------------------
--18. Extract the month and year from the sale date and count the number of sales for each month.
SELECT 
    STRFTIME('%Y', sale_date) AS sale_year,
    STRFTIME('%m', sale_date) AS sale_month,
    COUNT(sale_id) AS total_sales_count
FROM Sales 
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;
--OR,
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    COUNT(sale_id) AS total_sales_count
FROM Sales 
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;
--OR,
SELECT 
    CONCAT(YEAR(sale_date), '-', LPAD(MONTH(sale_date), 2, '0')) AS month,
    COUNT(*) AS sales_count
FROM Sales
GROUP BY YEAR(sale_date), MONTH(sale_date);
----------------------------------------------------------------------------------------------------------------------------------------
--19. Calculate the number of days between the current date and the sale date for each sale.
SELECT sale_id, DATEDIFF(NOW(), sale_date) AS days_since_sale
FROM Sales;
--or,
SELECT 
    sale_id,
    sale_date,
    DATEDIFF(CURDATE(), sale_date) AS days_difference
FROM Sales;
--or,
SELECT 
    sale_id,
    sale_date,
    JULIANDAY('now') - JULIANDAY(sale_date) AS days_difference
FROM Sales;
----------------------------------------------------------------------------------------------------------------------------------------
