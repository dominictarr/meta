	require 'library'
	Library.library.instance_eval{
#	submit_require('modules/tests/test_primes',:TestPrimes)
#	submit_require('modules/primes',:Primes)
#	submit_require('modules/smart_primes',:SmartPrimes)
#	submit_require('modules/too_clever_primes',:TooCleverPrimes)
#	submit_require('modules/broke_primes',:BrokePrimes)
#	submit_require('modules/tests/test_primes',:TestPrimes)

	submit_require('modules/tests/test_primes',:'Dmt10::SafeTests::TestPrimes')
	submit_require('modules/primes')
	submit_require('modules/smart_primes')
	submit_require('modules/too_clever_primes')
	submit_require('modules/broke_primes')

#	submit_require('modules/tests/test_factors',:'Tests::TestFactors')
	submit_require('modules/factors')
	submit_require('modules/fast_factors')

	save
	report
	}

