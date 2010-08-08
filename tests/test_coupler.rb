
require 'coupler'
require 'test_sl'
require 'test/unit'

include TestSL
class TestCoupler < Test::Unit::TestCase
	#include TestCoupler
	class CoupleMe
		extend Coupler
		def couple (test)
			self.class.couple(test)
		end
		def couple2
			return couple(TestCoupleable).new #i'm finding mixins quite awkward.
		end
	end

	class CoupleMe2 < CoupleMe
		extend Coupler
	end
	class CoupleMe3
		extend Coupler
		def seven; 7; end
	end

	TestCoupleable = test_group (:couplable){
		test (:couplable){
			x = *args
			raise "#{x} doesn't have couple()" unless x.responds_to? :couple
		}
	}
	
	def test_couplex
		c = CoupleMe
		threw = false
		begin
			c.couple(TestCoupleable)
		rescue RuntimeError => e
			threw = true
		end
		assert threw
		c.couplex(TestCoupleable,CoupleMe)
		assert_equal CoupleMe,c.couple(TestCoupleable)	
	end
	
	def test_couplex2 
		CoupleMe.couplex(TestCoupleable,CoupleMe2)
		
		c2 = CoupleMe.new.couple2
		assert c2.is_a? CoupleMe2
	end

	def test_couplex_on_instance
		self.class.send(:include,Coupler)
		#self.class.class_eval {include Coupler}

		couplex(TestCoupleable,CoupleMe){
			couplex(TestCoupleable,CoupleMe3)
			#self should be CoupleMe.class
		}

		c = couple(TestCoupleable)

		#puts
		#puts	"expected ClassCouple wrapping CoupleMe:"
		#puts c
		#puts c.object_id
		#puts CoupleMe.object_id
		#puts "equal?  #{c.equal? CoupleMe}"
		#puts "==  #{c == CoupleMe}"
		#puts "eql? #{c.eql? CoupleMe}"
		#assert_equal CoupleMe,c

		assert c.__wrapped__

		assert_equal c, CoupleMe, "want to fool ==" #there are a few tricks here. will have to redefine some == methods on Class.
		assert_equal CoupleMe,c, "want to fool ==" #there are a few tricks here. will have to redefine some == methods on Class.
		c3 = c.couple(TestCoupleable)
		assert_equal CoupleMe3,c3
		assert_equal c3,CoupleMe3
		assert CoupleMe3.equal?(c3)

			#now, I don't think this should change CoupleMe if it's a direct reference.
			#I should be able to say 
			#couple(TestCoupleable).couple(TestCoupleable)
			#(self -> CoupleMe) and (CoupleMe' -> CoupleMe3)
			#but then turn around and say
			#CoupleMe.couplex(TestCoupleable,CoupleMe2)

			#because there is two different contexts, 
			#the default CoupleMe, 
			#and the CoupleMe which self is using.

		CoupleMe.couplex(TestCoupleable,CoupleMe2)
		c2 = CoupleMe.couple(TestCoupleable)

		c_3 = couple(TestCoupleable).couple(TestCoupleable)
		assert_equal CoupleMe3, c_3
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
	self.class.send(:include,Coupler)
		couplex(Test7,Seven)
		couplex(TestCoupleable,CoupleMe)
		assert_equal Seven, couple(Test7)
		assert_equal CoupleMe, couple(TestCoupleable)
		couplex(Test7,Seven){
			couplex(Test7,7)
		}
		assert_equal Seven, couple(Test7)
		assert_equal CoupleMe, couple(TestCoupleable)
		assert_equal 7, couple(Test7).couple(Test7)

		#okay, now self has a couplex for TestCoupleable
		#but Seven doesn't. it should default to what Seven uses
		#because it's it's parent
		assert couple(Test7).__parent
		#puts "PARENT"
		#puts couple(Test7).__parent
		#assert !couple(CoupleMe).__parent

		assert_equal CoupleMe, couple(Test7).couple(TestCoupleable)
		assert_equal Seven, couple(TestCoupleable).couple(Test7)
		assert_equal 7, couple(TestCoupleable).couple(Test7).couple(Test7)
		assert_equal CoupleMe, couple(TestCoupleable).couple(TestCoupleable).couple(Test7).couple(TestCoupleable)

		#now i'm ready to make the test library.		
	end

	def test_defaults_by_symbol
	self.class.send(:include,Coupler)
		couplex(Test7,Seven)
		couplex(TestCoupleable,CoupleMe)
		assert_equal Seven, couple(:'TestCoupler::Test7')
		assert_equal CoupleMe, couple(:'TestCoupler::TestCoupleable')
		couplex(Test7,Seven){
			couplex(Test7,7)
		}
		assert_equal Seven, couple(:'TestCoupler::Test7')
		assert_equal CoupleMe, couple(:'TestCoupler::TestCoupleable')
		assert_equal 7, couple(:'TestCoupler::Test7').couple(:'TestCoupler::Test7')

		#okay, now self has a couplex for TestCoupleable
		#but Seven doesn't. it should default to what Seven uses
		#because it's it's parent
		assert couple(:'TestCoupler::Test7').__parent
		#puts "PARENT"
		#puts couple(Test7).__parent
		#assert !couple(CoupleMe).__parent

		assert_equal CoupleMe, couple(:'TestCoupler::Test7').couple(:'TestCoupler::TestCoupleable')
		assert_equal Seven, couple(:'TestCoupler::TestCoupleable').couple(:'TestCoupler::Test7')
		assert_equal 7, couple(:'TestCoupler::TestCoupleable').couple(:'TestCoupler::Test7').couple(:'TestCoupler::Test7')
		assert_equal CoupleMe, couple(:'TestCoupler::TestCoupleable').
										couple(:'TestCoupler::TestCoupleable').
										couple(:'TestCoupler::Test7').
										couple(:'TestCoupler::TestCoupleable')

		#now i'm ready to make the test library.		
	end

	
	def test_couple_by_symbol
	self.class.send(:include,Coupler)
		couplex(Test7,Seven)
		couplex(TestCoupleable,CoupleMe)

		assert_equal Seven,couple(:'TestCoupler::Test7')
		assert_equal CoupleMe,couple(:'TestCoupler::TestCoupleable')
	end
	
end
	

