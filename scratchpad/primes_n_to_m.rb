#require 'library'
require 'coupler'
include Coupler
n = ARGV[0].to_i
m = ARGV[1].to_i

p = couple(:'Dmt10::SafeTests::TestPrimes').new(m).primes

puts p.select{|x| x >= n}.join(",")

