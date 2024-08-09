--which IT skills are desirable to learn as an analyst in north america based on salary and demand??
--Here are the top 10 IT skills in demand and associated salaries
with skills_in_demand as(
    select sd.skill_id,
        sd.skills,
        count (sjd.job_id) as num_jobs
    from job_postings_fact as jpf
        inner join skills_job_dim as sjd on jpf.job_id = sjd.job_id
        inner join skills_dim as sd on sjd.skill_id = sd.skill_id
    where job_title_short like '% Analyst'
        and --only analyst jobs are of interest--
        job_country in ('United States', 'Canada')
        and --assuming north american jobs only
        job_location = 'Anywhere' --location anywhere withitn globe thus including N.A
        and jpf.salary_year_avg is not null
    group by sd.skill_id
),
avg_salary as (
    select sd.skill_id,
        sd.skills,
        cast (avg(jpf.salary_year_avg) as money) as avg_salary
    from job_postings_fact as jpf
        inner join skills_job_dim as sjd on jpf.job_id = sjd.job_id
        inner join skills_dim as sd on sjd.skill_id = sd.skill_id
    where job_title_short like '% Analyst'
        and --only analyst jobs are of interest--
        job_country in ('United States', 'Canada')
        and --assuming north american jobs only
        job_location = 'Anywhere' --location anywhere withitn globe thus including N.A
        and jpf.salary_year_avg is not null
    group by sd.skill_id
)
select distinct skills_in_demand.skills,
    num_jobs,
    avg_salary
from skills_in_demand
    inner join avg_salary on skills_in_demand.skill_id = avg_salary.skill_id
where num_jobs > 50
order by num_jobs desc,
    avg_salary DESC
limit 10