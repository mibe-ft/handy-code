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


my_params = {'step_up_matrix': extract_data_from_file('step_up_matrix.csv')}

with open(p.joinpath('template.sql')) as f:
    sql = f.read()

rendered_sql = Template(sql).render(step_up_matrix=my_params['step_up_matrix'])

with open(p.joinpath('WIP_jinja.sql'), 'w') as f:
    f.write(rendered_sql)
    # TODO change extension to sql.j2
