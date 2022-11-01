drop table if exists highschool_students;

-- 기본키 설정 1
create table if not exists highschool_students(
	student_no varchar(20) not null primary key,
    student_name varchar(100) not null,
    grade tinyint,
    class varchar(20),
    gender varchar(20),
    age smallint,
    enter_date date
);

-- 기본키 설정 2
create table if not exists highschool_students(
	student_no varchar(20) not null,
    student_name varchar(100) not null,
    grade tinyint,
    class varchar(20),
    gender varchar(20),
    age smallint,
    enter_date date,
    constraint primary key(student_no)
);

desc highschool_students;

-- 기본키 설정 3
create table if not exists highschool_students(
	student_no varchar(20) not null,
    student_name varchar(100) not null,
    grade tinyint,
    class varchar(20),
    gender varchar(20),
    age smallint,
    enter_date date
);

desc highschool_students;

alter table highschool_students
add primary key(student_no);

desc highschool_students;

-- (실습)
-- my_first_table 이라는 테이블을 만드려고 합니다.
-- (1) 각 칼럼의 내용을 보고 어떤 데이터 타임을 사용하면 될지 데이터 타입 항목을 채우세요.
-- 항목		컬럼명			컬럼설명				데이터 타입
-- 사번		employee_id		숫자 1에서 300까지 할당	smallint
-- 이름		employee_name	문자					varchar
-- 급여		salary			사원의 급여			int	
-- 입사일자	hire_date		날짜                 date

-- (2) 위 데이터 타입을 기준으로 my_first_table 이라는 SQL문을 잘성하세요.

create table if not exists my_first_table(
	employee_id smallint,
    employee_name varchar(100),
    salary int,
    hire_date date
);

desc my_first_table;

-- (3) 위에서 생성된 테이블을 삭제하는 SQL문을 작성하세요.
drop table if exists my_first_table;

-- (4) (2)에서 작성한 테이블 생성 문장을 참고해 사전 칼럼(employee_id)을 기본 키로 하는 테이블을 다시 만드세요.

create table if not exists my_first_table(
	employee_id smallint primary key,
    employee_name varchar(100),
    salary int,
    hire_date date
);

desc my_first_table;

-- box office 테이블의 모든 칼럼 조회하기
desc box_office;

select * 
	from box_office;
    
select count(*) -- 해당 테이블의 행의 수가 몇개인지를 집계
	from box_office;

-- 다른 데이터베이스의 테이블 조회하기
select * -- * : 모든 칼럼들
	from world.city;  -- 데이터베이스명.테이블명

select count(*)
	from world.city;

-- where 절로 조회 조건 지정하기
select *
	from world.city
    where CountryCode = 'kor';  -- 컬럼명 = 값s

-- like 로 같은 문자열 조회하기     
use world;

select *
	from city
    where district like 'k%';  -- where 컬럼명 like 'k%' 칼럼에 해당하는 값 중, k로 시작하는거 있으면 True

select * 
	from city
    where district like '%k'; -- district 컬럼에 해당하는 값 중, k로 끝나는 문자열이 있으면 True

select district, name, population
	from city
    where district like '%k%'; -- district 컬럼에 해당하는 값 중, k가 중간에 있는 문자열이 있으면 True 
    
-- 논리 연산자
select *
	from city
    where countrycode = 'kor' and population > 500000 ;
    
-- in 연산자
select *
	from city
    where district in ('seoul', 'kyonggi');  -- 아래꺼보다 더 간단하게 쓰는 방법
   -- where district = 'seoul' or district = 'Kyonggi' ;
   
-- country 테이블 조회하기
select * from country;

-- 인구가 4500만명 이상이고 5500만명 이하인 name, continent, population, region 조회하기
select name, continent, population, region
	from country
    where population >= 45000000 and population <= 55000000 ;
    -- where population between 45000000 and 55000000; 위와 같은 결과 나타남

use mywork;
select * from box_office; 

