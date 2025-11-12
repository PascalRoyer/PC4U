USE PC4U;
/* Script pour remettre la base de données à neuf après des tests par exemple */
DELETE FROM Transaction_Details;
DELETE FROM Transactions;
DELETE FROM Cart;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Users;
DELETE FROM UserTypes;

TRUNCATE TABLE CPU_Specs;
TRUNCATE TABLE GPU_Specs;
TRUNCATE TABLE Monitor_Specs;
TRUNCATE TABLE Memory_Specs;
TRUNCATE TABLE Hard_Drive_Specs;
TRUNCATE TABLE Power_supply_Specs;
TRUNCATE TABLE Case_Specs;
TRUNCATE TABLE Motherboard_Specs;


-- Reseed des tables IDENTITY (remet l'auto-incrément à 0 pour repartir à 1)
DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Products', RESEED, 0)
DBCC CHECKIDENT ('Transactions', RESEED, 0);
DBCC CHECKIDENT ('Transaction_Details', RESEED, 0);