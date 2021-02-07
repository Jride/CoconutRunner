

import sys
import glob

class LintRule:

	def message(self):
		return "Base lint rule message" 

	def matches(self, content, attributes):
		return False
