 require "test_sl"
 require "modules/primes"

#  	include TestSL
  	extend TestSL

 	TestPrimes = test_group(:primes){
 
#	def create (*a,&block) 
#		args.first.new(*a,&block)
#	end

#	def initialize (x,klass = Primes )
#	@pclass = klass;
#	super(x)
#		puts "TESTPRIMES INITED :" + pclass.to_s
#	end
	
	#~ def initialize (s)
		#~ @pclass  = Primes
	#~ end

#	def pclass 
#		@pclass
#		end
 
	test(:primesMethod){
		c = create(1)
		assert_not_nil(c.methods.find('primes'))
	}


	test (:test_under0) { 
		assert_underN(0,[])
		}

	test (:test_under2) { 
		assert_underN(2,[2])
		}
	test (:test_under10){
		assert_underN(10,[2,3,5,7])
	}
	test( :test_under20){
		assert_underN(20,[2,3,5,7,11,13,17,19])
	}
}
#if __FILE__ == $0 then
#	require 'modules/primes'
#	require 'modules/smart_primes'
#	require 'modules/too_clever_primes'
#	require 'modules/broke_primes'
#	require 'library'

#	Library.library.submit(Primes,SmartPrimes, TooCleverPrimes,BrokePrimes)

#	Library.library.submit_test(SafeTest::TestPrimes)
#	Library.library.report

#end

