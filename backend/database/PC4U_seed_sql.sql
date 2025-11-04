USE PC4U;
/* Exécuter après PC4U_init_database. Chacun des blocs de codes suivant peuvent être utilisés individuellement ou en groupe,
	dépendamment de la situation. */

/* Insertion des types d'utilisateurs */
INSERT INTO UserTypes(user_type_id, type_names) VALUES
(1, 'superadmin'),
(2, 'admin'),
(3, 'customer');

/* Insertion d'utilisateurs dans la base de données. L'id est incrémenté automatiquement avec IDENTITY. 
register_date est entré automatiquement avec le CURRENT_TIMESTAMP */
INSERT INTO Users(user_pseudo, email, user_password, user_type_id) VALUES
('pseudo', 'n123@email.com', 'hashedpassword', 3);

/* Insertion de catégories. On peut réviser ensemble les catégories*/
INSERT INTO Categories(category_id, category_name) VALUES
(1, 'CPU'),
(2, 'GPU'),
(3, 'Monitors'),
(4, 'Memory-RAM'),
(5, 'Storage'),
(6, 'Power'),
(7, 'Cases'),
(8, 'Motherboards');

/* Insertion de produits.Le prix et le stock doivent être égaux ou supérieurs à 0, sinon erreur. 
	Valeurs à modifier évidemment.*/
INSERT INTO Products(product_id, product_name, category_id, product_price, stock, image_url) VALUES
(1234, '12th Gen Intel(R) Core(TM) i7-12650H (2.30 GHz)', 1, 457.00, 100, 'img/12thgenintel_i7/12650h.jpg'),
(1235, 'NVIDIA® GeForce RTX™ 3050 GPU 6GB GDDR6 96-bit', 2, 254.99, 65, 'img/nvidiageforcertx30506gb96.jpg');

/* Insertion dans le panier */
INSERT INTO Cart(cart_id, user_id_number, product_id, quantity) VALUES
(1, 3, 1234, 2),
(1, 3, 1235, 1);

/* Insertion dans la table des transactions. total_items est la somme des quantités et total_cost est la somme de line total.
 Note: Les inserts into pour Transactions et Transactions_details resteront vide jusqu'à ce que le code pour le backend soit amorcé. Il est plus
 pertinent que ce soit le backend qui gère ces deux tables là. */
INSERT INTO Transactions(transaction_date, total_items, total_cost, user_id_number) VALUES
