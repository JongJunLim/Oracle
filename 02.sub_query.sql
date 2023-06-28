-- 1.스칼라 서브쿼리 : WHERE 절이나 HAVING 절에 조건으로 사용되는 쿼리
 SELECT a.empno
     , a.ename
     , a.deptno
     , (SELECT dd.dname
          FROM dept dd
         WHERE dd.deptno = a.deptno) AS dept_name --DNAME이 EMP 테이블에 없어서 DEPT 테이블에서 조회 
  FROM emp a
 WHERE a.sal >= 3000;


SELECT a.empno
     , a.ename
     , a.job
     , a.sal
     , (SELECT ROUND(AVG(aa.sal))
                  FROM emp aa
                 WHERE aa.job = a.job) AS avg_sal
     , a.sal - (SELECT ROUND(AVG(aa.sal))
                  FROM emp aa
                 WHERE aa.job = a.job) AS avg_sal_diff -- 자신의 연봉에서 해당 직군의 평균 연봉과 차이를 계산하는 쿼리
  FROM emp a
 WHERE a.deptno = 20
 ORDER BY a.job, a.empno;

SELECT a.deptno
     , a.dname
     , CASE WHEN a.deptno IN (SELECT DISTINCT aa.deptno
                                FROM emp aa
                               WHERE aa.job = 'MANAGER')
            THEN 'Y' END AS manager_yn
  FROM dept a;
  
 -- 2.인라인 뷰 : FROM 절에 조회 대상 집합으로 사용되는 서브 쿼리
 SELECT a.empno
     , a.ename
     , a.job
     , b.mgr_name
     , b.mgr_dept
  FROM emp a
 INNER JOIN (SELECT a.empno AS mgr_no
                  , a.ename AS mgr_name
                  , b.dname AS mgr_dept
               FROM emp a
                  , dept b
              WHERE a.deptno = b.deptno) b
    ON (a.mgr = b.mgr_no)
 WHERE a.deptno = 10;

SELECT a.empno AS mgr_no
                  , a.ename AS mgr_name
                  , b.dname AS mgr_dept
               FROM emp a
                  , dept b
              WHERE a.deptno = b.deptno;
-- 3.중첩 서브쿼리(Nested-Subquery) : SELECT 절에 사용되며 단읽 값을 리턴하는 서브쿼리
	-- 비상관 서브 쿼리(Uncorrelated Subquery)
    	-- 메인 쿼리의 컬럼을 참조하지 않는 서브쿼리이다.
        -- 메인 쿼리의 각 행을 평가할 때 서브 쿼리의 결과가 달라지지 않는다.
             -- 단일 행 비상관 서브 쿼리
             	-- 서브쿼리가 단일 행을 리턴하는 비상관 쿼리이다. (2건 이상이면 오류 발생) 
             	-- 단일 값 비교 조건 (=,<,>,<=,>=,<> 등) 과 함께 사용 
             -- 다중 행 비상관 서브 쿼리
             	-- 서브쿼리가 다중 행을 리턴하는 비상관 쿼리이다. 
             	-- 다중 값 비교 조건인 IN 조건 또는 SOME/ANY(ANY를 SOME보다 많이 사용, MIN으로 대체 가능), ALL(MAX로 대채 가능) 조건 등과 함께 사용된다. 
              -- EXIST 조건과 상관 서브쿼리로 재작성할 수 있다.
              -- NOT IN 조건과 서브 쿼리를 사용할 때 서브쿼리의 결과에 NULL이 포함된 경우, 결과 집합이 공집합 (0)건이 될 수 있으므로 주의해야한다.
SELECT a.empno
     , a.ename
     , a.deptno
     , b.dname
  FROM emp a
 INNER JOIN dept b
    ON (a.deptno = b.deptno)
 WHERE a.job = 'CLERK'
   AND a.deptno IN (SELECT DISTINCT aa.deptno
                      FROM emp aa
                     WHERE aa.job = 'MANAGER')
 ORDER BY a.deptno;
 
SELECT a.empno
     , a.ename
     , a.deptno
     , b.dname
  FROM emp a
 INNER JOIN dept b
    ON (a.deptno = b.deptno)
 WHERE a.job = 'CLERK'
   AND EXISTS (SELECT 1
                 FROM emp aa
                WHERE aa.job = 'MANAGER'
                  AND aa.deptno = a.deptno)
 ORDER BY a.deptno;

SELECT a.empno
     , a.ename
     , a.job
     , a.sal
  FROM emp a
 WHERE a.job IN ('MANAGER', 'SALESMAN')
   AND a.sal >= (SELECT ROUND(AVG(aa.sal))
                   FROM emp aa
                  WHERE aa.job = a.job)
 ORDER BY a.job, a.empno;
