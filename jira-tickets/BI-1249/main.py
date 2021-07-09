# from pathlib import Path
from jinja2 import Template
import datetime as dt
# p = Path(__file__).parents[0]  # set folder directory
today_date = dt.datetime.today().strftime('%Y_%m_%d_%H%M%S')

def extract_data_from_file(file):
    # file = p.joinpath('textfiles_for_jinja', file)
    with open(file) as f:
        content = f.read().splitlines()  # read in lines without \n (newline character)

    content_formatted = []
    for item in content:
        # remove apostrophes and split by commas into two items
        content_formatted.append(tuple([a.replace("'", "") for a in item.split(",")]))

    content_formatted = [x if len(x) > 1 else x[0] for x in content_formatted]
    return content_formatted

print(extract_data_from_file('data.csv'))
for i in extract_data_from_file('data.csv'):
    if len(i) > 2:
        print(i, '\n', len(i))

# exit()
my_params = {'data': extract_data_from_file('data.csv')}

with open('template.sql') as f:
    sql = f.read()

rendered_sql = Template(sql).render(data=my_params['data'])

with open('WIP_jinja_' + today_date + '.sql', 'w') as f:
    f.write(rendered_sql)
    # TODO change extension to sql.j2
