from csv import DictReader
import json
# open file in read mode
with open('table_columns.csv', 'r') as read_obj:
    # pass the file object to DictReader() to get the DictReader object
    dict_reader = DictReader(read_obj)
    # get a list of dictionaries from dct_reader
    list_of_dict = list(dict_reader)
    # print list of dict i.e. rows
    print(json.dumps(list_of_dict, indent=4))

with open('table_schema.json', 'w') as f:
    json.dump(list_of_dict,f, indent=4)