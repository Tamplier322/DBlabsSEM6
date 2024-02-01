CREATE TABLE MyTable (
  id NUMBER,
  val NUMBER
);

DECLARE
  v_id NUMBER;
  v_val NUMBER;
BEGIN
  FOR i IN 1..10000 LOOP
    v_id := ROUND(DBMS_RANDOM.VALUE(1, 10000));
    v_val := ROUND(DBMS_RANDOM.VALUE(1, 100));

    INSERT INTO MyTable (id, val) VALUES (v_id, v_val);
  END LOOP;
  COMMIT;
END;




CREATE OR REPLACE FUNCTION CheckEvenOdd
RETURN VARCHAR2
IS
  v_even_count NUMBER := 0;
  v_odd_count NUMBER := 0;
BEGIN
  FOR rec IN (SELECT val FROM MyTable)
  LOOP
    IF MOD(rec.val, 2) = 0 THEN
      v_even_count := v_even_count + 1;
    ELSE
      v_odd_count := v_odd_count + 1;
    END IF;
  END LOOP;

  IF v_even_count > v_odd_count THEN
    RETURN 'TRUE';
  ELSIF v_even_count < v_odd_count THEN
    RETURN 'FALSE';
  ELSE
    RETURN 'EQUAL';
  END IF;
END;

DECLARE
  v_result VARCHAR2(10);
BEGIN
  v_result := CheckEvenOdd();
  DBMS_OUTPUT.PUT_LINE('Result: ' || v_result);
END;




CREATE OR REPLACE FUNCTION GenerateInsertCommand(p_id NUMBER)
RETURN VARCHAR2
IS
  v_val NUMBER;
  v_insert_command VARCHAR2(200);
BEGIN
  SELECT val INTO v_val FROM MyTable WHERE id = p_id AND ROWNUM = 1;

  v_insert_command := 'INSERT INTO MyTable (id, val) VALUES (' || p_id || ', ' || v_val || ');';

  DBMS_OUTPUT.PUT_LINE('Insert Command: ' || v_insert_command);

  RETURN v_insert_command;
END;

DECLARE
  v_insert_cmd VARCHAR2(200);
BEGIN
  v_insert_cmd := GenerateInsertCommand(643);
END;




CREATE OR REPLACE PROCEDURE InsertRecord(p_id NUMBER, p_val NUMBER)
IS
BEGIN
  INSERT INTO MyTable (id, val) VALUES (p_id, p_val);
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE UpdateRecord(p_id NUMBER, p_new_val NUMBER)
IS
BEGIN
  UPDATE MyTable SET val = p_new_val WHERE id = p_id;
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE DeleteRecord(p_id NUMBER)
IS
BEGIN
  DELETE FROM MyTable WHERE id = p_id;
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE DeleteAllRecords
IS
BEGIN
  DELETE FROM MyTable;
  COMMIT;
END;

BEGIN
  DeleteAllRecords;
END;

BEGIN
  InsertRecord(1, 100);
END;

BEGIN
  UpdateRecord(1, 200);
END;

BEGIN
  DeleteRecord(1);
END;





CREATE OR REPLACE FUNCTION CalculateTotalCompensation(
  p_monthly_salary NUMBER,
  p_annual_bonus_percentage INTEGER
) RETURN NUMBER
IS
  v_annual_bonus_percentage NUMBER;
  v_total_compensation NUMBER;
BEGIN
  IF p_annual_bonus_percentage < 0 OR p_annual_bonus_percentage > 100 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Процент должен быть в диапазоне от 0 до 100');
  END IF;

  v_annual_bonus_percentage := p_annual_bonus_percentage / 100;

  v_total_compensation := (1 + v_annual_bonus_percentage) * 12 * p_monthly_salary;

  RETURN v_total_compensation;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
    RETURN NULL;
END;

DECLARE
  v_monthly_salary NUMBER := 5000;
  v_annual_bonus_percentage INTEGER := 10;
  v_result NUMBER;
BEGIN
  v_result := CalculateTotalCompensation(v_monthly_salary, v_annual_bonus_percentage);
  IF v_result IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('Общее вознаграждение за год: ' || v_result);
  END IF;
END;

