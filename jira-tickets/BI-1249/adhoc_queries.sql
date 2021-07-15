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
from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc
;