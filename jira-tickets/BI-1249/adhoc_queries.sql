select lower(job_title) job_title, position, industry, count(distinct ft_user_id) users from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc
;

select count (distinct lower(job_title)) from ftlighthousedb.dim_user --96239 ;
select distinct industry from ftlighthousedb.dim_user -- 32;

select distinct position from ftlighthousedb.dim_user --23;

-- join job titles
with b2b_job_titles as (
select lower(job_title) job_title , lower(job_type) job_type from biteam.b2b_job_titles),
lighthouse_job_titles as (
select lower(job_title) job_title, position, industry, count(distinct ft_user_id) users from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc
), jobs_without_nulls as (
select a.job_title
, a.users
, b.job_title as job_title_a
, b.job_type
from lighthouse_job_titles a
left join b2b_job_titles b on a.job_title = b.job_title
where b.job_title is not null
order by a.users desc
), numbers as (
select
(select sum(users) from jobs_without_nulls) as joined_without_nulls_sum,
(select sum(users) from lighthouse_job_titles) as original)
select * from jobs_without_nulls
;

--(29622/766127)*100
;

select lower(job_title) job_title, position, industry, count(distinct ft_user_id) users
, SUM(users) OVER() sum_users
, Round((1.0 * users)/ (1.0* sum_users)*100.00, 2) percentage_of_total
from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc
;

-- calculating running total
select lower(job_title) job_title, position, industry, count(distinct ft_user_id) users
, SUM(users) OVER() sum_users
, Round((1.0 * users)/ (1.0* sum_users)*100.00, 2) percentage_of_total
, SUM(users) OVER(order by users desc rows between unbounded preceding and current row) running_total
, (1.0*running_total)/(1.0*sum_users)*100
from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc
;


with b2b_job_titles as (
select lower(job_title) job_title , lower(job_type) job_type from biteam.b2b_job_titles),
lighthouse_job_titles as (
select lower(job_title) job_title, position, industry, count(distinct ft_user_id) users from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc
), joined_titles as (
select a.job_title
, a.users
, b.job_title as job_title_a
, b.job_type
from lighthouse_job_titles a
left join b2b_job_titles b on a.job_title = b.job_title
--where b.job_title is not null
order by a.users desc
), numbers as (
select
(select count(distinct job_title) from b2b_job_titles) ,
(select count(distinct job_title) from lighthouse_job_titles)
)
--select * from numbers
--SELECT
--(select count(job_title) from joined_titles where job_title_a is not null),
--(select count(job_title) from joined_titles where job_title_a is null)
SELECT
SUM(CASE WHEN job_title_a IS NULL THEN 1 ELSE 0 END) null_count
, SUM(CASE WHEN job_title_a IS NOT NULL THEN 1 ELSE 0 END) non_null_count
, SUM(CASE WHEN job_title_a IS NULL THEN users ELSE 0 END) sum_users_null
, SUM(CASE WHEN job_title_a IS NOT NULL THEN users ELSE 0 END) sum_users_not_null
, SUM(users) total_users
, ((1.0*sum_users_null)/(1.0*total_users))*100.0
, ((1.0*sum_users_not_null)/(1.0*total_users))*100.0
FROM joined_titles
--SELECT
--'Null Count: '||SUM(CASE WHEN job_title_a IS NULL THEN 1 ELSE 0 END)||' Sum of users: '||SUM(CASE WHEN job_title_a IS NULL THEN users ELSE 0 END) null_count
--, 'Non-null Count: '||SUM(CASE WHEN job_title_a IS NOT NULL THEN 1 ELSE 0 END)||' Sum of users: '||SUM(CASE WHEN job_title_a IS NOT NULL THEN users ELSE 0 END) non_null_count
----, SUM(CASE WHEN job_title_a IS NULL THEN users ELSE 0 END)
----, SUM(CASE WHEN job_title_a IS NOT NULL THEN users ELSE 0 END)
--FROM joined_titles
;

select sum(users) from (
select lower(job_title) job_title, position, industry, count(distinct ft_user_id) users from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc)
;