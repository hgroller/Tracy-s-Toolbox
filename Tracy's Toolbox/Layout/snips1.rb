require 'matrix'
########################################
#Get Odd/Even Vias
e =Array.new
o =Array.new
a   =*(0..883)
e  << a.values_at(* a.each_index.select {|i| i.even?})
o  << a.values_at(* a.each_index.select {|i| i.odd?})
fe  = e.flatten
fo =  o.flatten
ee =Array.new
oo =Array.new
fe.each_slice(13) { |row| puts  row.map{|e| e}}
fe.each_slice(13) { |row| ee <<  row.map{|e| e}}
fo.each_slice(13) { |row| oo <<  row.map{|e| e}}
# puts Even Array For Test
puts ee
puts ee[2][6]
########################################
def print_2D array
    array.each do |arr|
        arr.each do |item|
            print "#{item} "
        end
        print "\n"
    end
end

#a = [0,1,2,3,4,5,6]

def array_2d(bits, r)
  c = r.count
  (1..bits - 1).map { |i| r.shift((c + i) * 1.0 / bits ) } + [r]
end


#a   =*(0..883)
#35 is the number
#z = array_2d(22, fe)
#print_2D  z

#e.each do |test|
  #puts "Num Count is #{test}"
#end
#Parse Odd
#o.each do |test|
 # puts test
#end

cnt = 0
    while x <= cnt
             if x.even?
                  puts test.join(",")
             end
             x = x + 1
     end