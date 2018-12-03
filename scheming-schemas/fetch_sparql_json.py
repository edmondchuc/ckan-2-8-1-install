import urllib.parse as uparse
import requests
import json
import sys
import pprint as pp

SPARQL_QUERY_PLAIN_TEXT = '''
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    SELECT * WHERE {
    ?s a skos:Concept ;
       skos:prefLabel ?pl .
    FILTER (lang(?pl) = "en")
}
'''

SPARQL_ENDPOINT = 'http://vocabs.ands.org.au/repository/api/sparql/ga_association-type_v1-2'
JSON_FORMAT_QSA = 'application/sparql-results+json'
params = {
    'query': SPARQL_QUERY_PLAIN_TEXT,
    'Accept': JSON_FORMAT_QSA
}


def get_content_from_endpoint(url, params):
    """
    Retrieve the content from a URL and return it.
    """
    r = requests.get(
        url,
        params=params
    )
    if r.status_code != 200:
        raise ConnectionError('The request to ' + url + ' received a status code of ' + str(r.status_code) + ' instead of a 200.')
    return r.content


def get_content_from_file(filename):
    """
    Retrieve the content from the supplied file name and return it.
    """
    data = None
    with open(filename, 'r') as f:
        try:
            data = json.load(f)
        except Exception as e: 
            print('Failed to load JSON while opening file ' + filename + '. Error: ' + str(e))
            sys.exit(1)
        f.close()
    return data


def write_to_file(filename, data):
    """
    Write/overwrite the data to a file. WARNING: Overwrites existing file if it exists.
    """
    # update by over-writing the existing schema file
    with open(filename, 'w') as f:
        f.write(json.dumps(data, indent=4, sort_keys=True))
        f.close()


content = get_content_from_endpoint(SPARQL_ENDPOINT, params)

items = json.loads(content)['results']['bindings']
choices = [] # load the subject URI and its prefLabel into this list as a dict object
for item in items:
    choices.append(
        {
            "value": item['s']['value'],
            "label": item['pl']['value']
        }
    )

# read in the current schema file
filename = 'test-schema.json'
# keys to match
field_name = 'category'
label = 'Category'
preset = 'select-link'

data = get_content_from_file(filename)

for i, field in enumerate(data['dataset_fields']):
    if field['field_name'] == field_name and field['label'] == label and field['preset'] == preset:
        ## found the field, now replace it with our new choices list
        data['dataset_fields'][i]['choices'] = choices
        # pp.pprint(data['dataset_fields'][i])
        break
    if i == len(data['dataset_fields'])-1:
        raise Exception('Did not find a matching select-link field in the JSON schema.')

write_to_file(filename, data)

print('Success!')