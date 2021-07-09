select lower(job_title) job_title, position, industry, count(distinct ft_user_id) users from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc
;

select count (distinct lower(job_title)) from ftlighthousedb.dim_user --96239 ;
select distinct industry from ftlighthousedb.dim_user -- 32;

select distinct position from ftlighthousedb.dim_user --23;