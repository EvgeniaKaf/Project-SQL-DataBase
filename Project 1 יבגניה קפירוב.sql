CREATE TYPE Name
FROM NVARCHAR(50)

CREATE TYPE Flag
FROM BIT

CREATE TYPE OrderNumber
FROM VARCHAR(50)

CREATE TYPE AccountNumber
FROM VARCHAR(50)

CREATE DATABASE Sales

USE Sales
GO

CREATE TABLE Address(
	AddressID INT CONSTRAINT PK_AddressID PRIMARY KEY,
	AddressLine1 NVARCHAR(60) NOT NULL,
	AddressLine2 NVARCHAR(60),
	City NVARCHAR(30) NOT NULL,
	StateProvinceID INT NOT NULL,
	PostalCode NVARCHAR(15) NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE ShipMethod(
	ShipMethodID INT CONSTRAINT PK_ShipMethodID PRIMARY KEY,
	Name Name NOT NULL,
	ShipBase MONEY NOT NULL,
	ShipRate MONEY NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE CurrencyRate(
	CurrencyRateID INT CONSTRAINT PK_CurrencyRateID PRIMARY KEY,
	CurrencyRateDate DATETIME NOT NULL,
	FromCurrencyCode NCHAR(3) NOT NULL,
	ToCurrencyCode NCHAR(3) NOT NULL,
	AverageRate MONEY NOT NULL,
	EndOfDayRate MONEY NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE SpecialOfferProduct(
	SpecialOfferID INT NOT NULL, 
	ProductID INT NOT NULL,
	CONSTRAINT PK_SpecialOffer_ProductID PRIMARY KEY(SpecialOfferID,ProductID),
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE CreditCard(
	CreditCardID INT CONSTRAINT PK_CreditCardID PRIMARY KEY,
	CardType NVARCHAR(50) NOT NULL,
	CardNumber NVARCHAR(25) NOT NULL,
	ExpMonth TINYINT NOT NULL,
	ExpYear SMALLINT NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE SalesTerritory(
	TerritoryID INT 
				CONSTRAINT PK_TerritoryID PRIMARY KEY,
	Name Name NOT NULL,
	CountryRegionCode NVARCHAR(3) NOT NULL,
	[Group] NVARCHAR(50) NOT NULL,
	SalesYTD MONEY NOT NULL,
	SalesLastYear MONEY NOT NULL,
	CostYTD MONEY NOT NULL,
	CostLastYear MONEY NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE Customer(
	CustomerID INT 
			   CONSTRAINT PK_CustomerID PRIMARY KEY,
	PersonID INT,
	StoreID INT,
	TerritoryID INT 
				CONSTRAINT FK_TerritoryID FOREIGN KEY(TerritoryID) 
				REFERENCES SalesTerritory(TerritoryID),	
	AccountNumber AccountNumber NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE SalesPerson(
	BusinessEntityID INT 
			   CONSTRAINT PK_BusinessEntityID PRIMARY KEY,
	TerritoryID INT 
				CONSTRAINT FK_TerritoryID2 FOREIGN KEY(TerritoryID) 
				REFERENCES SalesTerritory(TerritoryID),	
	SalesQuota MONEY,
	Bonus MONEY NOT NULL,
	CommissionPct SMALLMONEY NOT NULL,
	SalesYTD MONEY NOT NULL,
	SalesLastYear MONEY NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL)


CREATE TABLE SalesOrderHeader(
	SalesOrderID INT 
			     CONSTRAINT PK_SalesOrderID PRIMARY KEY,
	RevisionNumber TINYINT NOT NULL,
	OrderDate DATETIME NOT NULL,
	DueDate DATETIME NOT NULL,
	ShipDate DATETIME,
	[Status] TINYINT NOT NULL,
	OnlineOrderFlag Flag NOT NULL,
	SalesOrderNumber VARCHAR(55) NOT NULL,
	PurchaseOrderNumber OrderNumber,
	AccountNumber AccountNumber,
	CustomerID INT NOT NULL
			   CONSTRAINT FK_CustomerID FOREIGN KEY(CustomerID) 
			   REFERENCES Customer(CustomerID),
	SalesPersonID INT
			      CONSTRAINT FK_SalesPersonID FOREIGN KEY(SalesPersonID) 
			      REFERENCES SalesPerson(BusinessEntityID),
	TerritoryID INT
				CONSTRAINT FK_TerritoryID3 FOREIGN KEY(TerritoryID) 
				REFERENCES SalesTerritory(TerritoryID),	
	BillToAdressID INT NOT NULL,
	ShipToAdressID INT NOT NULL
				   CONSTRAINT FK_ShipToAdressID FOREIGN KEY(ShipToAdressID) 
				   REFERENCES Address(AddressID),	
	ShipMethodID INT NOT NULL
				 CONSTRAINT FK_ShipMethodID FOREIGN KEY(ShipMethodID) 
				 REFERENCES ShipMethod(ShipMethodID),
	CreditCardID INT
				 CONSTRAINT FK_CreditCardID FOREIGN KEY(CreditCardID) 
				 REFERENCES CreditCard(CreditCardID),
	CreditCardApprovalCode VARCHAR(15),
	CurrencyRateID INT
				   CONSTRAINT FK_CurrencyRateID FOREIGN KEY(CurrencyRateID) 
				   REFERENCES CurrencyRate(CurrencyRateID),
	SubTotal MONEY NOT NULL,
	TaxAmt MONEY NOT NULL,
	Freight MONEY NOT NULL)


CREATE TABLE SalesOrderDetail(
	SalesOrderID INT NOT NULL,
				 CONSTRAINT FK_SalesOrderID FOREIGN KEY(SalesOrderID) 
				 REFERENCES SalesOrderHeader(SalesOrderID),
	SalesOrderDetailID INT NOT NULL,
					   CONSTRAINT PK_SalOrdID_SalOrdDetID PRIMARY KEY(SalesOrderID,SalesOrderDetailID),
	CarrierTrackingNumber NVARCHAR(25),
	OrderQty SMALLINT NOT NULL,
	ProductID INT NOT NULL,
	SpecialOfferID INT NOT NULL,
				   CONSTRAINT FK_SpecialOffer_ProductID FOREIGN KEY(SpecialOfferID,ProductID) 
				   REFERENCES SpecialOfferProduct(SpecialOfferID,ProductID),
	UnitPrice MONEY NOT NULL,
	UnitPriceDiscount MONEY NOT NULL,
	LineTotal INT NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL)


INSERT INTO Address VALUES
(1, 'Orlovskogo', 3, 'Paris', 6, 159862, NewID(), '2024-07-10'),
(2, 'Karla Marksa', 5, 'Madrid', 7, 235687, NewID(), '2024-07-10'),
(3, 'Narodnogo Opolchenia', 6, 'Minsk', 8, 125478, NewID(), '2024-07-10')

INSERT INTO ShipMethod VALUES
(89, 'Israel Post', 18, 10, NewID(), '2024-07-10'),
(65, 'DHL', 20, 15, NewID(), '2024-07-10'),
(23, 'UPS', 30, 25, NewID(), '2024-07-10')


INSERT INTO CurrencyRate VALUES
(1, '2024-07-01', 'EUR', 'USD', 1.0813, 1.082, '2024-07-10'),
(2, '2024-07-02', 'USD', 'EUR', 0.9249, 0.925, '2024-07-10'),
(3, '2024-07-03', 'NIS', 'USD', 0.2705, 0.26807, '2024-07-10')


INSERT INTO SpecialOfferProduct VALUES
(569, 123, NewID(), '2024-07-10'),
(235, 456, NewID(), '2024-07-10'),
(785, 789, NewID(), '2024-07-10')


INSERT INTO CreditCard VALUES
(11, 'Visa', 789123456, 02, 2029, '2024-07-10'),
(12, 'MasterCard', 568479658, 04, 2028, '2024-07-10'),
(13, 'Visa Business', 215698745, 05, 2026, '2024-07-10')


INSERT INTO SalesTerritory VALUES
(9, 'France', 33, 'Europe', 10000, 40000, 5000, 11000, NewID(), '2024-07-10'),
(8, 'Spain', 34, 'Europe', 12000, 50000, 3000, 12000, NewID(), '2024-07-10'),
(7, 'Belarus', 375, 'Europe', 15000, 10000, 1000, 8000, NewID(), '2024-07-10')


INSERT INTO Customer VALUES
(1, 4, 56, 9, 123568, NewID(), '2024-07-10'),
(2, 5, 78, 8, 896523, NewID(), '2024-07-10'),
(3, 6, 85, 7, 125478, NewID(), '2024-07-10')


INSERT INTO SalesPerson VALUES
(111, 9, 45000, 5000, 7, 5000, 15000, NewID(), '2024-07-10'),
(112, 8, 45000, 4000, 6, 4500, 20000, NewID(), '2024-07-10'),
(113, 7, 12000, 2000, 5, 1000, 5000, NewID(), '2024-07-10')


INSERT INTO SalesOrderHeader VALUES
(21, 1, '2023-05-10', '2023-05-15', '2023-05-20', 1, 0.1, 123, 123456, 123568, 1, 111, 8, 1, 1, 65, 11, 856, 1, 150, 15, 300),
(22, 2, '2023-05-15', '2023-05-20', '2023-05-23', 2, 0.1, 456, 785963, 896523, 2, 112, 7, 2, 2, 23, 12, 985, 2, 200, 17, 400),
(23, 3, '2023-05-20', '2023-05-25', '2023-05-29', 3, 0.1, 789, 214568, 125478, 3, 113, 9, 3, 3, 65, 13, 245, 1, 250, 15, 500)


INSERT INTO SalesOrderDetail VALUES
(21, 45, '45H125', 25, 123, 569, 200, 2, 4900, NewID(), '2024-07-10'),
(22, 46, '785K54', 30, 456, 235, 230, 4, 6624, NewID(), '2024-07-10'),
(23, 47, '125T78', 15, 789, 785, 120, 8, 1656, NewID(), '2024-07-10')

