DROP FUNCTION IF EXISTS dept_count;
DELIMITER $$
CREATE FUNCTION dept_count(dept_name VARCHAR(20)) 
	RETURNS INTEGER
	BEGIN
		DECLARE d_count INTEGER;
    		SELECT COUNT(*) INTO d_count 
            FROM instructor
            WHERE instructor.dept_name = dept_name;
		RETURN d_count;
	END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS dept_count_proc;
DELIMITER $$
CREATE PROCEDURE dept_count_proc(
	IN dept_name VARCHAR(20), 
	OUT d_count INTEGER)
	BEGIN 
		SELECT count(*) INTO d_count
		FROM instructor
		WHERE instructor.dept_name= dept_name;
	END$$
DELIMITER ;

