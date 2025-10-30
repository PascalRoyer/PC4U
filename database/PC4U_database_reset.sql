USE PC4U;
/* Script pour remettre la base de données à neuf après des tests par exemple */
DELETE FROM Transaction_Details;
DELETE FROM Transactions;
DELETE FROM Cart;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Users;
DELETE FROM UserTypes;

-- Reseed des tables IDENTITY (remet l'auto-incrément à 0 pour repartir à 1)
DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Transactions', RESEED, 0);
DBCC CHECKIDENT ('Transaction_Details', RESEED, 0);