# This PegLite test shows an address grammar parsing a street address.
# We parse it 3 different ways, to get different desired results.


from package.unittest import *
from peglite import *
import yaml
import sys

# A sample street address
address = """\
John Doe
123 Main St
Los Angeles, CA 90009
"""

# Expected result tree for default/plain parsing
parse_plain = """\
- John Doe
- 123 Main St
- - Los Angeles
  - CA
  - '90009'
"""

# Expected result tree using the 'wrap' option
parse_wrap = """\
address:
- - name:
    - John Doe
  - street:
    - 123 Main St
  - place:
    - - city:
        - Los Angeles
      - state:
        - CA
      - zip:
        - '90009'
"""

# Expected result tree from our Custom parser extension
parse_custom = """\
name: John Doe
street: 123 Main St
city: Los Angeles
state: CA
zipcode: '90008'
"""

# Run 3 tests
class TestAddressParser(TestCase):
    # Parse address to an array of arrays
    def test_plain(self):
        parser = AddressParser()
        result = parser.parse(address)
        self.assertEqual(yaml.dump(result), parse_plain, "Plain parse works")
    # Turn on 'wrap' to add rule name to each result
    def test_wrap(self):
        parser = AddressParser(wrap=True)
        result = parser.parse(address)
        self.assertEqual(yaml.dump(result), parse_wrap, "Wrapping parse works")
    # Return a custom AST
    def test_custom(self):
        parser = AddressParserCustom()
        result = parser.parse(address)
        self.assertEqual(yaml.dump(result), parse_custom, "Custom parse works")

# This class defines a complete address parser using PegLite
class AddressParser(PegLite):
    rule('address', 'name street place')
    rule('name',    r'/(.*?)/')
    rule('street',  r'/(.*?)\n/')
    rule('place',   'city COMMA _ state __ zip NL')
    rule('city',    r'/(\w+(?: \w+)?)/')
    rule('state',   r'/(WA|OR|CA)/')           # Left Coast Rulez
    rule('zip',     r'/(\d{5})/')

# Extend AddressParser
class AddressParserCustom(AddressParser):
    def address(self):
        got = match
        if not got:
            return
        name, street, place = got[0]
        city, state, zip = place
        # Make the final AST from the parts collected.
        self.got = {
            'name': name,
            'street': street,
            'city': city,
            'state': state,
            # Show as 'zipcode' instead of 'zip'
            'zipcode': zip,
        }
        return True

    # Subtract 1 from the zipcode for fun
    def zip(self):
        got = match
        if not got:
            return
        return (got[0].to_i - 1).to_s

if __name__ == '__main__':
    main()
