import unittest
from linter import Linter
from lint_rule_final_classes import LintRuleFinalClasses

class TestCustomLinter(unittest.TestCase):

	def makeSUT(self):
		linter = Linter()
		linter.add_rule(LintRuleFinalClasses())
		return linter

	def test_linter(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file("")
		self.assertEqual(len(warnings), 0, "Empty file should have 0 warnings")

	def test_non_final_class(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" let someGlobal = 5

        		class MyClass {
        			let property = 5
        		}
			"""
        	)

		self.assertEqual(len(warnings), 1)
		self.assertEqual(warnings[0].line, 2)
		self.assertEqual(warnings[0].message, "Classes should be final")

	def test_final_class(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" let someGlobal = 5

        		final class MyClass {
        			let property = 5
        		}
			"""
        	)

		self.assertEqual(len(warnings), 0)

	def test_class_protocol(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" let someGlobal = 5

        		protocol MyProtocol: class {
        			var property: { get }
        		}
			"""
        	)
		self.assertEqual(len(warnings), 0)

	def test_class_variable_var(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" 
				class var someVariable: Int {
					return 5
				}
			"""
        	)
		self.assertEqual(len(warnings), 0)

	def test_class_variable_let(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" 
				class let someVariable: Int = 5
			"""
        	)
		self.assertEqual(len(warnings), 0)

	def test_commented_out_class(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" 
				//class MyClass {
        		//	let property = 5
        		//}
			"""
        	)
		self.assertEqual(len(warnings), 0)

	def test_class_in_string(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" 
				print("This string contains the word class")
			"""
        	)
		self.assertEqual(len(warnings), 0)

	def test_class_non_final_attribute(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" 
				// @NonFinal
				class MyClass {
        			let property = 5
        		}
			"""
        	)
		self.assertEqual(len(warnings), 0)

	def test_non_final_attribute_only_affects_first_class(self):
		linter = self.makeSUT()
		warnings = linter.warnings_for_file(
			""" 
				// @NonFinal
				class MyClassOne {
        			let property = 5
        		}

        		class MyClassTwo {
        			let property = 5
        		}
			"""
        	)
		self.assertEqual(len(warnings), 1)
		self.assertEqual(warnings[0].line, 6)
		self.assertEqual(warnings[0].message, "Classes should be final")

if __name__ == '__main__':
	unittest.main()
