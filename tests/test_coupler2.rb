
require 'coupler2'
require 'test_sl'
require 'test/unit'

include TestSL
class TestCoupler2 < Test::Unit::TestCase
	#include TestCoupler
	class CoupleMe
		extend Coupler2
		def couple (test)
			self.class.couple(test)
		end
		def couple2
			return couple('TestCoupler2::TestCoupleable').new #i'm finding mixins quite awkward.
		end
	end

	class CoupleMe2 < CoupleMe
		extend Coupler2
	end
	class CoupleMe3
		extend Coupler2
		def seven; 7; end
	end

	TestCoupleable = test_group (:TestCouplable){
		test (:couplable){
			x = *args
			raise "#{x} doesn't have couple()" unless x.responds_to? :couple
		}
	}
	
	def test_couplex
		c = CoupleMe
		threw = false
		begin
			c.couple(:TestCoupleable)
		rescue RuntimeError => e
			threw = true
		end
		assert threw
		c.couplex(:'TestCoupler2::TestCoupleable',:'TestCoupler2::CoupleMe') #in this case, TestCoupleable is in this class, so ruby already knows about it.
		assert_equal 'TestCoupler2::CoupleMe',c.couple(:'TestCoupler2::TestCoupleable').name
	end
	
	def test_couplex2 
		CoupleMe.couplex('TestCoupler2::TestCoupleable','TestCoupler2::CoupleMe2')
		
		c2 = CoupleMe.new.couple2
		assert c2.is_a? CoupleMe2
	end

	def test_couplex_on_instance
		self.class.send(:include,Coupler2)
		#self.class.class_eval {include Coupler}

		couplex('TestCoupler2::TestCoupleable','TestCoupler2::CoupleMe'){
			#couplex(TestCoupleable,CoupleMe3) #i'm gonna skip local configuration till later. until i find an honest need for it.
			#self should be CoupleMe.class
		}

		c = couple("TestCoupler2::TestCoupleable")

		CoupleMe.couplex("TestCoupler2::TestCoupleable","TestCoupler2::CoupleMe2")
		c2 = CoupleMe.couple("TestCoupler2::TestCoupleable")

	end
	
	#okay	now test defaults
	Test7 = test_group (:seven){
		test (:the_number_7){
			x = *args
			raise "#{x} must be x" unless x == 7 or x == Seven
		}
	}
	class Seven 
		extend Coupler
		def seven; couple(Test7); end
	end
	def test_defaults
	self.class.send(:include,Coupler2)
		#disable library singleton for testing?
		couplex("TestCoupler2::Test7","TestCoupler2::Seven")
		couplex("TestCoupler2::TestCoupleable","TestCoupler2::CoupleMe")
		assert_equal Seven, couple("TestCoupler2::Test7")
		assert_equal CoupleMe, couple("TestCoupler2::TestCoupleable")
		couplex(Test7,Seven){
			couplex(Test7,7)
		}
		assert_equal Seven, couple("TestCoupler2::Test7")
		assert_equal CoupleMe, couple("TestCoupler2::TestCoupleable")
	end

	def test_defaults_by_symbol
	self.class.send(:include,Coupler2)
		couplex(:'TestCoupler2::Test7',:'TestCoupler2::Seven')
		CoupleMe.couplex('TestCoupler2::TestCoupleable','TestCoupler2::CoupleMe')
		@parent = (CoupleMe)
		
		assert_equal Seven, couple(:'TestCoupler2::Test7')
		assert_equal CoupleMe, couple(:'TestCoupler2::TestCoupleable')

		assert_equal Seven, couple(:'TestCoupler2::Test7')
		assert_equal CoupleMe, couple(:'TestCoupler2::TestCoupleable')

	end

	
	def test_couple_by_symbol
	self.class.send(:include,Coupler2)
		couplex('TestCoupler2::Test7',Seven)
		couplex('TestCoupler2::TestCoupleable',CoupleMe)

		assert_equal Seven,couple('TestCoupler2::Test7')
		assert_equal CoupleMe,couple(:'TestCoupler2::TestCoupleable')
	end
	
	def test_depencency
	self.class.send(:include,Coupler2)
		  depends(:Dependancy1,'tests/examples/dependancy1.rb')
		couplex('Test7',Seven)
	end
	
end
	