/*

장경희
  오후 2:36
(테이블) box_office table : 2004~2019년까지 개봉된 영화 정보
-- seq_no : 일련번호, 기본키
-- years : 제작연도
-- ranks : 순위
-- movie_name : 영화명
-- release_date : 개봉일
-- sale_amt : 매출액
-- share_rate : 점유율(매출액 기준)
-- audience_num : 관객수
-- screen_num : 스크린수
-- showing_count : 상영횟수
-- rep_country : 대표국적
-- countries : 국적
-- distributor : 배급사
-- movie_type : 유형(장편, 단편, ...)
-- genre : 장르(스릴러, 액션..)
-- director : 감독
*/
desc box_office;

-- (실습)
-- 2018년 개봉한 한국 영화 조회하기
select *
	from box_office
    where release_date between '2018-01-01' and '2018-12-31'
		and rep_country = '한국';
        
select*
	from box_office
    where release_date like '2018%'
    and rep_country = '한국';

-- 2019년 개봉 영화 중 관객수가 500만명 이상인 영화 조회하기
select *
	from box_office
    where release_date between '2019-01-01' and '2019-12-31'
    and audience_num >= 5000000;
    
-- 2019년 개봉 영화 중 관객수가 500만명 이상이거나 매출액이 400억원 이상인 영화 조회하기
select *
	from box_office
    where release_date like '2019%'
    and (audience_num >= 5000000 or sale_amt >= 40000000000);

use world;
select id, name, population / 10000 as 'population(만명단위)'
	from city;    
    
-- 데이터 정렬하기
-- country 테이블에서 population이 1억명 이상인 나라에 대해 내림차순 정렬하되,
-- code, name, continent, region, population 가져오기

select code, name continent, region, population
	from country
    where population >= 100000000
    order by population desc;
    
-- 칼럼명 대신 순번(5)으로 대체하여 위와 동일한 결과 
select code, name continent, region, population
	from country
    where population >= 100000000
    order by 5 desc;
    
-- (실습)
-- country 테이블에서 population이 5천만명 이상인 나라에 대해
-- continent 오름 차순 정렬한 뒤, region으로 내림차순 정렬한 뒤
-- name, continent, region 가져오기

desc country;

select name, continent, region
	from country
    where population >= 50000000
    order by continent asc, region desc;
    
-- (실습)
-- city 테이블에서 우리나라에 속한 도시에 대해 모든 칼럼을 가져오되
-- 도시명은 오름차순, 인구는 내림차순으로 조회하기
select * from city
    where countrycode = 'kor' 
    order by name asc, population desc;

-- 데이터 조회 개수 제한하기
use mywork;
select * from box_office
    limit 10;
    
-- (실습)
-- 2019년 개봉영화 중에 관객이 500만명 이상인 데이터에 대해
-- 매출액 기준 내림차순 정렬 한 뒤, 상위 5건만 가져오기

select * from box_office
	where release_date like '2019%'
    and audience_num >= 5000000
    order by sale_amt desc
    limit 5;

-- (실습)
-- world database의 countrylanguage table에 국가별 사용 언어가 있고,
-- 이 테이블 percentage 컬럼에는 해당 언어가 사용되는 비율값이 들어 있음
-- 이 비율이 99% 이상인 것을 국가코드 순으로 조회하기
use world;
desc countrylanguage;
select * from countrylanguage
	where percentage >= 99
    order by countrycode;
    
-- (실습)
-- world database에 접속된 상태에서 mywork database에 있는 box_office 테이블에서
-- 2019년 제작된 영화중 순위(ranks)가 1위에서 10위까지인 영화를 순위(ranks)별로 조회하기
select * from mywork.box_office
	where years = 2019 
    and ranks between 1 and 10
    order by ranks;
    
-- (실습)
-- mywork database로 이동해 box_office 테이블에서
-- 2019년 제작된 영화중 영화유형(movie_type)이 장편이 아닌 영화를 순위(ranks)대로 조회하기
select * from mywork.box_office
	where years = 2019
    and movie_type != '장편'
    order by ranks;
    
-- (실습)
-- box_office 테이블에서 2019년 제작된 영화 중 스크린수 기준 상위 10개 영화 조회하기
select * from mywork.box_office
	where years = 2019
    order by screen_num desc
    limit 10;