/* SQL 함수 사용하기 */
-- 수식 연산자

select 7+2;
select 7-2;
select 7/2, 7%2, 7 div 2;

-- 숫자형 함수
select ceil(6.5);  
select floor(6.5);
select mod(7,2), 7%2;  -- 나머지 연산
select power(4,3);
select sqrt(25);
select round(1153.456,1), round(1153.456,2);
select round(1153.456,-1), round(1153.456,-2);
select rand(2);  -- 0~1 사이의 무작위 수

-- 문자형 함수
select char_length('sql');
select char_length('홍길동');

select length('sql');
select length('홍길동');  -- 그냥 length를 쓰면 '홍'에 3byte가 필요해서 총 9byte가 나옴

select concat('this','is','mysql');
select concat('this', null,'mysql');
select concat_ws('**', 'this','is','mysql');  -- 문자열 사이사이에 ** 넣어줌

select format(55000000, 2);  -- 뒤에 있는 2는 소수점 자리수를 의미함

select lower('ABCd'), upper('AbCd');  -- lower 소문자, upper 대문자

select lpad('sql', '7', '8');
select rpad('sql', '7', '8');

select left('thisismysql', 4);  -- 왼쪽으로부터 글자 떼어내기
select right('thisismysql',4);  -- 오른쪽으로부터 글자 떼어내기

select reverse('sql');  -- 뒤집어서 출력alter

select replace('생일 축하해 철수야','철수', '영희');  -- 철수를 영희로 대체

select instr('abc','c');  -- c의 위치 찾기
select locate('c','abcabcabc', 7); -- 어디서부터 찾을 지 위치 지정 및 찾기
select position('c' in 'abc');

select substr('this is my sql', 6, 2);  -- 6번째부터 시작해서 2개만 뽑아주세요 // 2 = 얼마큼 뗴어서 내줄건지
select substr('this is my sql',-8, 2);
select substr('this is my sql', 6);  -- 6번쨰부터 시작해서 끝까지
-- substr, substing, mid 다 동일한 함수

select mid('this is my sql', 6, 2) as mid함수의결과; -- 별칭을 내가 정할 수도 있음

select trim('     mysql     ');
select trim(both ' ' from '     mysql     ');
select trim(leading '*' from '****mysql****');  -- 앞에만 * 뺴주세요
select trim(trailing '*' from '****mysql****'); -- 뒤에만 * 빼주세요

select strcmp('mysql', 'mysql');  -- 누가 앞인지 뒤인지 값의 차이를 알고 싶을 때 -> 같을 때는 0을 return
select strcmp('mysql1', 'mysql2');  -- -> -1
select strcmp('mysql2', 'mysql1');  -- -> 1

-- (실습 ) 문자형 함수 사용
-- world 데이터 베이스에 접속해서 country 테이블에서 인구가 4,500만명에서 5,500만명 사이에 있는 국가를 조회하되,
-- 국가명(name)과 대륙명(continent)을 연결해서 '국가명(대륙명)' 형태로 조회하기
-- (예: South Korea (Asia))
-- 표시될 컬럼명 : code, name, continent, name(continent)

use world;
select code, name, continent, concat(name, '(', continent, ')')
	from country
    where population between 45000000 and 55000000;

-- (실습) 숫자형 함수 사용
-- mywork 데이터베이스에 접속해 box_office 테이블에서 2019년 개봉한 한국 영화 중 관객수가 500만 명 이상인 영화를 조회
-- 이 때 매출액은 1억으로 나눈 후 소수점 없이 반올림 한 결과를 표시하기
-- 표시될 컬럼명(4개) : years, ranks, movie_name, release_date, audience_num, sale_amt(1억단위)

use mywork;
select years, ranks, movie_name, release_date, audience_num, ROUND(sale_amt div 100000000)
	from box_office
	where release_date between '2019-01-01' and '2019-12-31'
    and rep_country = '한국' and audience_num >= 5000000;

desc box_office;

-- (실습) 문자형 함수 사용
-- 현재 box_office 테이블에 영화감독(director)이 두명 이상이면 ',' 로 연결되어 있음
-- 감독이 1명이면 그대로 두고, 두명 이상이면 ','대신에 '/' 값으로 대체해 조회

