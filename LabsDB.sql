CREATE TABLE MyTable (
  id NUMBER,
  val NUMBER
);

DECLARE
  v_id NUMBER;
  v_val NUMBER;
BEGIN
  FOR i IN 1..10000 LOOP
    -- Генерация случайных значений для id и val
    v_id := ROUND(DBMS_RANDOM.VALUE(1, 10000));
    v_val := ROUND(DBMS_RANDOM.VALUE(1, 100));

    -- Вставка записи в таблицу
    INSERT INTO MyTable (id, val) VALUES (v_id, v_val);
  END LOOP;
  COMMIT; -- Фиксация изменений
END;