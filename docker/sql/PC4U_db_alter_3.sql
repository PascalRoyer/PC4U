/* delete Cart d'abord */
CREATE TABLE Cart (
	cart_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	user_id_number BIGINT NOT NULL,
	product_id BIGINT NOT NULL,
	quantity INT NOT NULL CHECK (quantity > 0),
	FOREIGN KEY (user_id_number) REFERENCES Users(user_id_number),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);