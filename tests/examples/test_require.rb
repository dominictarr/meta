
require 'test_sl'

class Require; end
include TestSL
TestRequire = test_group(:TestRequire){
	test(:is_a_require){
		args.first == Require
	}
}
