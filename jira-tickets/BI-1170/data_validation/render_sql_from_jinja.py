from jinja2 import Template
from pathlib import Path
import csv
p = Path(__file__).parents[0]  # set folder directory

def extract_data_from_file(file):

    file = p.joinpath(file)
    # with open(file) as f:
    #     content = f.read().splitlines()[1:]  # read in lines without \n (newline character) and skip header line
    #
    content_formatted = []
    # for item in content:
    #     # remove apostrophes and split by commas into two items
    #     content_formatted.append(tuple([a.replace("'", "") for a in item.split('",')]))
    #
    # content_formatted = [x if len(x) > 1 else x[0] for x in content_formatted]

    with open(file, 'rt') as f:
        csv_reader = csv.reader(f, skipinitialspace=True)

        for line in csv_reader:
            # print(tuple(line))
            l = line #[x.replace(",", "") if n == 1 else x for n,x in enumerate(line)]
            l[1] = l[1].replace(",", "")
            l[4] = l[4].replace(",", "")
            l[12] = l[12].replace(",", "")
            l[14] = l[14].replace(",", "")
            l[20] = l[20].replace(",", "")
            l[23] = l[23].replace(",", "")
            content_formatted.append(tuple(l))
    return content_formatted[1:]

# x = extract_data_from_file('data.csv')
# for n,y in enumerate(x[0]):
#     print(n,y)
# exit()
my_params = {'test_data': extract_data_from_file('data.csv')}

with open(p.joinpath('template.sql')) as f:
    sql = f.read()

rendered_sql = Template(sql).render(test_data=my_params['test_data'])

with open(p.joinpath('WIP_jinja.sql'), 'w') as f:
    f.write(rendered_sql)
    # TODO change extension to sql.j2
