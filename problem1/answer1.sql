-- creating a stored procedure in MySQL that accepts a year as input and checks whether it is a leap year.

DELIMITER $$
CREATE PROCEDURE IsLeapYear(IN year INT)
BEGIN
  DECLARE leapYear BOOLEAN;
  SET leapYear = FALSE;

  IF year MOD 4 = 0 THEN
    IF year MOD 100 = 0 THEN
      IF year MOD 400 = 0 THEN
        SET leapYear = TRUE;
      END IF;
    ELSE
      SET leapYear = TRUE;
    END IF;
  END IF;

  IF leapYear = TRUE THEN
    SELECT year, ' is a leap year.' AS result;
  ELSE
    SELECT year, ' is not a leap year.' AS result;
  END IF;
END$$
DELIMITER ;

-- calling the stored procedure by using the following code:

CALL IsLeapYear(2000);

CALL IsLeapYear(2005);