select movie_name, replace(director, ',', '/') as 'director(/로 구분)'
	from box_office
	where instr(director, ',') > 0;  -- director 문자열에서 ','문자를 찾아 시작위치 반환
    -- 이니까 0보다 크면 , 가 있다는 걸 이용
    
-- 날짜형 함수
select current_date();
select current_time();
select now();
select current_timestamp();
select dayname('2022-11-02');
select dayofmonth('2022-11-02');  
select dayofweek('2022-11-02'); -- 일요일 기준으로 몇번쨰 날인지
select dayofyear('2022-11-02');
select last_day('2022-11-02');
select year('2022-11-02');
select month('2022-11-02');
select quarter('2022-11-02');

select adddate('2022-11-02', 10);
select date_add('2022-11-02', interval 10 day);
-- interval expr unit
-- https://dev.mysql.com/doc/refman/8.0/en/expressions.html#temporal-intervals
select date_add('2022-11-02', interval '1-3' year_month);

select subdate('2022-11-02', 10);
select date_sub('2022-11-02', interval 10 day);
select date_sub('2022-11-02', interval '1 3' day_hour);

select extract(year_month from '2022-11-02');
select extract(day_hour from '2022-11-02 12:12:00');
select extract(minute_second from '2022-11-02 12:12:00');

-- date_format에서 사용하는 식별자
-- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format
select date_format('2022-11-02', "%d-%b-%Y" );

select makedate(2022, 100);
select makedate(2022, 365);

select sysdate(), sleep(2), sysdate(); -- 함수 호출 시간 기준
select now(), sleep(2), now();  -- 문장 단위 시간 기준

select week('2022-11-02');
select yearweek('2022-11-02');

-- (실습) 날짜형 함수
-- 현재 날짜를 기준으로 현재 일이 속한 월의 마지막 날짜에 해당하는 요일 구하기
select dayname(last_day(current_date()));

-- (실습) 날짜형 함수
-- 연인과 처음으로 만난 날이 2021년 5월 12일인데, 100일, 500일, 1000일이 되는 날을 조회하기
select adddate('2021-05-12', 100) as 100일, adddate('2021-05-12', 500) as 500일, adddate('2021-05-12', 1000) as 1000일;

-- (실습) 날짜형, 문자형 함수
-- mywork 데이터베이스에 접속해 box_office 테이블에서 2019년에 개봉된 영화 중, 영화 제목에 ':'이 들어간 영화 조회
use mywork;
select * from box_office
	where release_date between '2019-01-01' and '2019-12-31'
    and instr(movie_name, ':') > 0;

-- 기타 함수들 
select cast(10 as char);  -- 10을 문자형태로
select convert(10, char);

select cast('2022-11-02' as datetime);  -- 시간정보까지 따라오게
select convert('2022-11-02', datetime);

-- 흐름제어 함수
-- select if(표현식1, 표현식2, 표현식3) -- 식1이 참이면 2, 거짓이면 3 출력
select if(2<1, 1, 0); -- 거짓이라 0 출력됨
select if(2>1, 1, 0); -- 참이라 1 출력됨

select ifnull(null, 'null입니다');  -- 식1이 null이면 null입니다 출력
select ifnull(1, 'null입니다');  -- 식1이 null이 아니라 그대로 1 출력

select nullif(1, 1);  -- 값이 같으면 null 출력
select nullif(1, 2);  -- 값이 같지 않기에 1 출력

select case 1 when 1 then '1입니다'
			  when 2 then '2입니다'
			  when 3 then '3입니다'
			  when 4 then '4입니다'
              else 'none'
		end case1,
	   case 2 when 1 then '1입니다'
			  when 2 then '2입니다'
			  when 3 then '3입니다'
			  when 4 then '4입니다'
              else 'none'
		end case2;
