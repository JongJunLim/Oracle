CREATE TABLE lag_test(
   Createddate DATE,
   category VARCHAR2(20),
   Price INT
);
	

INSERT INTO lag_test(Createddate, Category, Price) VALUES('2020-10-01', 'a', 100);
INSERT INTO lag_test(Createddate, Category, Price) VALUES('2020-10-02', 'a', 200);
INSERT INTO lag_test(Createddate, Category, Price) VALUES('2020-10-09', 'a', 400);
INSERT INTO lag_test(Createddate, Category, Price) VALUES('2020-10-02', 'b', 800);
INSERT INTO lag_test(Createddate, Category, Price) VALUES('2020-10-03', 'b', 500);
INSERT INTO lag_test(Createddate, Category, Price) VALUES('2020-10-02', 'c', 800);

-- 테이블 확인
SELECT * FROM lag_test order by category, Createddate;

-- 카테고리 기준 전 Price 값 불러오기 및 현 Price - 전 Price 
WITH TEMP AS (
SELECT 
	Createddate, category, Price, 
	NVL(LAG(Price, 1) OVER (PARTITION BY Category ORDER BY Createddate), 0) AS Price2
FROM lag_test)

SELECT 
	category, Createddate, Price, Price2, Price - Price2
FROM TEMP;

-- Row Number 부여 및 카테고리별로 가장 마지막 행 불러오기
SELECT
        Createddate, category, price,
        NVL(LAG(Price, 1) OVER (PARTITION BY Category ORDER BY Createddate), 0) AS Price2,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Createddate DESC) AS rn
    FROM lag_test;

WITH TEMP AS (
    SELECT
        Createddate, category, price,
        NVL(LAG(Price, 1) OVER (PARTITION BY Category ORDER BY Createddate), 0) AS Price2,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Createddate DESC) AS rn
    FROM lag_test
)
SELECT
    category, Createddate, Price, Price2, Price - Price2
FROM TEMP
WHERE rn = 1;

DROP TABLE lag_test;
