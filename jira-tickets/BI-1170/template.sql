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
--('GBP',0.01,146.30,154,'-50%',1,'bb776c53-abdd-280d-4279-cd9aeb0257ff','annual','standard'),
--('GBP',146.31,196.65,207,'-33%',2,'a9582121-87c2-09a7-0cc0-4caf594985d5','annual','standard')
;
select * from #stepup_matrix