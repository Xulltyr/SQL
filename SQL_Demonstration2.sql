CREATE DATABASE Demonstration2
USE Demonstration2


-- Eliminar las tablas si existen
-- Drop the tables if they exist.
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Order_Items;


-- 1. Crear las tablas necesarias e insertarle datos a cada una.
-- 1. Create the necessary tables and insert data into each one.

-- Crear tabla Orders
-- Create table Orders
CREATE TABLE Orders (
    ORDER_ID INT PRIMARY KEY,
    ORDER_STATUS NVARCHAR(50),
    ORDER_DATETIME DATETIME,
    CUSTOMER_ID INT,
    STORE_ID INT
);

-- Insertar datos en Orders
-- Insert Data into Orders
INSERT INTO Orders (ORDER_ID, ORDER_STATUS, ORDER_DATETIME, CUSTOMER_ID, STORE_ID)
VALUES 
(1, 'refunded', '2022-08-13 10:00:00', 101, 201),
(2, 'completed', '2022-08-15 11:30:00', 102, 202),
(3, 'refunded', '2022-08-17 14:00:00', 103, 203),
(4, 'completed', '2022-10-12 15:45:00', 104, 204),
(5, 'pending', '2018-10-25 09:15:00', 105, 205),
(6, 'completed', '2018-10-05 12:00:00', 106, 202),
(7, 'refunded', '2018-10-18 08:30:00', 107, 201);

-- Crear tabla Customers
-- Create table Customers
CREATE TABLE Customers (
    CUSTOMER_ID INT PRIMARY KEY,
    FIRST_NAME NVARCHAR(50),
    LAST_NAME NVARCHAR(50),
    EMAIL_ADDRESS NVARCHAR(100),
    CREDIT_LIMIT DECIMAL(10, 2)
);

-- Insertar datos en Customers
-- Insert Data into Customers
INSERT INTO Customers (CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, CREDIT_LIMIT)
VALUES
(101, 'John', 'Doe', 'john.doe@example.com', 500),
(102, 'Jane', 'Smith', 'jane.smith@example.com', 450),
(103, 'Bob', 'Johnson', 'bob.johnson@example.com', 600),
(104, 'Alice', 'Williams', 'alice.williams@example.com', 550),
(105, 'Charlie', 'Brown', 'charlie.brown@example.com', 700),
(106, 'Eve', 'White', 'eve.white@example.com', 450),
(107, 'George', 'Martin', 'george.martin@example.com', 620);

-- Crear tabla Stores
-- Create table Stores
CREATE TABLE Stores (
    STORE_ID INT PRIMARY KEY,
    STORE_NAME NVARCHAR(100),
    LATITUDE DECIMAL,
    LONGITUDE DECIMAL
);

-- Insertar datos en Stores
-- Insert Data into Stores
INSERT INTO Stores (STORE_ID, STORE_NAME, LATITUDE, LONGITUDE)
VALUES
(201, 'NewTown Store', 20000000, 15000000),
(202, 'Ewing Plaza', 19500000, 16000000),
(203, 'WestMall', 21000000, 17000000),
(204, 'EastEnd', 32000000, 14000000),
(205, 'Centrale', 22000000, 13000000),
(206, 'NEWest Store', 23000000, 12000000);

-- Crear tabla Products
-- Create table Products
CREATE TABLE Products (
    PRODUCT_ID INT PRIMARY KEY,
    PRODUCT_NAME NVARCHAR(100),
    UNIT_PRICE DECIMAL(10, 2),
    COST DECIMAL(10, 2)
);

-- Insertar datos en Products
-- Insert Data into Products
INSERT INTO Products (PRODUCT_ID, PRODUCT_NAME, UNIT_PRICE, COST)
VALUES
(301, 'Pyjama Set', 50.00, 30.00),
(302, 'T-Shirt', 20.00, 10.00),
(303, 'Jeans', 40.00, 25.00),
(304, 'Socks', 5.00, 2.00),
(305, 'Hat', 15.00, 8.00),
(306, 'Jacket', 80.00, 60.00),
(307, 'Sweater', 60.00, 40.00);

