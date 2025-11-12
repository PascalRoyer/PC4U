USE PC4U;
/* Script pour remettre la base de donn�es � neuf apr�s des tests par exemple */
DELETE FROM CPU_Specs;
DELETE FROM GPU_Specs;
DELETE FROM Monitor_Specs;
DELETE FROM Memory_Specs;
DELETE FROM Hard_Drive_Specs;
DELETE FROM Power_supply_Specs;
DELETE FROM Case_Specs;
DELETE FROM Motherboard_Specs;
DELETE FROM Transaction_Details;
DELETE FROM Transactions;
DELETE FROM Cart;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Users;
DELETE FROM UserTypes;


-- Reseed des tables IDENTITY (remet l'auto-incr�ment � 0 pour repartir � 1)
DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Products', RESEED, 0)
DBCC CHECKIDENT ('Transactions', RESEED, 0);
DBCC CHECKIDENT ('Transaction_Details', RESEED, 0);