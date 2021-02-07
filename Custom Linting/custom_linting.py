import sys
import glob

from linter import Linter
from lint_rule_final_classes import LintRuleFinalClasses

def emitWarning(file, line, message):
	# Xcode line indexes are 1 based, not 0 based
	print(file + ":" + str(line+1) + ": warning: " + message)
	#echo "/foo/bar/tmp.sh:42: error: This is the error message"

###### MAIN ######

# First argument: Project directory
root = sys.argv[1]

# Second argument: Search path
search_path = sys.argv[2]

for file_path in glob.glob(search_path + '/**/*.swift', recursive = True):

	with open(file_path, 'r') as file:

		linter = Linter()
		linter.add_rule(LintRuleFinalClasses())

		warnings = linter.warnings_for_file(file.read())

		for warning in warnings:
			relative_path = file_path[len(root)+1:]
			emitWarning(relative_path, warning.line, warning.message)