-- Crear tabla Order_Items
-- Create table Order_Items
CREATE TABLE Order_Items (
    ORDER_ID INT,
    PRODUCT_ID INT,
    QUANTITY INT,
    UNIT_PRICE DECIMAL(10, 2),
    PRIMARY KEY (ORDER_ID, PRODUCT_ID),
    FOREIGN KEY (ORDER_ID) REFERENCES Orders(ORDER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES Products(PRODUCT_ID)
);

-- Insertar datos en Order_Items
-- Insert Data into Order_Items
INSERT INTO Order_Items (ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE)
VALUES
(1, 301, 2, 50.00),
(2, 302, 3, 20.00),
(3, 303, 1, 40.00),
(4, 304, 5, 100.00),
(5, 305, 2, 15.00),
(6, 306, 1, 80.00),
(7, 307, 2, 60.00);



-- 2. Mostrar el id, estado y fecha (formato “30 Aug 2022”) para las órdenes realizadas los días 13, 15 y 17 de cualquier mes.
-- 2. Show the ID, status, and date (format “30 Aug 2022”) for orders made on the 13th, 15th, and 17th of any month.
SELECT O.ORDER_ID, O.ORDER_STATUS, CONVERT(NVARCHAR, O.ORDER_DATETIME, 106) AS 'Order Date'
FROM Orders O
WHERE DAY(O.ORDER_DATETIME) IN (13, 15, 17);

-- 3. Obtener el 50 porciento de los clientes ordenados alfabéticamente por email.
-- 3. Retrieve 50 percent of the customers ordered alphabetically by email.
SELECT TOP 50 PERCENT *
FROM Customers C
ORDER BY C.EMAIL_ADDRESS;

-- 4. Mostrar el nombre de la sucursal, el id de la orden, la fecha de compra y el nombre del cliente, 
-- para aquellas órdenes cuyo estado es rechazado (refunded) o el límite de crédito es menor a 600 y mayor a 400.
-- 4. Show the branch name, order ID, purchase date, and customer name,  
-- for those orders whose status is refunded or the credit limit is less than 600 and greater than 400.
SELECT S.STORE_NAME, O.ORDER_ID, O.ORDER_DATETIME, C.FIRST_NAME + ' ' + C.LAST_NAME AS 'Customer Full Name'
FROM Customers C 
JOIN Orders O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN Stores S ON O.STORE_ID = S.STORE_ID
WHERE O.ORDER_STATUS = 'refunded' OR C.CREDIT_LIMIT BETWEEN 401 AND 599;

-- 5. Obtener la cantidad de clientes que compraron pijamas.
-- 5. Get the number of customers who purchased pajamas.
SELECT COUNT(DISTINCT O.CUSTOMER_ID) AS 'Total of Customers'
FROM Products P 
JOIN Order_Items OI ON P.PRODUCT_ID = OI.PRODUCT_ID
JOIN Orders O ON OI.ORDER_ID = O.ORDER_ID
WHERE P.PRODUCT_NAME LIKE '%Pyjama%';

-- 6. Mostrar todos los datos de las sucursales que tengan definida su latitud y longitud 
-- o que la latitud se encuentre entre 19428489 y 32100664, ordenado por latitud de menor a mayor.
-- 6. Show all the data of the branches that have defined their latitude and longitude
-- or where the latitude is between 19428489 and 32100664, ordered by latitude from lowest to highest.
SELECT *
FROM Stores S
WHERE (S.LATITUDE IS NOT NULL AND S.LONGITUDE IS NOT NULL) 
    OR S.LATITUDE BETWEEN 19428489 AND 32100664
ORDER BY S.LATITUDE ASC;

-- 7. Mostrar el margen de ganancia de las ventas realizadas en octubre del 2018. Mostrar el estado y el margen obtenido.
-- 7. Show the profit margin of sales made in October 2018. Display the status and the obtained margin.
SELECT CONVERT(DECIMAL(8, 2), SUM((OI.UNIT_PRICE - P.COST) * OI.QUANTITY)) AS 'Profit Margin', O.ORDER_STATUS
FROM Products P 
JOIN Order_Items OI ON P.PRODUCT_ID = OI.PRODUCT_ID
JOIN Orders O ON OI.ORDER_ID = O.ORDER_ID
WHERE YEAR(O.ORDER_DATETIME) = 2018 AND MONTH(O.ORDER_DATETIME) = 10
GROUP BY O.ORDER_STATUS;

-- 8. Mostrar el subtotal de las órdenes por tienda, subtotales mayores a 45000, ordenado por nombre de tienda.
-- 8. Show the subtotal of orders by store, subtotals greater than 45000, ordered by store name.
SELECT CONVERT(DECIMAL(12,4), SUM(OI.UNIT_PRICE * OI.QUANTITY)) AS 'SubTotal', S.STORE_NAME
FROM Orders O 
JOIN Order_Items OI ON O.ORDER_ID = OI.ORDER_ID
JOIN Stores S ON O.STORE_ID = S.STORE_ID
GROUP BY S.STORE_NAME
HAVING CONVERT(DECIMAL(12,4), SUM(OI.UNIT_PRICE * OI.QUANTITY)) > 45000
ORDER BY S.STORE_NAME;

-- 9. Actualizar el precio unitario de los productos donde el precio de los mismos es mayor al promedio del precio de todos los productos.
-- El nuevo precio será la suma del precio unitario más el costo.
-- 9. Update the unit price of the products where their price is greater than the average price of all products.
-- The new price will be the sum of the unit price plus the cost.
UPDATE Products
SET UNIT_PRICE = UNIT_PRICE + COST
WHERE UNIT_PRICE > (SELECT AVG(UNIT_PRICE) FROM Products);

-- 10. Eliminar las órdenes de las tiendas cuyo nombre contiene una 'E' como segundo carácter y una 'W' como tercer carácter.
-- 10. Delete the orders from the stores whose name contains an 'E' as the second character and a 'W' as the third character.
DELETE FROM Orders
WHERE STORE_ID IN (SELECT S.STORE_ID FROM Stores S WHERE S.STORE_NAME LIKE '_EW%');