DROP TABLE IF EXISTS #stepup_matrix;
CREATE TABLE #stepup_matrix (
    currency VARCHAR,
    lower_band FLOAT,
    higher_band FLOAT,
    new_price FLOAT,
    percent_discount VARCHAR,
    code INT,
    offer_id VARCHAR,
    subs_term VARCHAR,
    subs_product VARCHAR
);

INSERT INTO #stepup_matrix VALUES
{%- for curr, lb, hb, np, pc_disc, code, offer_id, term, product in stepup_matrix %}
('{{curr}}', {{lb}}, {{hb}}, {{np}}, '{{pc_disc}}', {{code}}, '{{offer_id}}', '{{term}}', '{{product}}')
{%- if not loop.last -%}
        ,
    {%- endif -%}
    {%- endfor %}
;
select * from #stepup_matrix