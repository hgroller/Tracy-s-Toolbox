##############################################
#Written Tracy Groller
#Date :2/19/21
#Via Processer create Xn Matrix of Odd/Even Vias
##############################################
e =Array.new
o =Array.new
#Build Array Based on number of Vias

#Get Odd/Even  Values from count of Vias
e  << a.values_at(* a.each_index.select {|i| i.even?})
o  << a.values_at(* a.each_index.select {|i| i.odd?})
#Flatten array to get Odd/Even Values
fe  = e.flatten
fo =  o.flatten
#New Array to Store Odd/Even
ee =Array.new
oo =Array.new
# puts Slice into 13xN array based on number of rows
fe.each_slice(13) { |row| ee << row.map{|e| e}}
fo.each_slice(13) { |row| oo << row.map{|e| e}}
##############################################
# Test Array Build for Via
#get Value ee[0][0]
##############################################
cnt =  ee.length()
x = 0
ee.each do |via|
   if x.even?
        puts via.join(",")
        (0..ee[x].length).each  do |en|
             xn = ee[x][en]
             puts  xn
         end
      end
       x += 1
end




#if we're code golfing :)
##################################################

#shape_array = []    # will become and array of Shape objects
#shapes = ...        # a Shapes object
#shapes.each { |s| shape_array << s }
#set_shortcut("@toolbar.select", "S")
#mw.menu.action("edit_menu.select_menu.unselect_all").trigger
#source.shapes(sel.layer).erase(shape)
#test_box = pya.Box(x - 1, y - 1, x + 1 y + 1)
#iter = pya.RecursiveShapeIterator.new(ly, cell, layer_index, test_box, True)
#test_box = Box.new(x1 - 1, y1 - 1, x2 + 1 y2 + 1)
#iter = RBA::RecursiveShapeIterator::new(ly, cell, layer_index,test_box, True)


##################################################
# delivers all primitives:
#shapes.each(RBA::Shapes::SAll) { |s| ... }
# delivers all primitives which have user properties attached:
#shapes.each(RBA::Shapes::SAllWithProperties) { |s| ... }
# delivers only texts:
#shapes.each(RBA::Shapes::STexts) { |s| ... }
# delivers only polygons and boxes:
#shapes.each(RBA::Shapes::SBoxes | RBA::Shapes::SPolygons) { |s| ... }




