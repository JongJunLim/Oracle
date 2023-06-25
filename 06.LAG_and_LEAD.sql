--오라클에서 이전 행의 값을 찾거나 다음 행의  값을 찾기 위해서는 LAG, LEAD 함수를 사용하면 된다.
	--LAG(expr [,offset] [,default]) OVER([partition_by_clause] order_by_clause)
	--LEAD(expr [,offset] [,default]) OVER([partition_by_clause] order_by_clause)
		--LAG 함수 : 이전 행의 값을 리턴
		--LEAD 함수 : 다음 행의 값을 리턴
		--expr : 대상 컬럼명
		--offset : 값을 가져올 행의 위치 기본값은 1, 생략가능
		--default : 값이 없을 경우 기본값, 생략가능
		--partition_by_clause : 그룹 컬럼명, 생략가능
		--order_by_clause : 정렬 컬럼명, 필수

--기본 사용법
SELECT empno
     , ename
     , job
     , sal
     , LAG(empno) OVER(ORDER BY empno)  AS empno_prev
     , LEAD(empno) OVER(ORDER BY empno) AS empno_next
  FROM emp 
 WHERE job IN ('MANAGER', 'ANALYST', 'SALESMAN')

--현재 행 기준으로 두번째 이전 값을 표시
SELECT empno
     , ename
     , job
     , sal
     , LAG(empno, 2) OVER(ORDER BY empno) AS empno_prev
  FROM emp 
 WHERE job IN ('MANAGER', 'ANALYST', 'SALESMAN')

--가져올 행이 없는 경우 기본값(9999)를 가져온다
SELECT empno
     , ename
     , job
     , sal
     , LAG(empno, 2, 9999) OVER(ORDER BY empno) AS empno_prev
  FROM emp 
 WHERE job IN ('MANAGER', 'ANALYST', 'SALESMAN')

	
-- 프로젝트 사례 적용 Test
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
