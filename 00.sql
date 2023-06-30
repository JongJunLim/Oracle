-- PIVOT 절
-- Oracle 11g 버전부터 사용 가능
-- FROM 절과 WHERE 절 사이에 기술한다.
	-- aggregate_funtion(arg)에는 PIVOT 결과로 출력할 값을 지정
	-- FOR 절에는 PIVOT 기준 컬럼을 지정
	-- IN 절에는 PIVOT 기준 컬럼의 값을 지정
SELECT Col1, Col2, ...
	FROM 테이블/인라인 뷰
   PIVOT (aggregate_funtsion(arg) [, aggregate_function(arg2),...]
   		FOR Col1 [,Col2, ...]
		  IN (값1 [, 값2,...)
		 );

SELECT *
	FROM (SELECT a.DEPTNO, a.SAL FROM EMP a) a
	PIVOT (sum(a.SAL)
		FOR deptno 
	 	 IN (10,20,30)
	 );
	
-- 부분 집계를 활용한 PIVOT 기능 구현
SELECT SUM(CASE WHEN a.deptno = 10 THEN a.sal END) AS D10_SUMSAL
      ,SUM(CASE WHEN a.deptno = 20 THEN a.sal END) AS D20_SUMSAL
      ,SUM(CASE WHEN a.deptno = 30 THEN a.sal END) AS D30_SUMSAL
	FROM emp a;

-- PIVOT 절 내에서 참조하지 않은 컬럼들을 기준으로 행이 그룹화 된다.
	-- 일반적으로 인라인 뷰 or with 문으로 컬럼을 한정한다
SELECT *
	FROM emp a
	PIVOT (SUM(a.sal)
		FOR deptno
		 IN (10
		    ,20
		    ,30
		    )
		  );
