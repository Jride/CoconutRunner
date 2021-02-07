

import sys
import glob

from lint_rule import LintRule

class LintRuleFinalClasses(LintRule):

	def message(self):
		return "Classes should be final" 

	def matches(self, content, attributes):

		if attributes.contains_line_attribute("NonFinal"):
			return False

		class_pos = content.find("class ")
		if class_pos == -1:
			return False

		length = len(content)
		if content[-1] != "{":
			return False

		### Discount via prefix
		if content.find("final ", 0, class_pos) != -1 \
		or content.find("protocol ", 0, class_pos) != -1 \
		or content.find("@objc ", 0, class_pos) != -1 \
		or content.find("import ", 0, class_pos) != -1 \
		or content.find(" var ", 0, class_pos) != -1 \
		or content.find("\"", 0, class_pos) != -1 \
		or content.find("//", 0, class_pos) != -1:
			return False

		### Discount via suffix
		class_end = class_pos + len("class")
		if content.find(" func ", class_end) != -1 \
		or content.find(" var ", class_end) != -1:
			return False
		
		return True

