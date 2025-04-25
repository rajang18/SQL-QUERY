USE AdventureWorks2019;
SELECT DISTINCT
    p1.FirstName + ' ' + p1.LastName AS CustomerName,
    cust_address.City AS CustomerCity,
    p.FirstName + ' ' + p.LastName AS SalesmanName,
    sp_address.City AS SalesmanCity,
    sp.CommissionPct 
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Person.Person p1 ON c.PersonID = p1.BusinessEntityID

JOIN Person.BusinessEntityAddress cust_bea ON c.StoreID = cust_bea.BusinessEntityID
JOIN Person.Address cust_address ON cust_bea.AddressID = cust_address.AddressID

JOIN Person.BusinessEntityAddress sp_bea ON sp.BusinessEntityID = sp_bea.BusinessEntityID
JOIN Person.Address sp_address ON sp_bea.AddressID = sp_address.AddressID
WHERE cust_address.City <> sp_address.City
  AND sp.CommissionPct > 0.012;

--------------------------------------------------------------------------------------------------
----------Every salesperson with customer & order info (or none)
use AdventureWorks2019;
SELECT 
    sp.BusinessEntityID AS SalespersonID,
    spPerson.FirstName + ' ' + spPerson.LastName AS SalespersonName,
    c.CustomerID,
    custPerson.FirstName + ' ' + custPerson.LastName AS CustomerName,
    addr.City AS CustomerCity,
    NULL AS Grade,
    soh.SalesOrderID AS OrderNumber,
    soh.OrderDate,
    soh.TotalDue AS OrderAmount
FROM 
    Sales.SalesPerson sp
LEFT JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
LEFT JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Person.Person custPerson ON c.PersonID = custPerson.BusinessEntityID
LEFT JOIN Person.BusinessEntityAddress custBEA ON custPerson.BusinessEntityID = custBEA.BusinessEntityID
LEFT JOIN Person.Address addr ON custBEA.AddressID = addr.AddressID
LEFT JOIN Person.Person spPerson ON sp.BusinessEntityID = spPerson.BusinessEntityID;

---------------------- 3RD ONE

 SELECT 
    e.JobTitle,
    p.FirstName + ' ' + ISNULL(p.MiddleName + ' ', '') + p.LastName AS EmployeeName,
    eph.Rate AS CurrentSalary,
    (SELECT MAX(eph2.Rate) FROM HumanResources.EmployeePayHistory eph2) - eph.Rate AS SalaryDifference
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentID = 16
    AND edh.EndDate IS NULL  -- Only current department assignment
    AND eph.RateChangeDate = (
        SELECT MAX(eph3.RateChangeDate) 
        FROM HumanResources.EmployeePayHistory eph3 
        WHERE eph3.BusinessEntityID = e.BusinessEntityID
    )
ORDER BY 
    SalaryDifference DESC;
------------------------4TH ONE
SELECT 
    st.Name AS TerritoryName,
    sp.SalesYTD,
    sp.BusinessEntityID,
    sp.SalesLastYear AS PrevRepSales
FROM 
    Sales.SalesPerson sp
JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
ORDER BY st.Name ASC;


--------------------------5TH ONE
SELECT 
    soh.SalesOrderID AS Ord_No,
    soh.TotalDue AS Purch_Amt,
    custPerson.FirstName + ' ' + custPerson.LastName AS Cust_Name,
    addr.City
FROM 
    Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person custPerson ON c.PersonID = custPerson.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address addr ON bea.AddressID = addr.AddressID
WHERE soh.TotalDue BETWEEN 500 AND 2000;

-----------------------6TH ONE
SELECT 
    p.FirstName + ' ' + p.LastName AS CustomerName,
    addr.City,
    soh.SalesOrderID AS OrderNumber,
    soh.OrderDate,
    soh.TotalDue AS OrderAmount
FROM 
    Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
LEFT JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
LEFT JOIN Person.Address addr ON bea.AddressID = addr.AddressID
ORDER BY soh.OrderDate;


-- 7. Employees with job titles s
SELECT 
    e.JobTitle,
    p.LastName,
    p.MiddleName,
    p.FirstName
FROM 
    HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE 
    e.JobTitle LIKE 'Sales%';
