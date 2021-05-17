DROP TABLE IF EXISTS #step_up_matrix;
CREATE TABLE #step_up_matrix (
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

INSERT INTO #step_up_matrix VALUES
{%- for curr, lb, hb, np, pc_disc, code, offer_id, term, product in step_up_matrix %}
    ('{{curr}}', {{lb}}, {{hb}}, {{np}}, '{{pc_disc}}', {{code}}, '{{offer_id}}', '{{term}}', '{{product}}')
{%- if not loop.last -%}
        ,
    {%- endif -%}
    {%- endfor %}
;
