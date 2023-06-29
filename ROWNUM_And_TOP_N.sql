--ROWNUM
	-- 출력되는 행의 순서를 나타내는 의사(Pseudocolumn)
SELECT ROWNUM
      ,e.EMPNO
      ,e.ENAME 
      ,e.JOB 
      ,e.DEPTNO 
	FROM EMP e  
   WHERE e.JOB IN ('ANALYST','CLERK');

 SELECT ROWNUM
      ,e.EMPNO
      ,e.ENAME 
      ,e.JOB 
      ,e.DEPTNO 
	FROM EMP e  
   WHERE e.DEPTNO = 20; 

 	-- WHERE 절에 ROWNUM 조건을 사용하면 조회되는 행의 개수를 제한할 수 있다.
  		-- ROWNUM = 1이나 ROWNUM >=1 등은 결과가 출력되긴 하지만 사용을 권장하지는 않는다. (ROWNUM <= 1 사용 권장)  		 
 SELECT ROWNUM
 	   ,e.EMPNO
 	   ,e.ENAME
	FROM EMP e 
   WHERE ROWNUM <= 5;
	
	--인라인 뷰 내에서 ROWNUM 값에 칼럼 별칭을 지정하면 마치 칼럼처럼 사용이 가능하다
 SELECT e.rn, e.empno, e.ename
 	FROM (
 		  SELECT ROWNUM AS RN
 		  		,e.EMPNO
 		  		,e.ENAME
 		  	FROM EMP e
 		 ) e
	WHERE e.rn > 5;
	
--TOP N
	-- 특정 기준으로 상위 N개를 추출하는 쿼리를 TOP-N쿼리라고 한다.
SELECT a.*
	FROM (
	 	  SELECT a.empno
	 	        ,a.ename
	 	        ,a.sal
	 	    FROM emp a
	 	   ORDER BY a.sal DESC) a
	WHERE ROWNUM <= 5;

	-- 평균 급여가 높은 순으로 3개 직무
SELECT a.job
	  ,a.cnt_emp
	  ,a.avg_sal
	FROM (
	 	  SELECT a.job
	 	        ,count(a.empno)       AS cnt_emp
	 	        ,round(avg(a.sal), 1) AS avg_sal
	 	    FROM emp a
	 	   GROUP BY a.job
	 	   ORDER BY avg(a.sal) DESC) a
	WHERE ROWNUM <= 3;
