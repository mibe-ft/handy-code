#!/usr/bin/env python
# coding: utf-8

from jinja2 import Template

def create_tuples_from_txt_file(file):
    with open(file) as f:
        content = f.read().splitlines()  # read in lines without \n (newline character)

    content_formatted = []
    for item in content:
        # remove apostrophes and split by commas into two items
        content_formatted.append(tuple([a.replace("'", "") for a in item.split(",")]))

    content_formatted = [x if len(x) > 1 else x[0] for x in content_formatted]
    return content_formatted

with open('template.sql') as f:
    sql = f.read()

rendered_sql = Template(sql).render(stage_names=create_tuples_from_txt_file('01_stage_name.txt')
                                    , stage_numbers=create_tuples_from_txt_file('02_stage_number.txt')
                                    , leadsource_types=create_tuples_from_txt_file('03_adjusted_lead_source.txt')
                                    , stage_name_2=create_tuples_from_txt_file('04_stage_name_2.txt')
                                    , stage_name_3=create_tuples_from_txt_file('04_stage_name_2.txt')[:-2])

with open('WIP_jinja.sql', 'w') as f:
    f.write(rendered_sql)
    # TODO change extension to sql.j2





