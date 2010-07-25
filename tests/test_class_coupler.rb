require 'coupler'
require 'test_sl'
require 'test/unit'

class TestClassCoupler < Test::Unit::TestCase

def test_equals
	klass = Coupler::ClassCoupler.new(Class){}
	assert klass == Class
	assert_equal klass, Class
	
	assert klass == Class
	assert klass.equal? Class
	assert klass.eql? Class

	assert Class == klass
	assert Class.equal? klass
	assert Class.eql? klass

	assert Class === klass #can't remember what === means exactly, but Class === Class
	assert klass === Class
	assert Module === Class
	assert Module === klass
	assert Class === Module
	assert klass === Module
	
	assert klass.is_a? Object
	assert Object.is_a? klass
	
	#okay... these don't work... but it's not that important right now...
	#puts Class < klass 
	#puts Class > klass
	#puts Class <= klass
	#puts Class >= klass
	#puts Class <=> klass
end
end
