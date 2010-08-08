require 'quick_attr'
require 'coupler'
require 'test_sl'
require 'yaml'
require 'set'

class Library 
	extend QuickAttr
	include Coupler
	quick_array :tests,:objects
	#files 
	def __wrapped__
		nil
		#coupler expects things to have __wrapped__
		#@library ||= Library.new
	end
	def load
		if @file then
			requires = YAML::load(@file.read)
			if requires then
			puts "LOAD LOCAL LIBRARY:#{@file.path}"
			puts requires.inspect
			
				requires.each {|req,items|
					submit_require(req,*items)
				} 
			end
		test_all_classes
		end
	end
	def save
		if @file then
			puts @requires.to_yaml
			File.open(@file.path,'w').write @requires.to_yaml
		end
	end
	def initialize (file = nil)
		@file = file
		load
	end
	def self.library
		fn = './local_library.yaml'
		f = File.exist?(fn) ?  File.open(fn) : File.new(fn,'w')
		@library ||= Library.new(f)
	end

	#def to_class

	def to_class (sym)
		eval sym.to_s
	end

	def submit_symbol(*items)
		items.each{|i|
			k = to_class(i)
			if k.is_a? Class then
				submit(k)
			elsif k.is_a? TestSL::TestGroup then
				submit_test(k)
			end
		}
	end
	def test_all_classes
		ObjectSpace.each_object(Module) {|m|
			puts m
			submit(m)
		}
	end
	def submit_require(required,*items)
		@requires ||={}
		@requires[required] ||=[]
		
		@requires[required]
		require required
		items.each{|e| (@requires[required].include? e) ? nil : (@requires[required] << e)}
		submit_symbol(*items)
	end
	def submit_test(*test)
		#tests << test
		test.each{|e| tests << e; run_test(e)}
	end
	def submit(*to_test)
		#objects << to_test #you can submit any thing at all... if there is a test for it, it must be important
		to_test.each{|e| objects << e; test_object(e)}
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
	def report 
		puts "==============================="
		tests.each{|t|
			puts "	Test:#{t.name}"
			passes(t).each{|p|
				puts "		#{p}"	
			}
		}
		puts "==============================="
					
	end
	def passes(test)
		@passes||={}
		@passes[test]||=Set[]
	end
	def test_object(object)
	#step through every object and try it through test.
		tests.each{|t|
#			puts "======================"
			puts "test object: #{object}"
			if run(t,object) then
				puts "	PASSED : #{t}"
			else
				puts "	failed : #{t}"
			end
			puts
#			puts "======================"
		}
	end
end
