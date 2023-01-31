/* 데이터 집계하기 */ 
-- > (1) 그룹화하기 (2) 집계함수 사용 (3) 집계쿼리((1)+(2))

-- (3) 집계 쿼리
-- "연도"별 개봉 영화 수의 합 집계하기
use mywork;
desc box_office;

select year(release_date), count(*)  -- 표시할 것들
  from box_office
 group by year(release_date)   -- 연도별로 그룹화
 order by year(release_date);  -- 연도별로 정렬
 
-- (실습) 2019년 개봉 영화의 "유형"별 매출액의 최댓값, 최솟값, 전체합을 집계하기
select movie_type, max(sale_amt), min(sale_amt), sum(sale_amt) 
  from box_office
 where year(release_date) = 2019  -- 2019년 개봉 영화 중
 group by movie_type  -- 유형별로 그룹화
 order by 1;  -- 첫번째 칼럼(movie_type)을 중심으로 오름차순정렬

-- (실습) 2019년 개봉 영화 중 매출액이 1억 원 이상인 영화의 "분기"별, "배급사"별 개봉 영화수와 매출액(합계) 집계하기
select quarter(release_date) 분기, distributor 배급사, count(*) 영화수, sum(sale_amt) 매출액합
  from box_office
 where year(release_date) = 2019 and sale_amt >= 100000000  -- 2019년 개봉영화 중 매출액이 1억원 이상인 영화
 group by quarter(release_date), distributor  -- 분기별, 배급사별로 그룹화 
 order by 1;  -- 첫번째 칼럼(분기) 중심으로 오름차순 정렬
 
-- (실습) world 데이터베이스의 city 테이블에서 "국가코드"별 도시수 집계하기
use world;
desc city;
select countrycode 국가코드, count(*) 도시수 
  from city
 group by countrycode  -- "국가코드별"로 그룹화
 order by 2 desc;  -- 두번째 칼럼(도시수)기준으로 내림차순 정렬하기

-- (실습) world 데이터베이스의 country 테이블에서 "대륙"별 면적(surfacearea)이 가장 큰 순으로 정렬하기
select continent 대륙, count(*) 나라수 , sum(surfacearea) 대륙별면적, sum(population) 대륙별인구
  from country
 group by continent
 order by 3 desc;  -- 세번째 칼럼인 대륙별면적 기준으로 내림차순 정렬
 
-- (실습) mywork 데이터베이스의 box_office 테이블에서 2019년 개봉 영화중 1~10위 영화, 나머지 영화를 구분하되,
-- 각 그룹의 매출액 합 집계하기
use mywork;

select case when ranks between 1 and 10 then '상위10'
			else '나머지'
	   end 순위, count(*) 영화수, round(sum(sale_amt)/100000000, 1) '매출액합(억)'  -- end 뒤에 표값으로 나올 값들 별칭쓰기
	from box_office
  where year(release_date) = 2019  -- 2019년 개봉영화 중
  group by 1;  -- "순위"별(case로 나눈 순위)로 그룹화

-- 2019년 개봉영화 중 매출액이 1000만원 이상인 영화 중 "영화유형"별로 매출액 합 집계하기(+ 총합 with rollup)
-- with rollup으로 합계(소계, 총계) 구하기       
select movie_type, count(*), sum(sale_amt) -- 1870105386118
  from box_office
 where year(release_date) = 2019
  and sale_amt > 10000000
 group by movie_type with rollup;  -- "영화유형"별로 / 소계, 총계 둘다 구하기니까 rollup

-- 아래 쿼리문으로 위의 roll up 총합 값이 같음을 확인할 수 있음
select sum(sale_amt)  -- 1870105386118
  from box_office
 where year(release_date) = 2019
  and sale_amt > 10000000;
  
-- 2019년 개봉영화 중 매출액이 1000만원 이상인 영화 중 
-- "월"별, "영화유형"별 매출액을 집계하기
select month(release_date) 월, movie_type 영화유형, count(*) 영화수, sum(sale_amt) 매출합
  from box_office
 where year(release_date) = 2019
   and sale_amt > 10000000
 group by month(release_date), movie_type with rollup
 order by 1;  -- 월별 기준으로 오름차순 정렬 (1월 -> 2월 -> 3월 ->...)

