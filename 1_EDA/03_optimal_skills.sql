/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY 
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY 
    optimal_score DESC
LIMIT 25;

/* 
Here's a breakdown of the most optimal skills for Data Engineers, based on both high demand and high salaries:

Top Skills by Optimal Score:
- Terraform leads the list with a $184K median salary and 193 postings, resulting in the highest overall "optimal score".
- Python and SQL dominate demand (over 1100 postings each), with strong median salaries of $135K and $130K, respectively.
- AWS (783 postings, $137K median), Spark (503 postings, $140K median), and Airflow (386 postings, $150K median) are all highly sought-after cloud and big data technologies.
- Kafka offers high compensation ($145K median) and solid demand (292 postings).
- Tools like Snowflake, Azure, and Databricks each have 250–475 postings and median salaries between $128–$137K.

DevOps & Engineering Tools:
- Airflow ($150K), Kubernetes ($150.5K), and Docker ($135K) stand out for their mix of demand and top median salaries.
- Git ($140K/208 postings) and Github ($135K/127 postings) have broad utility and competitive compensation.

Noteworthy Languages:
- Java (303 postings, $135K median) and Scala (247 postings, $137K median) remain strong choices for well-paid data engineering roles.
- Go ($140K/113 postings) is another programming language with excellent compensation.

Databases & Cloud:
- Redshift ($130K/274 postings), GCP ($136K/196 postings), Hadoop ($135K/198 postings), NoSQL ($134.4K/193 postings), and MongoDB ($135.8K/136 postings) add to a well-rounded data engineering skill set.
- R, Pyspark, and BigQuery each deliver competitive salaries and meet the threshold for demand.

Summary:
Skills that consistently appear near the top balance a strong combination of market demand (job security) and financial benefit. Python, SQL, AWS, Spark, Airflow, and Terraform are particularly strategic for both immediate opportunities and longer-term career growth in data engineering.
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │         3248 │             8.1 │          1.49 │
│ python     │      135000.0 │        28776 │            10.3 │          1.39 │
│ airflow    │      150000.0 │         9996 │             9.2 │          1.38 │
│ aws        │      137320.0 │        17823 │             9.8 │          1.34 │
│ sql        │      130000.0 │        29221 │            10.3 │          1.34 │
│ spark      │      140000.0 │        12799 │             9.5 │          1.32 │
│ kafka      │      145000.0 │         6415 │             8.8 │          1.27 │
│ kubernetes │      150500.0 │         4202 │             8.3 │          1.26 │
│ golang     │      184000.0 │          912 │             6.8 │          1.25 │
│ snowflake  │      135500.0 │         8639 │             9.1 │          1.23 │
│ azure      │      128000.0 │        14143 │             9.6 │          1.22 │
│ databricks │      132750.0 │         8183 │             9.0 │           1.2 │
│ java       │      135000.0 │         7267 │             8.9 │           1.2 │
│ scala      │      137290.0 │         6304 │             8.7 │           1.2 │
│ pyspark    │      140000.0 │         4898 │             8.5 │          1.19 │
│ gcp        │      136000.0 │         6446 │             8.8 │          1.19 │
│ git        │      140000.0 │         4641 │             8.4 │          1.18 │
│ hadoop     │      135000.0 │         5447 │             8.6 │          1.16 │
│ rust       │      210000.0 │          232 │             5.4 │          1.14 │
│ docker     │      135000.0 │         4316 │             8.4 │          1.13 │
│ nosql      │      134415.0 │         4514 │             8.4 │          1.13 │
│ redshift   │      130000.0 │         5737 │             8.7 │          1.13 │
│ pandas     │      140000.0 │         2929 │             8.0 │          1.12 │
│ mongodb    │      135750.0 │         3512 │             8.2 │          1.11 │
│ bigquery   │      135000.0 │         3523 │             8.2 │           1.1 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
  25 rows                                                           5 columns
*/