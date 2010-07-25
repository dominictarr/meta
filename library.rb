require 'quick_attr'
require 'coupler'
require 'test_sl'

class Library 
	extend QuickAttr
	include Coupler
	quick_array :tests,:objects
	
	def self.library
		@library ||= Library.new
	end
	
	def submit_test(test)
		tests << test
		run_test(test)
	end
	def submit(to_test)
		objects << to_test #you can submit any thing at all... if there is a test for it, it must be important
		test_object(to_test)
	end
	def run(test,object)
			if test.run_safe(object) then
				couplex(test,object) if passes(test).empty?
				passes(test) << object
				true
			else
				false
			end
	end
	def run_test(test)
	#step through every object and try it through test.
		objects.each{|o|
			puts "======================"
			puts "run test: #{test.name}"
			puts
			puts "======================"
			if run(test,o) then
				puts "	PASS : #{o}"
			else
				puts "	fail : #{o}"
			end
		}
	end
	
	def passes(test)
		@passes||={}
		@passes[test]||=[]
	end
	def test_object(object)
	#step through every object and try it through test.
		tests.each{|t|
			puts "======================"
			puts "test object: #{object}"
			puts
			puts "======================"
			if run(t,object) then
				puts "	PASSED : #{t}"
			else
				puts "	failed : #{t}"
			end
		}
	end
	
		
end
