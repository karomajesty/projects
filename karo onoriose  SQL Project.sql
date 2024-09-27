-- Question 1
--Retrieve information about the products with colour values except null, red, silver/black, white and list price between
--£75 and £750. Rename the column StandardCost to Price. Also, sort the results in descending order by list price.

--ANSWER :

SELECT * FROM PRODUCTION.PRODUCT;

SELECT NAME,COLOR, LISTPRICE,STANDARDCOST AS PRICE FROM Production.Product
WHERE Color NOT IN('NULL', 'RED','SILVER/BLACK','WHITE') AND LISTPRICE BETWEEN 75 AND 750
ORDER BY ListPrice DESC;

--Question 2
--Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female employees
--born between 1972 and 1975 and hire date between 2001 and 2002.

--ANSWER ;

SELECT * FROM HumanResources.Employee;

SELECT GENDER,BIRTHDATE,HIREDATE FROM HumanResources.Employee
WHERE GENDER = 'M' AND BIRTHDATE BETWEEN '1962' AND '1970' AND HIREDATE > '2001' 
UNION
SELECT GENDER,BIRTHDATE,HIREDATE FROM HumanResources.Employee 
WHERE GENDER = 'F' AND BIRTHDATE BETWEEN '1972' AND '1975' AND HIREDATE BETWEEN '2001' AND '2002';

--Question 3
--Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include only the product
--ID, Name and colour.

--ANSWER;

SELECT * FROM PRODUCTION.PRODUCT;

SELECT TOP 10 ProductID, NAME ,COLOR FROM Production.Product
WHERE ProductNumber LIKE 'BK%'
ORDER BY StandardCost DESC;

--Question 4
--Create a list of all contact persons, where the first 4 characters of the last name are the same asthe first four characters
--of the email address. Also, for all contacts whose first name and the last name begin with the same characters, create
--a new column called full name combining first name and the last name only. Also provide the length ofthe new column
--full name.

-- Annswer;

SELECT * FROM Person.EmailAddress;
SELECT FIRSTNAME,LASTNAME,EMAILADDRESS,
CONCAT(FIRSTNAME,' ',LastName) AS FULLNAME,
LEN(CONCAT(FIRSTNAME,' ',LastName)) AS LEN_FULLNAME 
FROM Person.Person AS PP
INNER JOIN Person.EmailAddress AS PEA
ON PP.BusinessEntityID = PEA.BusinessEntityID
WHERE LEFT(LASTNAME,4) = LEFT(EmailAddress,4) 
AND LEFT(FIRSTNAME,1) = LEFT(LASTNAME,1);

--Question 5
-- Return all product subcategories that take an average of 3 days or longer to manufacture.

--ANSWER;

SELECT NAME FROM Production.ProductSubcategory;
SELECT PPSC.Name, DAYSTOMANUFACTURE  
FROM Production.ProductSubcategory AS PPSC
LEFT JOIN Production.Product AS PP
ON PP.ProductSubcategoryID = PPSC.ProductSubcategoryID
WHERE DaysToManufacture >= 3;

--Question 6
--Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. If
--price gets less than £200 then low value. If price is between £201 and £750 then mid value. If between £750 and £1250
--then mid to high value else higher value. Filter the results only for black, silver and red color products.

--ANSWER;

SELECt * from Production.Product;
SELECT	NAME, LISTPRICE, COLOR,
CASE 
WHEN LISTPRICE < 200
THEN 'LOW VALUE'
WHEN LISTPRICE BETWEEN 201 AND 750
THEN 'MID VALUE'
WHEN LISTPRICE BETWEEN 750 AND 1250 
THEN 'MID T0 HIGH_VALUE'
ELSE 'HIGHER VALUE'
END AS PRODUCT_SEGMENTATION
FROM Production.Product
WHERE COLOR IN ('BLACK','SILVER','RED');

--Question 7
--How many Distinct Job title is present in the Employee table?

-- Answer;

SELECT COUNT(DISTINCT JOBTITLE) as "Number of Distinct Job titles" FROM HumanResources.Employee;

--Question 8
--Use employee table and calculate the ages of each employee at the time of hiring.
--ANSWER
SELECT* FROM HumanResources.Employee;
SELECT YEAR(HIREDATE)-YEAR(BIRTHDATE) AS AGE FROM HumanResources.Employee;

--Question 9
--How many employees will be due a long service award in the next 5 years, if long service is 20 years?

--ANSWER:

SELECT COUNT(2028-YEAR(HIREDATE)) AS SERVICE_TIME FROM HumanResources.Employee
WHERE 2028-YEAR(HIREDATE) >= 20;

--Question 10
--How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?

--ANSWER;

SELECT BUSINESSENTITYID, DATEDIFF(YEAR,BIRTHDATE,GETDATE()) AS AGE,
65- DATEDIFF(YEAR,BIRTHDATE,GETDATE()) AS YEARS_TO_SENTIMENT FROM HumanResources.Employee;

--Question 11
--Implement new price policy on the product table base on the colour of the item
--If white increase price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2%. If multi, silver,
--silver/black or blue take the square root of the price and double the value. Column should be called Newprice. For
--each item, also calculate commission as 37.5% of newly computed list price.

 --Answer ;

