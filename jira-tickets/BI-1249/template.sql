DROP TABLE IF EXISTS biteam.b2b_job_titles;
CREATE TABLE biteam.b2b_job_titles (
    job_title VARCHAR,
    job_type VARCHAR
);

INSERT INTO biteam.b2b_job_titles VALUES
{%- for title, type in data %}
    ('{{title}}', '{{type}}')
{%- if not loop.last -%}
        ,
    {%- endif -%}
    {%- endfor %}
;