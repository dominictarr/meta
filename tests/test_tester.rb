require 'test/unit'
require 'test_sl'
require 'tester'
require 'yaml'

class TestTester < Test::Unit::TestCase 
extend TestSL

	Test = test_group(:Test){
		test(:is_String){
			raise "Expected String" unless args.first == String
		}
	}

	def test_test_run
		
		report = Tester.new.test(:'TestTester::Test').klass(:String).run		
		assert report
		report = Tester.new.test(:'TestTester::Test').klass(:Integer).run		
		assert !report
	end
	
	def test_run_instruction_require
		report = Tester.new.test(:'TestPrimes').
					klass(:Primes).
					requires('modules/tests/test_primes.rb','modules/primes.rb').
					run_sandboxed
		
		assert report[:result]

		report = Tester.new.test(:'TestPrimes').
					klass(:BrokePrimes).
					requires('modules/tests/test_primes.rb','modules/broke_primes.rb').
					run_sandboxed
		
		assert !report[:result]

		report = Tester.new.test(:'TestPrimes').
					klass(:SmartPrimes).
					requires('modules/tests/test_primes.rb','modules/smart_primes.rb').
					run_sandboxed
			
		assert report[:result]
		begin 
			eval "SmartPrimes"
			assert false, "expected a NameError"
		rescue NameError => n		
		end
		
		report = Tester.new.test(:'TestPrimes').
					klass(:TooCleverPrimes).
					requires('modules/tests/test_primes.rb','modules/too_clever_primes.rb').run_sandboxed
			
		assert report[:result]
		begin 
			eval "TooCleverPrimes"
			assert false, "expected a NameError"
		rescue NameError => n		
		end

		report = Tester.new.test(:'TestPrimes').
					klass(:BrokePrimes).
			 		requires('modules/tests/test_primes.rb','modules/broke_primes.rb').run_sandboxed
			
		assert !report[:result]

	end
end