SELECT * FROM Production.Product;
SELECT PRODUCTID,NAME, COLOR,StandardCost,
CASE
WHEN  COLOR = 'WHITE'
THEN StandardCost + (StandardCost*0.08)
WHEN COLOR = 'YELLOW'
THEN StandardCost - (StandardCost * 0.075)
WHEN COLOR = 'BLACK'
THEN StandardCost + (StandardCost * 0.172)
WHEN COLOR IN('MULTI','SILVER','SILVER/BLACK','BLUE')
THEN SQRT(StandardCost)*2
ELSE StandardCost
END AS NEW_PRICE,
(CASE
WHEN  COLOR = 'WHITE'
THEN StandardCost + (StandardCost*0.08)
WHEN COLOR = 'YELLOW'
THEN StandardCost - (StandardCost * 0.075)
WHEN COLOR = 'BLACK'
THEN StandardCost + (StandardCost * 0.172)
WHEN COLOR IN('MULTI','SILVER','SILVER/BLACK','BLUE')
THEN SQRT(StandardCost)*2
ELSE StandardCost
END) * 0.375 AS COMMISSION
FROM PRODUCTION.PRODUCT;


--Question 12
--Print the information about all the Sales.Person and their sales quota. For every Sales person you should provide their
--FirstName, LastName, HireDate, SickLeaveHours and Region where they work.

--Answer;

SELECT PP.FirstName,PP.LastName, HRE.HireDate, HRE.SickLeaveHours, ST.NAME, SQH.SalesQuota
FROM Sales.SalesPerson AS SP
JOIN HumanResources.Employee AS HRE ON SP.BusinessEntityID = HRE.BusinessEntityID
JOIN Person.Person AS PP ON HRE.BusinessEntityID = PP.BusinessEntityID
JOIN Sales.SalesTerritory  AS ST ON SP.TerritoryID = ST.TerritoryID
JOIN Sales.SalesPersonQuotaHistory  AS SQH ON SP.BusinessEntityID = SQH.BusinessEntityID
ORDER BY PP.LastName,PP.FirstName;

 --Question 13
--Using adventure works, write a query to extract the following information.
-- Product name,Product category name,Product subcategory name,Sales person,Revenue,Month of transaction,Quarter of transaction,Region

-- Answer;

SELECT* FROM Person.Person
SELECT P.Name AS PRODUCT_NAME,
pc.Name AS PRODUCT_CATEGORY_NAME, 
PSC.Name AS PRODUCT_SUBCATEGORY_NAME,
SUM(SOD.LineTotal) AS REVENUE,
CONCAT(PP.FIRSTNAME,' ', PP.LASTNAME) AS SALES_PERSON,
DATEPART(MONTH, SOH.OrderDate) AS MONTH_OF_TRANSACTION, 
DATEPART(QUARTER, SOH.OrderDate) AS QUARTER_OF_TRANSACTION, 
S.Name AS REGION
FROM Sales.SalesOrderHeader AS SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN Production.Product AS P ON SOD.ProductID = P.ProductID
JOIN Production.ProductSubcategory AS PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory AS PC ON PSC.ProductCategoryID = PC.ProductCategoryID
JOIN Sales.SalesPerson AS SP ON SOH.SalesPersonID = SP.BusinessEntityID
JOIN Person.Person AS PP ON SP.BusinessEntityID = PP.BusinessEntityID
JOIN Sales.SalesTerritory S ON SP.TerritoryID = S.TerritoryID
GROUP BY P.Name, PC.Name, PSC.Name,PP.FirstName,PP.LastName,
DATEPART(MONTH, SOH.OrderDate), DATEPART(QUARTER, SOH.OrderDate), S.Name
ORDER BY PP.LastName,PP.FirstName;


--Question 14 
--Display the information about the details of an order i.e. order number, order date, amount of order, which customer 
--gives the order and which salesman works for that customer and how much commission he gets for an order. 

--Answer;

SELECT* FROM Production.Product
SELECT SOH.SalesOrderNumber AS 'Order Number', 
SOH.OrderDate AS 'Order Date', 
SOH.TotalDue AS 'Amount of Order', 
SC.CustomerID AS 'Customer', 
PP.FirstName + ' ' + PP.LastName AS 'Salesperson Name', 
SP.CommissionPct AS 'Commission Percentage'
FROM Sales.SalesOrderHeader AS SOH
JOIN Sales.Customer AS SC ON SOH.CustomerID = SC.CustomerID
JOIN Person.Person AS PP ON PP.BUSINESSENTITYID = PP.BusinessEntityID
JOIN Sales.SalesPerson AS SP ON SP.BusinessEntityID = PP.BusinessEntityID;

--Question 15 
--For all the products calculate - 
--
Commission as 14.790% of standard cost, - 
--Margin, if standard cost is increased or decreased as follows: 
--Black: +22%, 
--Red: -12% 
--Silver: +15% 
--Multi: +5% 
--White: Two times original cost divided by the square root of cost 
--For other colours, standard cost remains the same

-- ANSWER;

SELECT PRODUCTID,NAME,STANDARDCOST, STANDARDCOST * 0.14790 AS COMISSION, COLOR,
(CASE
WHEN COLOR = 'BLACK'
THEN STANDARDCOST + (STANDARDCOST * 0.22)
WHEN COLOR = 'RED'
THEN StandardCost - (STANDARDCOST * 0.12)
WHEN COLOR = 'SILVER'
THEN STANDARDCOST + (STANDARDCOST * 0.15)
WHEN COLOR = 'MULTI'
THEN STANDARDCOST + (STANDARDCOST * 0.05)
WHEN COLOR = 'WHITE'
THEN 2*STANDARDCOST/SQRT(STANDARDCOST)
ELSE STANDARDCOST
END) - STANDARDCOST AS MARGIN
FROM Production.Product;

--Question 16 
--Create a view to find out the top 5 most expensive products for each colour.

-- Answer;

 
