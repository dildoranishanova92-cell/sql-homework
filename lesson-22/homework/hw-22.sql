SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales_data
ORDER BY customer_id, order_date;


SELECT
    product_category,
    COUNT(*) AS number_of_orders
FROM sales_data
GROUP BY product_category
ORDER BY number_of_orders DESC;


SELECT
    product_category,
    MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category
ORDER BY max_total_amount DESC;

SELECT
    product_category,
    MIN(unit_price) AS min_price
FROM sales_data
GROUP BY product_category
ORDER BY min_price ASC;


SELECT
    order_date,
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg_3day
FROM sales_data
ORDER BY order_date;


SELECT
    region,
    SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;


SELECT
    customer_id,
    customer_name,
    SUM(total_amount) AS total_purchase,
    RANK() OVER (
        ORDER BY SUM(total_amount) DESC
    ) AS purchase_rank
FROM sales_data
GROUP BY customer_id, customer_name
ORDER BY purchase_rank;


SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    total_amount - LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS difference_from_prev
FROM sales_data
ORDER BY customer_id, order_date;


SELECT
    product_category,
    product_name,
    unit_price
FROM (
    SELECT
        product_category,
        product_name,
        unit_price,
        ROW_NUMBER() OVER (
            PARTITION BY product_category
            ORDER BY unit_price DESC
        ) AS rn
    FROM sales_data
) AS ranked
WHERE rn <= 3
ORDER BY product_category, unit_price DESC;


SELECT
    region,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY region
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM sales_data
ORDER BY region, order_date;


SELECT
    ID,
    SUM(ID) OVER (
        ORDER BY ID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS SumPreValues
FROM your_table
ORDER BY ID;

SELECT
    Value,
    SUM(Value) OVER (
        ORDER BY Value
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS `Sum of Previous`
FROM OneColumn
ORDER BY Value;


SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT product_category) AS category_count
FROM sales_data
GROUP BY customer_id, customer_name
HAVING category_count > 1;

SELECT
    customer_id,
    customer_name,
    region,
    SUM(total_amount) AS total_spent,
    AVG(SUM(total_amount)) OVER (PARTITION BY region) AS avg_region_spent
FROM sales_data
GROUP BY customer_id, customer_name, region
HAVING total_spent > AVG(SUM(total_amount)) OVER (PARTITION BY region)
ORDER BY region, total_spent DESC;


SELECT
    customer_id,
    customer_name,
    region,
    SUM(total_amount) AS total_spent,
    RANK() OVER (
        PARTITION BY region
        ORDER BY SUM(total_amount) DESC
    ) AS region_rank
FROM sales_data
GROUP BY customer_id, customer_name, region
ORDER BY region, region_rank;

SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM sales_data
ORDER BY customer_id, order_date;


SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS monthly_sales,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m'))) 
        / LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) * 100*_


		SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_amount
FROM sales_data
WHERE total_amount > LAG(total_


SELECT
    product_name,
    product_category,
    unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data)
ORDER BY unit_price DESC;

SELECT
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS T


	SELECT
    ID,
    SUM(Cost) AS Cost,
    SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;


WITH RECURSIVE seq AS (
    SELECT 1 AS SeatNumber
    UNION ALL
    SELECT SeatNumber + 1
    FROM seq
    WHERE SeatNumber < (SELECT MAX(SeatNumber) FROM Seats)
)
SELECT
    MIN(s.SeatNumber) AS `Gap Start`,
    MAX(s.SeatNumber) AS `Gap End`
FROM seq s
LEFT JOIN Seats t ON s.SeatNumber = t.SeatNumber
WHERE t.SeatNumber IS NULL
GROUP BY grp
ORDER BY `Gap Start`;
