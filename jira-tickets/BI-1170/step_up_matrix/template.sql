DROP TABLE IF EXISTS biteam.step_up_matrix;
CREATE TABLE biteam.step_up_matrix (
    currency VARCHAR,
    lower_band FLOAT,
    higher_band FLOAT,
    new_price FLOAT,
    percent_discount VARCHAR,
    code INT,
    offer_id VARCHAR,
    product_term VARCHAR,
    product_name VARCHAR,
    valid_from DATE,
    valid_to DATE
);

INSERT INTO biteam.step_up_matrix VALUES
{%- for curr, lb, hb, np, pc_disc, code, offer_id, product_term, product_name, valid_from, valid_to in step_up_matrix %}
    ('{{curr}}', {{lb}}, {{hb}}, {{np}}, '{{pc_disc}}', {{code}}, '{{offer_id}}', '{{product_term}}', '{{product_name}}','{{valid_from}}', '{{valid_to}}')
{%- if not loop.last -%}
        ,
    {%- endif -%}
    {%- endfor %}
;
