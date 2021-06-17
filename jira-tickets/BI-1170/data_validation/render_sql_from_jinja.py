from jinja2 import Template
from pathlib import Path
import csv
import datetime as dt

p = Path(__file__).parents[0]  # set folder directory
today_date = dt.datetime.today().strftime('%Y_%m_%d_%H%M%S')


def extract_data_from_file(file):

    file = p.joinpath(file)
    content_formatted = []

    with open(file, 'rt') as f:
        csv_reader = csv.reader(f, skipinitialspace=True)

        for line in csv_reader:
            l = line
            l[1] = l[1].replace(",", "")
            l[4] = l[4].replace(",", "")
            l[12] = l[12].replace(",", "")
            l[14] = l[14].replace(",", "")
            l[20] = l[20].replace(",", "")
            l[23] = l[23].replace(",", "")
            content_formatted.append(tuple(l))
    return content_formatted[1:]


my_params = {'test_data': extract_data_from_file('data.csv')}

with open(p.joinpath('template.sql')) as f:
    sql = f.read()

rendered_sql = Template(sql).render(test_data=my_params['test_data'])

with open(p.joinpath('WIP_jinja_' + today_date + '.sql'), 'w') as f:
    f.write(rendered_sql)
    # TODO change extension to sql.j2
