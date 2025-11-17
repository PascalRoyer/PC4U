USE PC4U;
/* Ex�cuter apr�s PC4U_init_database. Chacun des blocs de codes suivant peuvent �tre utilis�s individuellement ou en groupe,
	d�pendamment de la situation. */

/* Insertion des types d'utilisateurs */
INSERT INTO UserTypes(user_type_id, type_names) VALUES
(1, 'superadmin'),
(2, 'admin'),
(3, 'customer');

/* Insertion d'utilisateurs dans la base de donn�es. L'id est incr�ment� automatiquement avec IDENTITY. 
register_date est entr� automatiquement avec le CURRENT_TIMESTAMP */
INSERT INTO Users(user_pseudo, email, user_password, user_type_id) VALUES
('pseudo', 'n123@email.com', 'hashedpassword', 3);

/* Insertion de cat�gories. On peut r�viser ensemble les cat�gories*/
INSERT INTO Categories(category_id, category_name) VALUES
(1, 'CPU'),
(2, 'GPU'),
(3, 'Monitors'),
(4, 'Memory-RAM'),
(5, 'Storage'),
(6, 'Power'),
(7, 'Cases'),
(8, 'Motherboards');

/* Insertion de produits.Le prix et le stock doivent �tre �gaux ou sup�rieurs � 0, sinon erreur. 
	Valeurs � modifier �videmment.*/
INSERT INTO Products(product_id, product_name, category_id, product_price, stock, image_url) VALUES
(1234, '12th Gen Intel(R) Core(TM) i7-12650H (2.30 GHz)', 1, 457.00, 100, 'img/12thgenintel_i7/12650h.jpg'),
(1235, 'NVIDIA� GeForce RTX� 3050 GPU 6GB GDDR6 96-bit', 2, 254.99, 65, 'img/nvidiageforcertx30506gb96.jpg');

/* Insertion dans le panier */
INSERT INTO Cart(cart_id, user_id_number, product_id, quantity) VALUES
(1, 3, 1234, 2),
(1, 3, 1235, 1);

/* Insertion dans la table des transactions. total_items est la somme des quantit�s et total_cost est la somme de line total.
 Note: Les inserts into pour Transactions et Transactions_details resteront vide jusqu'� ce que le code pour le backend soit amorc�. Il est plus
 pertinent que ce soit le backend qui g�re ces deux tables l�. */
INSERT INTO Transactions(transaction_date, total_items, total_cost, user_id_number) VALUES
/* Table pour sauvegarder les templates PC créés par les utilisateurs */
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Templates' AND xtype='U')
BEGIN
    CREATE TABLE Templates (
        template_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        user_id_number BIGINT NOT NULL,
        template_name NVARCHAR(100) NOT NULL,
        components NVARCHAR(MAX) NOT NULL, -- JSON avec les pièces choisies
        total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
        created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        FOREIGN KEY (user_id_number) REFERENCES Users(user_id_number)
    );
END
GO
