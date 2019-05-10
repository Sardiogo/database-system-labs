DELIMITER $$
DROP function IF EXISTS how_many_accounts $$
CREATE FUNCTION how_many_accounts(name VARCHAR(255))
	RETURNS INT
	BEGIN
		DECLARE how_many INT;
			SELECT COUNT(account_number) INTO how_many 
			FROM depositor
			WHERE customer_name = name;
		RETURN how_many;
	END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS how_many_accounts $$
CREATE PROCEDURE how_many_accounts(IN name VARCHAR(255))
	BEGIN
		SELECT COUNT(account_number)
		FROM depositor
		WHERE customer_name = name;
	END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS how_many_accounts2 $$
CREATE PROCEDURE how_many_accounts2(
	IN name VARCHAR(255),
	OUT how_many INT)
	BEGIN
		SELECT COUNT(account_number) INTO how_many 
		FROM depositor
		WHERE customer_name = name;
	END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS how_many_accounts3 $$
CREATE PROCEDURE how_many_accounts3(
	IN name VARCHAR(255),
	OUT how_many INT)
	BEGIN
		DECLARE done INT DEFAULT 0;
		DECLARE cust_name, account_num VARCHAR(255);
		DECLARE my_cursor CURSOR FOR 
			SELECT * FROM depositor;
		DECLARE CONTINUE HANDLER FOR 
			NOT FOUND 
				SET done = 1;
		SET how_many = 0;
		OPEN my_cursor;
		my_loop: LOOP
			FETCH my_cursor INTO cust_name, account_num;
			IF done THEN 
				LEAVE my_loop; 
			END IF;
			IF cust_name = name THEN
				SET how_many = how_many + 1;
			END IF;
		END LOOP;
		CLOSE my_cursor;
	END$$
DELIMITER ;

DROP FUNCTION IF EXISTS withdraw;
DELIMITER $$
CREATE FUNCTION withdraw(
	a_number VARCHAR(255),
	amount NUMERIC(20,2))
	RETURNS NUMERIC(20,2)
	BEGIN
		UPDATE account
		SET balance = balance - amount
		WHERE account_number = a_number;
		RETURN amount;
	END$$
DELIMITER ;

DROP FUNCTION IF EXISTS withdraw2;
DELIMITER $$
CREATE FUNCTION withdraw2(
		c_name VARCHAR(255),
		a_number VARCHAR(255),
		amount NUMERIC(20,2))
		RETURNS NUMERIC(20,2)
	BEGIN
		IF c_name IN (
				SELECT customer_name
				FROM depositor
				WHERE account_number = a_number) 
			THEN
				UPDATE account
				SET balance = balance - amount
				WHERE account_number = a_number;
				RETURN amount;
		END IF;
		RETURN 0.0;
	END$$
DELIMITER ;

DROP FUNCTION IF EXISTS max_withdraw;
DELIMITER $$
CREATE FUNCTION max_withdraw(
		c_name varchar(255),
		a_number varchar(255),
		amount numeric(20,2)) 
		RETURNS decimal(20,2)
	BEGIN
		DECLARE max_amount numeric(20,2);
			SELECT balance INTO max_amount
			FROM account
			WHERE account_number = a_number;
		IF c_name IN (
				SELECT customer_name
				FROM depositor
				WHERE account_number = a_number)  
			THEN
				IF amount <= max_amount THEN
					UPDATE account
					SET balance = balance - amount
					WHERE account_number = a_number;
					RETURN amount;
				ELSE
					SIGNAL SQLSTATE  '45000'
						SET MESSAGE_TEXT ='The account has insufficient balance';
				END IF;
		END IF;
		RETURN 0.0;
	END$$
DELIMITER ;