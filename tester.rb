require 'yaml'
require 'quick_attr'
 require 'rubygems'
# require 'open4'
# require 'modules/stdout_catcher'
require 'modules/sandbox'


class Tester 
	extend QuickAttr	
	quick_attr :test,:klass
	quick_array :requires

	def run()
		 unless requires.empty? then
			requires.each {|r| 
				require r
			}
		end
		t = eval test.to_s
		k = eval klass.to_s
		t.run_safe(k)
	end
	
	def yaml_instruction (yaml)
		map = YAML::load(yaml)
		test map[:test]
		klass map[:klass]
		requires *map[:require] if map[:require]
		self
	end
	
	def run_sandboxed 
	
		sb = Sandbox.new
		sb.code ""
		requires.each{|r|
			sb.code << "require \"#{r}\"\n"
		}
		sb.code << "#{test}.run_safe(#{klass})\n"
		{:result => sb.run}

	end
end