-- 위와 동일        
select case when 1=1 then '1입니다'
			when 1=2 then '2입니다'
			when 1=3 then '3입니다'
			when 1=4 then '4입니다'
			else 'none'
		end case1,
	   case when 2=1 then '1입니다'
			when 2=2 then '2입니다'
			when 2=3 then '3입니다'
			when 2=4 then '4입니다'
			else 'none'
		end case2;


-- (실습) 날짜형 함수
-- box_office 테이블에서 2019년 개봉한 영화 중 순위(ranks) 기준 상위 10위까지의 영화 조회하되,
-- 이 때 개봉일이 무슨 요일인지 개봉일이 어떤 분기에 속해 있는지도 조회하기
-- 표시할 칼럼 : 영화 이름, 개봉일, 개봉요일, 분기 
select movie_name as 영화이름, release_date as 개봉일, dayname(release_date) as 개봉요일, quarter(release_date) as 분기
	from box_office
	where release_date between '2019-01-01' and '2019-12-31'
    order by ranks
    limit 10;
    
-- (실습) 흐름제어 함수
-- 위의 결과를 활용하여 분기를 상반기, 하반기로 바꾸어 표현해보자.
-- (예: 1,2분기이면 상반기, 3,4분기이면 하반기)
-- option 1 (case 사용)
select movie_name as 영화이름, release_date as 개봉일, dayname(release_date) as 개봉요일, 
	   case when quarter(release_date) = 1 then '상반기'
			when quarter(release_date) = 2 then '상반기'
			when quarter(release_date) = 3 then '하반기'
			when quarter(release_date) = 4 then '하반기' 
		end 분기
        from box_office
		where release_date between '2019-01-01' and '2019-12-31'
		order by ranks
		limit 10;

-- (실습) 흐름제어 함수
-- world 데이터베이스에 있는 country 테이블에는 indepyear라는 칼럼에는 해당국가의 독립연도가 저장되어 있음
-- 이 때 각 국가명과 독립연도를 조회(출력)해 독립연도의 값이 없으면 '없음', 있으면 해당 독립연도가 출력
desc world.country;
select Indepyear from world.country;
select Name, ifnull(Indepyear, '없음') as indepyear 
from world.country;

-- (실습)
-- mywork 데이터베이스의 box_office 테이블에서 2019년 개봉한 영화 중
-- 순위 (ranks)가 1~10위인 경우 "상위10" 그 외(11위 이상)는 "나머지"라고 표시하기
select movie_name, ranks, if(ranks <= 10, '상위10위', '나머지') as ranks
	from mywork.box_office
	where year(release_date) = 2019;

select movie_name,
	case when ranks <= 10 then '상위10'
		 else '나머지'
         end ranks
	from mywork.box_office
	where year(release_date) = 2019;

/* 데이터 집계하기*/
-- (1) 그룹화하기 (2) 집계함수사용 (3) 집계쿼리 ((1)+(2))

-- (1) 그룹화하기
use world;
select continent
	from country
	group by continent
    order by continent;
    
select continent
	from country
	group by 1
    order by 1;

select continent, region
	from country
	group by continent, region
    order by continent, region;
    
select name, district, substr(district, 1, 3) as dist
	from city
    where countrycode = 'kor'
    group by substr(district, 1, 3);  -- group by district으로도 그룹핑가능 / 3으로도 써도 됨 / 별칭 dist 넣어도 됨
    
-- Note. group by 한 대상(칼럼, 표현식, 순번)이 select에 나와야 의미가 있음
-- (아래와 같이 하면 안됨!)
select continent
	from country
    group by region;
    
select continent  -- 정보적으로 다 압축되어 있음
	from country
    group by continent;

select distinct continent -- 외견상으로만 group by와 같이 보임(중복값 존재x)
	from country;

-- (2) 집계함수    
select *
	from country;
    
select count(*)
	from country;

select count(name), count(continent), count(distinct continent)
	from country;

select min(population), max(population), avg(population)
	from country
	where continent = 'europe';
    
select name, population
	from country
    where continent = 'europe' and population = 1000;
    
-- (sub query 방식 : 1, 2 단계를 한번에)
select b.name, b.population
from (
select min(population) as min_population 
from country
where continent = 'europe'
)a, country b
where b.population = a.min_population;
