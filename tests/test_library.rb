
require 'coupler'
require 'library'
require 'test/unit'

#include TestSL
class TestLibrary < Test::Unit::TestCase
include TestSL

	def test_submit
		l = Library.new
		l.submit_test g = test_group(:array){
			test(:a){
				klass = *args
				x = klass.new
				x << :hi
				raise "doesn't respond to []" unless x[0] == :hi
				raise "length isn't right" unless x.length == 1
			}
		}
		l.submit a = Array
		assert l.tests.include?(g),"library lost a test"
		assert l.objects.include?(a),"library lost an object"
		
		assert g.run_safe(a)
		
		assert_equal a,l.couple(g)
		l.submit b = Class.new(Array)
		assert_equal a,l.couple(g)
		assert_equal [a,b],l.passes(g)
	end
	def test_submit_with_symbol
	g = test_group(:test_for_true){
		test(:test_true){
			args.first == TrueClass
		}
	}
	TestLibrary.const_set(:GTest, g)

		l = Library.new
		l.submit_test g
		l.submit TrueClass
		assert l.tests.include? (GTest)
		assert l.couple(g)
		assert l.couple(GTest)
		assert l.couple(:'TestLibrary::GTest')
	end
	include Coupler
	def test_singleton
		assert Library.library
		assert Library.library.is_a? Library
		l = Library.library
		l.submit_test g = test_group(:array){
			test(:a){
				klass = *args
				x = klass.new
				x << :hi
				raise "doesn't respond to []" unless x[0] == :hi
				raise "length isn't right" unless x.length == 1
			}
		}
		l.submit a = Array
		#assert_equal l,self.__parent 
		assert_equal Array,couple(g)
	end
	
	def test_submit_requires
		l = Library.new
		l.submit_require 'tests/examples/test_require',:TestRequire,:Require
		assert_equal 	:Require.to_s, l.couple(:TestRequire).name
	
	end
end



