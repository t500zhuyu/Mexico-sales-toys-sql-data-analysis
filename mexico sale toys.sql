# SQL Mexico sale toys dataset
use mexico_sale_toys;

# create table sales
 # this is a table with more than 800,000 rows
CREATE TABLE sales
(
 Sale_ID INT,
 Date DATE,
 Store_ID INT,
 Product_ID INT,
 Units INT
 );
 
 SELECT * FROM sales;
# Import large data csv (829,262 rows) using a special method:
 # link to this method: https://www.youtube.com/watch?v=INtejSjK5w0
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'sales.csv' INTO TABLE sales
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
# show table sales
SELECT * FROM mexico_sale_toys.stores;
SELECT * FROM mexico_sale_toys.inventory;
SELECT * FROM mexico_sale_toys.sales;
SELECT * FROM mexico_sale_toys.products;

# QUESTIONS:

# *******
# Which product categories drive the biggest profits? Is this the same across store locations?
# *******

SELECT * FROM mexico_sale_toys.products;
SELECT * FROM mexico_sale_toys.sales;
# Rest of (Product_Price - Product_Cost), so we get the profit
select Product_ID, Product_Name, Product_Category, Product_Cost, Product_Price, Product_Price- Product_Cost 'Profit' from products;

# solve error 1175, safe update
SET SQL_SAFE_UPDATES = 0;
# create a new column Rest of (Product_Price - Product_Cost), so we get the profit
ALTER TABLE products ADD Profit INT;
UPDATE products SET Profit = Product_Price - Product_Cost;

# show the table and order by the bigger profit products
select Product_ID, Product_Name, Product_Category, Product_Cost, Product_Price, Profit
from products
order by Profit desc;

 # bigger profit by product categories
SELECT Product_Category, SUM(Profit) AS Total_Profit
FROM products
GROUP BY Product_Category
order by profit asc;

# Join tables products with table sales
 # store: Store_ID
SELECT * FROM mexico_sale_toys.products;
SELECT * FROM mexico_sale_toys.sales;

select p.Product_ID, p.Product_Category, s.Store_ID, SUM(p.Profit) AS Total_Profit
from products p
join sales s on p.Product_ID = s.Product_ID
group by p.Product_Category
order by Total_Profit desc;

# Answer the last question with this last query, we can say that the bigger product category is Art & Crafts
# and the biggest product category it's different for the different stores

# ******
# Can you find any seasonal trends or patterns in the sales data?
# ******

# use table sales
 # columns: date, units, 
# Order the sales by units in descending mode
SELECT Date, Units
FROM sales
ORDER BY units DESC;

# Order the sales by units in ascending mode
SELECT Date, Units
FROM sales
ORDER BY units asc;

SELECT Date, Units
FROM sales
ORDER BY units desc;

# We can notice that in some months the sales are bigger (February, December, November, June)

# *****
# Are sales being lost with out-of-stock products at certain locations?
# *****
SELECT * FROM mexico_sale_toys.stores;
SELECT * FROM mexico_sale_toys.inventory;
SELECT * FROM mexico_sale_toys.sales;
SELECT * FROM mexico_sale_toys.products;
# use tables: sales, inventory
select * from sales
where Units = 1;
# TABLE sales: Store_ID, Product_ID, Units
# TABLE inventory: Stock_On_Head, Product_ID

select s.Store_ID, s.Product_ID, i.Stock_On_Hand, s.Units
from sales s
join inventory i on s.Product_ID = i.Product_ID
group by i.Stock_On_Hand
order by s.Units desc;
# show the querie with stock_On_Hand = 0
select s.Store_ID, s.Product_ID, i.Stock_On_Hand, s.Units
from sales s
join inventory i on s.Product_ID = i.Product_ID
where i.Stock_On_Hand = 0;

# When there is stock_On_Hand equal to 0, we can notice that sold units are few between 1 - 3 units

# *****
# How much money is tied up in inventory at the toy stores? How long will it last?
# *****
SELECT * FROM mexico_sale_toys.stores;
SELECT * FROM mexico_sale_toys.inventory;
SELECT * FROM mexico_sale_toys.sales;
SELECT * FROM mexico_sale_toys.products;

SELECT i.Store_ID, SUM(p.Product_Cost * i.Stock_On_Hand) as money_tied_up
FROM products p
INNER JOIN inventory i
ON p.Product_ID = i.Product_ID
GROUP BY i.Store_ID
order by Total_Cost desc;

# total money_tied_up is: 300,209.57999
select SUM(p.Product_Cost * i.Stock_On_Hand) as money_tied_up 
from products p
INNER JOIN inventory i
ON p.Product_ID = i.Product_ID;

select i.Store_ID, p.Product_ID, p.Product_Name, p.Product_Category, p.Product_Cost, i.Stock_On_Hand, p.Product_Cost * i.Stock_On_Hand as money_tied_up
from products p
join inventory i on p.Product_ID = i.Product_ID
group by i.Stock_On_Hand, i.Store_ID
order by money_tied_up desc;

# money tied up per store is different for each. It's show in this last query
# the biggest one is store_ID with a stock_On_Hand: 117 and money_tied_up: 4093.83






















