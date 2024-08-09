--which company pays the best in a role related to analytics in North America??
--what are the IT skills related to those roles? 
with job_posted_salaried as(
        SELECT *
        from job_postings_fact
        where salary_year_avg is not null
),
top_paying_job as(
        select cd.name,
                sd.skills,
                job_title,
                job_schedule_type,
                job_location,
                --assuming north american jobs only
                (cast(salary_year_avg as money)),
                job_posted_date
        from job_posted_salaried
                left join company_dim as cd on job_posted_salaried.company_id = cd.company_id
                left join skills_job_dim as sjd on job_posted_salaried.job_id = sjd.job_id
                inner join skills_dim as sd on sjd.skill_id = sd.skill_id
        where job_title_short like '% Analyst'
                and --only analyst jobs are of interest--
                job_country in ('United States', 'Canada')
                and --assuming north american jobs only
                job_location = 'Anywhere' --location anywhere withitn globe thus including N.A
        order BY salary_year_avg desc
)
select *
from top_paying_job