-- grouping 함수 사용하기 : grouping의 결과가 1일 때 with rollup의 결과인 총합임을 알 수 있음
select movie_type, count(*), grouping(movie_type)
  from box_office
 where year(release_date) = 2019
 group by movie_type with rollup;

-- grouping 을 응용하여 총합에 해당하는 null값을 적당한 단어("합계")로 대체
select if(grouping(movie_type)=0, movie_type, "합계") 유형, count(*) 영화수, sum(sale_amt) 매출합 
-- if(expr1, expr2, expr3) = expr1인 grouping(movie_type)=0이 참이면 movie_type출력, 거짓이면(=1,rollup부분)은 "합계" 출력(이쁘게 별칭만들어줌)
-- rollup 안하면 groupint(movie_type)이 0임 
  from box_office
 where year(release_date) = 2019
 group by movie_type with rollup;

-- Having 절 사용하기
-- box_office 테이블에서 순위가 1~10위에 있는 영화를 조회하되
-- "개봉연월"별로 개봉영화 편수 집계하기
select extract(year_month from release_date) 개봉연월, count(*) 개봉편수
  from box_office
 where ranks between 1 and 10
 group by 개봉연월;

-- 이 때 영화가 2편이상 개봉한 항목만 조회하기
-- 아래와 같이 집계함수를 where 절에 쓰면 error!!
select extract(year_month from release_date) 개봉연월, count(*) 개봉편수
  from box_office
 where ranks between 1 and 10
   and count(*) >=2
 group by 개봉연월;

-- having 절 사용했을 때 ok
select extract(year_month from release_date) 개봉연월, count(*) 개봉편수
  from box_office
 where ranks between 1 and 10
 group by 개봉연월
 having count(*) >=2  -- 2편 이상 개봉한 영화만 필터링해줌
 order by 2 desc;

-- (실습) "개봉연월"별로 순위가 1~10위에 있는 영화 편수와 매출액합 구하기
select extract(year_month from release_date) 개봉연월, count(*) 영화편수, sum(sale_amt) 매출액합
  from box_office
 where ranks between 1 and 10
 group by 1;

-- 이 때 "개봉연월"별 매출액합이 1500억 이상인 경우만 조회하기 (having 절)
select extract(year_month from release_date) 개봉연월, count(*) 영화편수, round(sum(sale_amt)/100000000, 1) '매출액합(억)'
  from box_office
 where ranks between 1 and 10
 group by 1
 having sum(sale_amt) > 150000000000;  -- 매출액합이 1500억 이상인 경우만 필터링
 

-- (실습) 2019년 개봉영화 중 매출액이 1000만원 이상인 것을 골라 "영화유형"별로 매출액합 구하기 (with rollup)
select movie_type 영화유형, count(*) 영화편수, round(sum(sale_amt)/100000000, 1) '매출액합(억)'
  from box_office
 where year(release_date) = 2019 and sale_amt >= 10000000
 group by movie_type with rollup;

-- 이 때 "영화유형"별로 매출액 합계로 나온 결과 행만 조회하기(having 절)
select if(grouping(movie_type)=0, movie_type, "합계") 영화유형, count(*) 영화편수, round(sum(sale_amt)/100000000, 1) '매출액합(억)'
  from box_office
 where year(release_date) = 2019 and sale_amt >= 10000000
 group by movie_type with rollup
 having grouping(movie_type) = 1;  -- 매출액 합계(rollup 된 부분)만 필터링 해서 출력

-- (실습) 2019년 개봉 영화 중 매출액이 1000만원 이상인 것을 골라 "월"별, "영화유형"별로 매출액 합 집계하기(with rollup)
use mywork;
select month(release_date) 월, movie_type 영화유형, sum(sale_amt) 금액
	from box_office
	where year(release_date) = 2019 and sale_amt >= 10000000
    group by month(release_date), movie_type with rollup
    order by 1; -- 월별로 오른차순 정렬(1월->2월->...)

