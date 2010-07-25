require 'quick_attr'
require 'test/unit'

class TestQuickAttr < Test::Unit::TestCase 
include Test::Unit

class Hello
	extend QuickAttr
	#include QuickAttr
end

def test_simple
	Hello.quick_attr :one,:two,:three
	
	h = Hello.new.one("A").two("B").three("C")
	assert_equal "A", h.one
	assert_equal "B", h.two
	assert_equal "C", h.three

	assert_equal -1,h.method(:one).arity
	assert_equal -1,h.method(:two).arity
	assert_equal -1,h.method(:three).arity
end
	

def test_simple2
	Hello.quick_attr :one,:two,:three
	h = Hello.new.one(100).two(200).three(300)
	assert_equal 100, h.one
	assert_equal 200, h.two
	assert_equal 300, h.three

	assert_equal -1,h.method(:one).arity
	assert_equal -1,h.method(:two).arity
	assert_equal -1,h.method(:three).arity
end

def test_nil_or_empty
	Hello.quick_attr :_nil,:_empty,:_false
	h = Hello.new._nil(nil)._empty("")._false(false)
	assert_equal nil, h._nil
	assert_equal "", h._empty
	assert_equal false, h._false

	assert_equal -1,h.method(:_nil).arity
	assert_equal -1,h.method(:_empty).arity
	assert_equal -1,h.method(:_false).arity
end

def test_arrays
	Hello.quick_attr :one,:two,:three
	h = Hello.new.one([]).two(1,2,3,4,5).three(nil)

	assert_equal [], h.one
	assert_equal [1,2,3,4,5], h.two
	assert_equal nil, h.three
end

def test_proc
	Hello.quick_attr :one,:two
	h = Hello.new.one{true}.two(proc {3})
	assert_equal true, h.one.call
	assert_equal 3, h.two.call
	begin
		h.one ("args") {"fashl"}
		fail "set either a block or a value... not both"
	rescue; end
end

def test_class_space
	Hello.quick_attr :one,:two
	h = Hello.new.one(100).two(200)
	puts h.instance_eval( "one + two")
	assert_equal 300, h.instance_eval( "one + two")
		
end

class Hello2
	extend QuickAttr
	quick_attr :one,:two
	quick_array :several
	def three
		one + two
	end
end

def dont_test_class_space2

	h = Hello2.new.one(111).two(222)
	puts h.three
	assert_equal 333,h.three
	one = 10
	two = 10
	three = 10

	b = h.instance_eval("proc do one + two + three end")
	assert_equal 666, b.call
end

def test_quick_array
	h = Hello2.new.several(:a,:b)
	assert_equal [:a,:b],h.several
	h.several(:a)
	assert_equal [:a],h.several
end

def test_quick_array2
	h = Hello2.new
	h.several << :a
	h.several << :b

	assert_equal [:a,:b],h.several
	h.several(:a)
	assert_equal [:a],h.several
end

class NewArray < Array

end
class Hello3
	extend QuickAttr
	quick_attr :one,:two
	quick_array NewArray,:several
	def three
		one + two
	end
end

def test_quick_array_with_class
	h = Hello3.new
	h.several << :a
	h.several << :b

	assert_equal [:a,:b],h.several
	assert h.several.is_a?(NewArray), "Expected NewArray"
	h.several(:a)
	assert h.several.is_a?(NewArray), "Expected NewArray"
	assert_equal [:a],h.several
	assert h.several.is_a?(NewArray), "Expected NewArray"
end

end




