"""\
PegLite - Simple PEG Parser
"""

__version__ = '0.0.1'

import yaml
import traceback
import sys

def XXX(*args):
    print yaml.dump(args)
    sys.exit(0)

def rule(name, rule):
    def func(self):
        print rule
    setattr(PegLite, "rule_%s" % name, func)

class PegLite:
    def __init__(self, wrap=False):
        self.wrap = wrap

    def parse(self, input_):
        return input_
