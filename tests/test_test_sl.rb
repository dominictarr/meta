require 'test_sl'
require 'test/unit'

	include TestSL
class TestTestSL < Test::Unit::TestCase

	def test_a_test
		x = false	
		t = ATest.new.name(:NAME).block {
			x = true
			s = *args
			#puts arg
			raise "name not equal" unless :NAME == name
			raise "self.is_a? ATest" unless self.is_a? ATest
			raise "s == 7, was #{s.inspect}" unless 7 == s
		}
		assert !x
		assert t.run_safe(7)
		assert x, "check that block was executed"
		x = false
		threw = false
		begin 
			t.run(-7)
		rescue Exception => e
			assert x
			threw = true
		end
		assert threw,"expected test to throw exception"
	end

	class GroupExample1
		def one; 1; end
		def two; 2; end
	end
	class GroupExample2
		def one; -1; end
		def two; -2; end
	end

	def assert_exception (message=nil,*exceptions,&block)
			exceptions = exceptions.empty? ? [Exception] : exceptions 
			message = message || "expected block to throw expection: #{exceptions.join (",")}"

		pass = true
		begin
			block.call
			pass = false
		rescue Exception => e
			exp = exceptions.find{|x| e.is_a? x}
			raise "expected exception one of: #{exceptions.inspect}, but got: #{e}\n#{e.backtrace.join("\n")}" if (exp.nil?)
		end

		assert pass, message
	end

	def test_test_group
		x_2 = x_1 = nil
		t1 = t2 = nil
		group = test_group (:tests){
				t1 = test(:one) {
				x_1 = true
				g = args.first.new
				raise "expected 1!" unless g.one == 1
			}
			t2 = test (:two) {
				x_2 = true
				g = args.first.new
				raise "expected 2!" unless g.two == 2
			}
		}
		assert_equal 2,group.tests.length
		assert t1, "expected a test 1"	
		assert t2, "expected a test 1"	
		assert t1.is_a?(ATest), "expected a test 1"	
		assert t2.is_a?(ATest), "expected a test 1"	
	
		group.run(GroupExample1)
	
		assert x_1, "expected blocks to get caled after run_tests"
		assert x_2, "expected blocks to get caled after run_tests"

		assert_exception (nil,RuntimeError) {group.run(GroupExample2)}
		puts "<<RUN TESTS START"
			assert group.run_safe(GroupExample1)
			assert !group.run_safe(GroupExample2)
		puts "RUN TESTS END>>"
	end
	def test_tests
		g = test_group(:name){
			
		}
		
		assert g.tests.is_a?(Array),"EXPECTED 	Array"
		assert g.tests.is_a?(TestArray),"EXPECTED 	TestArray"
		
	end	
	
	def test_test_inheritence
		g1 = test_group(:a){
			test (:one){}
		}
		g2 = test_group(:a){
			test (:two){}
		}
		g3 = test_group(:a){
			also(g1.tests)
			also(g2.tests)
			test (:three){}
		}
		assert_equal 1,g1.tests.length
		assert_equal 1,g2.tests.length
		assert_equal 3,g3.tests.length

		assert_equal 2,g3.tests.without(:two).length
		assert_equal 2,g3.tests.with(:one,:two).length
	end
	#now, i want test inheritence.
end

