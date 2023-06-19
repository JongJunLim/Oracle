--UNPIVOT
-- 형식
SELECT *
    FROM ( 피벗 대상 쿼리문 )
 UNPIVOT ( 컬럼별칭(값) FOR 컬럼별칭(열) IN (피벗열명 AS '별칭', ... )

-- 복수개 Unpivot 형식
SELECT * FROM sale_stats
UNPIVOT (
    (quantity, amount)
    FOR product_code
    IN (
	        (a_qty, a_value) AS 'A',
        (b_qty, b_value) AS 'B'
    )
);

-- 예제
WITH temp AS (
    SELECT 1 AS col1, 2 AS col2, 3 AS col3 FROM dual
)

 SELECT col_nm
      , col_val
   FROM (
          SELECT *
            FROM temp
        )
UNPIVOT (col_val  -- unpivot_clause
         FOR col_nm  -- unpivot_for_clause
         IN (col1, col2, col3)); -- unpivot_in_clause

----------------------------------------------------
--Practice

CREATE TABLE stage_table(
    id INT PRIMARY KEY,
    Stage VARCHAR2(20),
    Stage1_Actual DATE,
    Stage1_Plan DATE,
    Stage2_Actual DATE,
    Stage2_Plan DATE,
    Stage3_Actual DATE,
    Stage3_PLAN DATE    
);

INSERT INTO stage_table(id, stage, Stage1_Actual, Stage1_Plan, Stage2_Actual, Stage2_Plan, Stage3_Actual, Stage3_PLAN)
VALUES(1
       ,'Complete'
       , TO_DATE('2023-05-01', 'yyyy-mm-dd')
       , TO_DATE('2023-05-03', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-15', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-14', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-20', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-25', 'yyyy-mm-dd'));

INSERT INTO stage_table(id, stage, Stage1_Actual, Stage1_Plan, Stage2_Actual, Stage2_Plan, Stage3_Actual, Stage3_PLAN)
VALUES(2
       ,'Stage3'
       , TO_DATE('2023-05-02', 'yyyy-mm-dd')
       , TO_DATE('2023-05-05', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-10', 'yyyy-mm-dd')
       ,TO_DATE('2023-05-20', 'yyyy-mm-dd')
       ,NULL
       ,TO_DATE('2023-05-30', 'yyyy-mm-dd'));
      
SELECT *
 FROM stage_table;


-- 1개 UNPIVOT 
SELECT ID, Stage, End_Actual FROM 
 (SELECT id, Stage1_Actual, Stage2_Actual FROM stage_table)
UNPIVOT( End_Actual -- unpivot_clause
         FOR Stage -- unpivot_for_clause
         IN ( -- unpivot_in_clause
             Stage1_Actual AS 'Stage1',
              Stage2_Actual AS 'Stage2'
    )
);

-- 2개 UNPIVOT
SELECT ID, Stage, End_Actual, End_Plan 
 FROM (SELECT id, Stage1_Actual, Stage2_Actual, Stage3_Actual, Stage1_Plan, Stage2_Plan, Stage3_Plan FROM stage_table)
UNPIVOT( (End_Actual, End_Plan) -- unpivot_clause
         FOR Stage -- unpivot_for_clause
         IN ( -- unpivot_in_clause
             (Stage1_Actual, Stage1_Plan) AS 'Stage1',
             (Stage2_Actual, Stage2_Plan) AS 'Stage2',
             (Stage3_Actual, Stage3_Plan) AS 'Stage3'
    )
);  


-- 테이블 제거 
-- DROP TABLE stage_table;

--PIVOT
SELECT job, HIREDATE
 FROM emp;

SELECT * 
  FROM ( 
         SELECT job , TO_CHAR(hiredate, 'FMMM') || '월' hire_month 
           FROM emp 
       ) 
 PIVOT (
         COUNT(*) 
         FOR hire_month IN ('1월', '2월', '3월', '4월', '5월', '6월',
                            '7월', '8월', '9월', '10월', '11월', '12월') 
       );
