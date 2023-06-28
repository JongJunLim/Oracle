-- 집합 연산자(Set Operators)
	 -- 개별로 실행 가능한 쿼리들의 결과 집합 간에 연산을 수행한다.
SELECT col1, col2, ...
	FROM TABLE 
   [WHERE / GROUP BY / HAVING]
 집합 연산자
SELECT col1, col2, ...
	FROM TABLE 
   [WHERE / GROUP BY / HAVING]
    ORDER BY col [ASC / DESC], ... ;
   	-- 제약 사항
   		-- 대상 쿼리들의 select 절에 기술된 컬럼/표현식의 개수가 일치해야한다.
   		-- 대상 쿼리들의 select 절에 기술된 컬럼/표현식의 데이터 타입이 순서대로 일치해야한다.
   		-- Order by 절은 전체 쿼리의 맨 끝에만 올 수 있다.

SELECT e.ENAME AS NAME
      ,e.DEPTNO
      ,e.SAL AS SALARY
	FROM EMP e 
   WHERE e.DEPTNO = 10
UNION ALL
SELECT e.job
      ,NULL 
      ,SUM(SAL) AS SUM_SAL
	FROM EMP e
    GROUP BY e.job; 

	-- 합집합(UNION ALL, UNION) 
		-- 쿼리 결과 집합들간의 합집합을 리턴
			-- 중복된 행 제거 하지 않음(UNION ALL 
			-- 중복된 행을 제거함(UNION)
	-- 교집합(INTERSECT) / 차집합(MINUS)
	-- 집합 연산자는 위에서 아래 순으로 실행이 되지만, 괄호를 이용하여 우선 순위를 변경할 수 있
SELECT d.DEPTNO
	FROM DEPT d                   -- 1
MINUS
SELECT e.DEPTNO
	FROM EMP E
   WHERE e.JOB = 'SALESMAN'     -- 2
UNION
SELECT e.DEPTNO
	FROM EMP E
   WHERE e.JOB = 'ANALYST';     -- 3
   
SELECT d.DEPTNO 
	FROM DEPT d                   -- 3
MINUS
(SELECT e.DEPTNO
	FROM EMP E
   WHERE e.JOB = 'SALESMAN'     -- 1
UNION
SELECT e.DEPTNO
	FROM EMP E
   WHERE e.JOB = 'ANALYST');    -- 2
