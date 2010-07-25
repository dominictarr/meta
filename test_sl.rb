require 'quick_attr'

module TestSL

	def test_group (name, &group)
		TestGroup.new.name(name).on(&group)
	end

	class TestArray < Array
		def with(*names)
			w = TestArray.new
			each{|e| w << e if names.include?(e.name)}
			w
		end
		def without(*names)
			w = TestArray.new
			each{|e| w << e unless names.include?(e.name)}
			w
		end
	end

	class TestGroup
		extend QuickAttr	
		quick_attr :name,:block
		quick_array TestArray,:tests
		
		def intialize 
			@tests = TestArray.new
		end
		def on(&test_block) #make a quick_dsl method to create these?
			instance_eval(&test_block)
			self
		end
		def also (s)
			s.each {|s|
				(tests.include? s) || tests << s
			}
		end
		def run_safe (sub)
			begin
				run(sub)
				true
			rescue Exception => e
				puts "test #{name} failed:"
				puts e.message
				false
			end
		end
		def run(sub)
			tests.find {|e|
				e.run(sub)
			}
		end
		def test(name,&block)
			tests << t = ATest.new.name(name).block(&block)
			t
		end
	end


	class ATest
		extend QuickAttr	

		quick_attr :name,:block
		quick_array :args

		def run (*sub_45792345) #throws exception
			args *sub_45792345
			instance_eval(&block)
		end

		def run_safe (sub)
			begin
				run(sub)
				true
			rescue Exception => e
				puts "test #{name} failed:"
				puts e.message
				false
			end
		end
	#	def on(&test_block)
	#		block(test_block)
	#	end
	end
end
