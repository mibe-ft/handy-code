from jinja2 import Template
from pathlib import Path

p = Path(__file__).parents[0]  # set folder directory

def extract_data_from_file(file):

    file = p.joinpath(file)
    with open(file) as f:
        content = f.read().splitlines()[1:]  # read in lines without \n (newline character) and skip header line

    content_formatted = []
    for item in content:
        # remove apostrophes and split by commas into two items
        content_formatted.append(tuple([a.replace("'", "") for a in item.split(",")]))

    content_formatted = [x if len(x) > 1 else x[0] for x in content_formatted]
    return content_formatted


my_params = {'metadata': extract_data_from_file('data.csv')}

# with open(p.joinpath('template.sql')) as f:
#     sql = f.read()
print(my_params)
# exit()
sql = """
CREATE TABLE `ft-bi-team.sandbox_mibe.funnels_b2b_nnb`(
{%- for col_name, data_type in metadata %}
    {{col_name}} {{data_type}}
{%- if not loop.last -%}
    ,
    {%- endif -%}
    {%- endfor %}
 )
"""

rendered_sql = Template(sql).render(metadata=my_params['metadata'])

with open(p.joinpath('bq_create_table_schema_jinja.sql'), 'w') as f:
    f.write(rendered_sql)
    # TODO change extension to sql.j2