-- 이 때, "월"별, "영화유형"별 매출액 합계(유형별소계, 월별총계로 나온 결과 행만 조회하기 (having절)
select if(grouping(month(release_date))=0, month(release_date), "총계") 월, 
	if(grouping(movie_type)=0, movie_type, "소계") 영화유형, 
    round((sale_amt/100000000),1) "매출액합(억)"
  from box_office
 where year(release_date) = 2019 and sale_amt >= 10000000
 group by month(release_date), movie_type  with rollup
 having grouping(movie_type) = 1   -- 매출액 합계된 부분만 조회하기 위해
 order by month(release_date);
 
 -- (실습) box_office 테이블에서 2019년 개봉영화 중 "국가(rep_country)"별 관객수(audience_num)의 합이 50만명 이상인 것을 조회하기
 select rep_country 국가, count(*) 영화편수, sum(audience_num) 관객수합
	from box_office
    where year(release_date) = 2019
	group by rep_country
    having sum(audience_num) >= 500000;

-- 이때, "국가"별 합계까지 구하는 쿼리 작성하기(with rollup)
select if(grouping(rep_country)=0, rep_country, "국가별합") 국가, count(*) 영화편수, sum(audience_num) 관객수합
	from box_office
    group by rep_country with rollup
    having sum(audience_num) >= 500000;
    
-- (실습) box_office 테이블에서 2015년 이후 개봉한 영화 중
-- 관객수가 100만을 넘긴 영화의 감독과 관객수, 개봉편수를 "연도"별, "감독"별로 집계하기
desc box_office;
select year(release_date) 연도, director 감독 , audience_num 관객수 , count(*) 개봉편수
	from box_office
    where year(release_date) >= 2015 and audience_num > 100000
    group by year(release_date), director with rollup;
    
-- 이때, 개봉 편수가 2번 이상 되는 건수만 조회하기 (having 절)
select year(release_date) 연도, director 감독 , audience_num 관객수 , count(*) 개봉편수
	from box_office
	where year(release_date) >= 2015
    group by year(release_date), director with rollup
    having count(*) >= 2;

/* xpdlqmfrks rhksrP aowwl */
-- (1) 내부 조인
-- select 
--	from 테이블 as 별칭1
--  inner join 테이블2 as 별칭2  -> 그냥 join만 쓰면 inner join으로 알아들음
--  on 별칭1.칼럼1 = 별칭2.칼럼2
--  and ...
--  where ;
use world;
select count(*) from city; -- 4079
select count(*) from country;  -- 239

-- city 테이블과 country 테이블을 조인해서 국가명, 대륙명 , 인구까지 조회하기
select *  -- count(*) = 4079건이 조회됨 -> 큰 쪽으로 맞춰짐
	from city a  -- as 생략될 수 있음(별칭)
    inner join country b
	on a.CountryCode = b.Code;

-- 조인된 결과에 대해 추가적으로 where 문을 통해 필터링
select a.*, b.name, b.continent, b.population
	from city a
    inner join country b
    on a.countrycode = b.Code
    where a.countrycode = 'kor';

-- 내부 조인에서는 테이블의 위치를 바꿔도 결과는 동일 (전체적으로 바꿔주기)
select a.*, b.name, a.continent, a.population
	from country a
    inner join city b
    on b.CountryCode = a.code
    where b.CountryCode = 'kor';

-- (실습) country 테이블과 countrylanguage 테이블 내부조인
select * from country; -- code ->a
select * from countrylanguage; -- countrycode -> b
select * 
	from country a 
    inner join countrylanguage b 
    on a.code = b.countrycode;
    
-- 조인결과가 어떤 테이블의 맞춰줬는지 확인    
select count(*) from country; -- 239
select count(*) from countrylanguage; -- 984
select count(*) -- 984 (countrycode b 큰 집합체에 맞춰짐)
	from country a 
    inner join countrylanguage b 
    on a.code = b.countrycode;
    

 
 
 