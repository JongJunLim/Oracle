-- 날짜 및 시간 연산
select to_char(sysdate, 'CC') as 세기
      ,to_char(sysdate, 'YYYY') as 년
      ,to_char(sysdate, 'MM') as 월
      ,to_char(sysdate, 'MON') as 월_약자
      ,to_char(sysdate, 'MONTH') as 월_이름
      ,to_char(sysdate, 'DD') as 일
      ,to_char(sysdate, 'DDD') as 몇일째
      ,to_char(sysdate, 'DY') as 요일
      ,to_char(sysdate, 'DAY') as 요일_이름
      ,to_char(sysdate, 'W') as 몇번째주
    from dual;

select sysdate
      ,to_char(sysdate, 'DY', 'NLS_DATE_LANGUAGE=KOREAN') as KOR
      ,to_char(sysdate, 'DY', 'NLS_DATE_LANGUAGE=JAPANESE') as JAP
      ,to_char(sysdate, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') as ENG
      ,to_char(sysdate, 'DAY', 'NLS_DATE_LANGUAGE=KOREAN') as KOR
      ,to_char(sysdate, 'DAY', 'NLS_DATE_LANGUAGE=JAPANESE') as JAP
      ,to_char(sysdate, 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH') as ENG
    from dual;

select to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS AM') as today 
	from dual;

SELECT SYSDATE + 1 
	FROM DUAL;

SELECT ADD_MONTHS(SYSDATE,6) "6개월 뒤" --현재시간 + 6개월 뒤
      ,LAST_DAY(SYSDATE) "당월 마지막 일" --해당월 마지막 일자 계산
      ,NEXT_DAY(SYSDATE,'일요일') "다음주 일요일" --다음 주 일요일 계산
      ,MONTHS_BETWEEN(SYSDATE, SYSDATE-100) --DATE1과 DATE2의 개월 수 반환
	FROM DUAL

SELECT TO_CHAR(SYSDATE ,'yyyy/mm/dd') --오늘 날짜  
      ,TO_CHAR(SYSDATE + 1 ,'yyyy/mm/dd') --내일 날짜  
      ,TO_CHAR(SYSDATE -1 ,'yyyy/mm/dd') --어제 날짜 
      ,TO_CHAR(TRUNC(SYSDATE,'dd') ,'yyyy/mm/dd hh24:mi:ss') -- 오늘 정각 날짜
      ,TO_CHAR(TRUNC(SYSDATE,'dd') + 1,'yyyy/mm/dd hh24:mi:ss') -- 내일 정각 날짜
      ,TO_CHAR(SYSDATE + 1/24/60/60 ,'yyyy/mm/dd hh24:mi:ss') -- 1초 뒤 시간
      ,TO_CHAR(SYSDATE + 1/24/60 ,'yyyy/mm/dd hh24:mi:ss') -- 1분 뒤 시간
      ,TO_CHAR(SYSDATE + 1/24 ,'yyyy/mm/dd hh24:mi:ss') -- 1일 뒤 시간
      ,TO_CHAR(TRUNC(SYSDATE,'mm') ,'yyyy/mm/dd') --이번 달 시작날짜
      ,TO_CHAR(LAST_DAY(SYSDATE) ,'yyyy/mm/dd') --이번 달 마지막 날
      ,TO_CHAR(trunc(ADD_MONTHS(SYSDATE, + 1),'mm') ,'yyyy/mm/dd') --다음 달 시작날짜
      ,TO_CHAR(ADD_MONTHS(SYSDATE, 1) ,'yyyy/mm/dd hh24:mi:ss') -- 다음달 오늘 날자
      ,TO_CHAR(TRUNC(SYSDATE, 'yyyy') ,'yyyy/mm/dd') --올해 시작 일
      ,TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -12), 'dd'),'yyyy/mm/dd') --작년 현재 일
      ,TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE('19930315') -- 두 날짜 사이 일수 계산
      ,MONTHS_BETWEEN(SYSDATE, '19930315') -- 두 날짜 사이의 월수 계산
      ,TRUNC(MONTHS_BETWEEN(SYSDATE, '19930315')/12,0) --두 날짜 사이의 년수 계산
	FROM DUAL; 

WITH temptable AS (
    SELECT to_date('2019-08-21 08:00:00', 'yyyy-mm-dd hh24:mi:ss') curtime 
      FROM dual
)

SELECT curtime
      ,curtime + 5/24         hour --5시간 더하기 
      ,curtime + 5/(24*60)    min  --5분 더하기
      ,curtime + 5/(24*60*60) sec  --5초 더하기
  FROM temptable;

--Interval 활용
WITH temptable AS (
    SELECT to_date('2019-08-21 08:00:00', 'yyyy-mm-dd hh24:mi:ss') curtime 
      FROM dual
)

SELECT curtime
      ,curtime + (interval '5' hour)   hour2 --5시간 더하기 
      ,curtime + (interval '5' minute) min2  --5분 더하기
      ,curtime + (interval '5' second) sec2  --5초 더하기
  FROM temptable;
