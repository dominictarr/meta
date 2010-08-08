require 'test/unit'

class TestLoadFalse < Test::Unit::TestCase

def false_f
	false
end
def test_load_false
	assert !false_f, "unloaded: should be false"
	puts load('scratchpad/load_true.rb',true)
	assert !false_f, "loaded & wrapped, shouldn't monkey patch: should be false"
	#assert Hello
	begin 
		Wrapper::Hello
		raise "expected NameError"
	rescue NameError
		
	end
end

def test_load_true
	assert !false_f, "unloaded: should be false"
	load 'scratchpad/load_true.rb',false
#	assert false_f, "not wrapped, should have monkeypatched"
#wrapped it in a module to protect classes from monkeypatching.
	assert Wrapper::Hello
end

end
