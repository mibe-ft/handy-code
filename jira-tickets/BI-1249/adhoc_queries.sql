select job_title, position, industry, count(distinct ft_user_id) users from ftlighthousedb.dim_user
where job_title is not null
group by 1,2,3
order by 4 desc;

select count(distinct lower(job_title)) from ftlighthousedb.dim_user
where job_title is not null
;
