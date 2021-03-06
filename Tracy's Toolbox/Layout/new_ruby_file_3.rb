#process Vias based on supply
# Enter your Ruby code here
include RBA
require 'matrix'
app   = RBA::Application.instance
mw   = app.main_window
view  = mw.current_view
cv      = view.cellview(view.active_cellview_index)
dbu    = ly.dbu 
cl       = view.active_cellview.cell
cv      = RBA::CellView::active
lay     =  view.active_cellview.layout
cell    = cv.cell

layer_info = LayerInfo.new(10,0)
layer_index = lay.layer(layer_info)

#Build Corrdinate Array Class
def set(var)
  x = 0
  eval('x=var;')
end

class Coordinate
      attr_reader :x1, :y1, :x2, :y2

  def to_s
        "(#{x1},#{y1},#{x2},#{y2})"
  end

  def initialize(x1,y1,x2,y2)
        @x1 = x1
        @y1 = y1
        @x2 = x2
        @y2 = y2
  end

  def <=>(other)
       [x1, y1] <=> [other.x1, other.y1]
  end

end

def process_vias

	if view == nil
		raise "Process Vias: No view selected"
	end

	view.transaction( "Process Vias" )

	layer_info = LayerInfo.new(10,0)
	layer_index = lay.layer(layer_info)
	coords = Array.new

	cell.each_shape(layer_index) do |shape|
		if shape.is_box?
			#Convert polygon to Box
			box =  shape.box
			coords.push(box)
		end #end do
    end 
  
    $cord = Array.new
    #Convert RBA:Box class to array
      coords.each { |i|
              lx  =  i.left
              ly  =  i.bottom
              ux =  i.right
              uy =  i.top  
              $cord <<  Coordinate.new(lx, ly,ux,uy)
      }
	 $srt = $cord.sort!
	 $len = $srt.length()
	 $e =Array.new
	 $o =Array.new
	 $a   =*(0..$len)
	 $e  << $a.values_at(* $a.each_index.select {|i| i.even?})
	 $o  << $a.values_at(* $a.each_index.select {|i| i.odd?})
	#Flatten array to get Odd/Even Values
	 $fe  = $e.flatten
	 $fo =  $o.flatten
	#New Array to Store Odd/Even
	 $ee =Array.new
	 $oo =Array.new
	# puts Slice into 13xN array based on number of rows
	 $fe.each_slice(13) { |row| $ee << row.map{|e| e}}
	 $fo.each_slice(13) { |row| $oo << row.map{|e| e}}

end     


##############################################
# Test Array Build for Via
#get Value ee[0][0]
##############################################


def even_vias     
	if view == nil
		raise "Process Vias: No view selected"
	end
	# start transaction for "undo"
	view.transaction( "Process Vias" )

	cnt =  $ee.length()
	xx = 0
	$ee.each do |via|
	   if xx.even?
			puts via.join(",")
			(0..$ee[xx].length).each  do |en|
				 puts  $ee[xx][en]
				 $z = set(num)
				 $x = $srt[$z]
				 $x1 =  $x.instance_variable_get :@x1
				 $y1 =  $x.instance_variable_get :@y1
				 $x2 =  $x.instance_variable_get :@x2
				 $y2 =  $x.instance_variable_get :@y2
				 box = RBA::Box::new($x1,$y1 ,$x2 , $y2)
				 shapes = cell.shapes(layer_index)
				 shapes.each_overlapping(box) do |s|
					puts  s
					#shapes.erase(s)
				 end     
			end
			ensure
				view.commit 
				view.cancel
		end
		xx += 1
	end
end
##############################################

process_vias

del_even_via




