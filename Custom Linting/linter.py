
import sys
import glob

from lint_rule_final_classes import LintRuleFinalClasses

class Attributes:
	def __init__(self):
		self.file_attributes = []
		self.line_attributes = []

	def contains_file_attribute(self, attribute):
		return attribute in self.file_attributes

	def contains_line_attribute(self, attribute):
		return attribute in self.line_attributes

	def contains_attribute(self, attribute):
		return self.contains_line_attribute(attribute) or self.contains_file_attribute(attribute)

	def start_new_line(self):
		self.line_attributes.clear()

	def parseAttribute(self, line_content):
		text = line_content # // @SomeAttribute
		text = text.strip() # // @SomeAttribute
		if text.startswith("//"):
			text = text[2:]
		else:
			return False

		text = text.lstrip()
		if text.startswith("@") and len(text) > 1 and text.find(' ') == -1:
			text = text[1:]
			self.line_attributes.append(text)
			if not text in self.file_attributes:
				self.file_attributes.append(text)
			return True
		else:
			return False

def line_contains_non_final_class(content, attributes):

	if attributes.contains_line_attribute("NonFinal"):
		return False

	class_pos = content.find("class ")
	if class_pos == -1:
		return False

	length = len(content)
	if content[length-1] != "{":
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

def emitWarning(file, line, message):
	print(file + ":" + str(line) + ": warning: " + message)
	#echo "/foo/bar/tmp.sh:42: error: This is the error message"

class LintWarning:
	def __init__(self, line, message):
	    self.line = line
	    self.message = message

class Linter:

	def __init__(self):
		self.rules = []

	def add_rule(self, rule):
		self.rules.append(rule)

	def warnings_for_file(self, file_contents):
		
		lines = file_contents.splitlines()
		attributes = Attributes()
		lint_warnings = []

		for lineNumber, content in enumerate(lines):

			if attributes.parseAttribute(content) == True:
				continue

			for rule in self.rules:
				if rule.matches(content, attributes):
					warning = LintWarning(lineNumber, rule.message())
					lint_warnings.append(warning)

			attributes.start_new_line()

		return lint_warnings
