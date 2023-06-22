-- 분석 함수(Analytic Fungtion)
-- 개별 행을 유지한 채 집계 값을 계산할 수 있는 함수이다.
  -- 집계 함수 (Aggregate Functions)는 행 그룹 별로 값을 집계하고, 각 행 그룹을 단일 행 (1 row)으로 그룹화하여 리턴한다. 하지만 분석함수는 개별 행을 유지한 채로 값을 집계하기 때문에 원본 값과 집계 값을 함께 분석할 수 있다.
  -- 분석 함수 실행시 대상이 되는 행의 범위를 윈도우(window)라고 하며, analytic_clause에 의해 각 행(current row) 별로 윈도우가 정의 된다.
-- 모든 join, where절, group by 절, having 절의 수행은 분석 함수 실행 전에 완료 된다. 따라서 분석함수는 select 절, order by 절 내에서만 사용할 수 있다.

--쿼리 파티션
  -- PARTITION BY 절을 사용하여 GROUPO BY 절과 유사하게 논리적인 행의 그룹을 생성할 수 있으며, 각 행의 윈도우(실행 대상 행의 범위)는 파티션을 벗어날 수 없다.
  
 SELECT a.empno
      ,a.ename
      ,a.hiredate
      ,a.deptno
      ,a.sal
      ,SUM(a.sal) OVER (PARTITION BY a.deptno) AS SUM_SAL
  FROM emp a;
  
-- 분석 함수 활용 (다양한 집계 기준)
  -- PARTITION BY 절만 변경하면 여러 집계 기준의 집계 값을 한번에 추출할 수 있다.
  SELECT a.empno
      ,a.ename
      ,a.hiredate
      ,a.deptno
      ,a.sal
      ,SUM(a.sal) OVER (PARTITION BY a.deptno) AS DEPTNO_SUM_SAL
      ,SUM(a.sal) OVER (PARTITION BY a.job) AS JOB_SUM_SAL
  FROM emp a;
  
-- 분석 함수 활용 (누적 집계)
  -- 파티션 내에서 ORDER BY 절에 기술한 순서대로 현재 행까지의 값을 누적 집계 할수 있다.
    -- PARTITION BY 절이 생략되면 전체 행을 대상으로 누적 집계 값을 계산한다. (애매한 부분이 있음 - 동일 값 집계 X)
SELECT a.empno
      ,a.ename
      ,a.hiredate
      ,a.deptno
      ,a.sal
      ,SUM(a.sal) OVER (PARTITION BY a.deptno ORDER BY a.sal) AS SUM_SAL
  FROM emp a;
  
-- Windowing 절
  -- 각 행마다 분석함수의 실행 대상이 되는 행의 범위(윈도우)를 세밀하게 지정한다.
  -- 물리적인 행의 범위를 지정하거나 논리적인 값의 범위를 지정할 수 있다.
    -- analytic_clause 내 order by 절의 컬럼 또는 표현식이 윈도우의 기준이 된다.
  -- 각 행의 윈도우(실행 대상 행의 범위)는 파티션을 벗어날 수 없다.
  -- Syntac : ROWS/RANGE BETWEEN start_point and end_point
    -- Start_point & end_point : ROWS (시작행 / 종료행) / RANGE (값의 범위)
    -- UNBOUNDED PRECEDING : 파티션의 첫 번째 행 / 파티션의 첫 번째 행의 값
    -- N PRECEDING : (파티션 내에서) 현재 행을 기준으로 이전 N번째 행 / 현재 행의 값 - N
    -- CURRENT ROW : 현재 행 / 현재 행의 값
    -- N FOLLOWING : (파티션 내에서) 현재 행을 기준으로 이후 N번째 행 / 현재 행의 값 + N
    -- UNBOUNDED FOLLOWING : 파티션의 마지막 행 / 파티션의 마지막 행의 값

-- UNBOUNDED PRECEDING : 파티션의 첫 번째 행 / CURRENT ROW : 현재 행 -- 누적 집계
SELECT a.empno
      ,a.ename
      ,a.hiredate
      ,a.deptno
      ,a.sal
      ,SUM(a.sal) OVER (PARTITION BY a.deptno ORDER BY a.sal --정렬 기준
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT_ROW) AS SUM_SAL
  FROM emp a;
  
-- N PRECEDING : (파티션 내에서) 현재 행을 기준으로 이전 N번째 행 / N FOLLOWING : (파티션 내에서) 현재 행을 기준으로 이후 N번째 행
SELECT a.empno
      ,a.ename
      ,a.hiredate
      ,a.deptno
      ,a.sal
      ,SUM(a.sal) OVER (PARTITION BY a.deptno ORDER BY a.sal --정렬 기준
                        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS SUM_SAL
  FROM emp a;
  
-- RANGE
SELECT a.empno
      ,a.ename
      ,a.hiredate
      ,a.deptno
      ,a.sal
      ,SUM(a.sal) OVER (PARTITION BY a.deptno ORDER BY a.sal --정렬 기준
                        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT_ROW) AS SUM_SAL
  FROM emp a;
  
-- ROWS / RANGE BETWEEN UNBOUNDED PRECEDING = ROWS / RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT_ROW (명시해주는 것이 좋음)
