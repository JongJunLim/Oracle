-- 1.스칼라 서브쿼리 
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
  
 --2.인라인 뷰
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
--3.중첩 서브쿼리
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
