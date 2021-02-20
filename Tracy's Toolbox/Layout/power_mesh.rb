#Tracy Groller
#Power Mesh
#Date 2/12/21
#Expermintal Best
def power_mesh
  include RBA
  #require 'C:/Users/12144/KLayout/macros/Tracy's Toolbox/Layout/Resize_layer.rb'
  app = Application.instance
  # Get a handle on the main window and the current view
  mw = app.main_window
  lv = mw.current_view
  
  if lv == nil
    raise "No view selected. Choose File > New layout, and run this again."
  end
  
  # Get a handle on the layout
  ly = lv.active_cellview.layout
  dbu = ly.dbu
  cell = lv.active_cellview.cell
  #Define Layer
  layer_number = 5
  datatype = 0
  layer_info = LayerInfo.new(layer_number,datatype)
  layer_index = ly.layer(layer_info)
  
  # Define the coordinates
  space = 150
  wdt = 50
  
  pt1 = 0    #x1
  pt2 = 0    #y2
  pt3 = 5000 #x2
  pt4 = 0    #y2
  
  #steps in the X
  for i in 0..25
      pts = [RBA::Point.new(pt1/dbu,pt2/dbu),RBA::Point.new(pt3/dbu,pt4/dbu)]
      layer_info = LayerInfo.new(9,0)
      layer_index = ly.layer(layer_info)
      path = Path.new(pts,wdt/dbu)
      cell.shapes(layer_index).insert(path)
      pt2 += space #step Y
      pt4 += space #step Y
  end
  #step in Y  define some math
  len = pt3/space
  
  pt1 = 0 
  pt2 = 0 - wdt + 2.5   
  pt3 = 0     
  pt4 = pt4 - space + 2.5
  
  for i in 0..len
      pts = [RBA::Point.new(pt1/dbu,pt2/dbu),RBA::Point.new(pt3/dbu,pt4/dbu)]
      layer_info = LayerInfo.new(11,0)
      layer_index = ly.layer(layer_info)
      path = Path.new(pts,wdt/dbu)
      cell.shapes(layer_index).insert(path)
      pt1 += space #step Y
      pt3 += space #step Y
  end

  lv.add_missing_layers

end


def overlap_intersect 
  app = Application.instance
  mw = app.main_window
  lv = mw.current_view
  
  if lv == nil
    raise "Overlaps InterSect: No view selected"
  end

  # start transaction for "undo"
  lv.transaction( "Overlaps InterSect" )

  begin

    # because objects might be referenced multiple times (thru different hierarchy paths)
    # we must first copy and then delete them
    ly = lv.active_cellview.layout
    input_polygons = []
    layer_number = 10
    datatype = 0
    layer_info = LayerInfo.new(layer_number,datatype)
    layer_index = ly.layer(layer_info)
    output_layer = layer_index

    lv.each_object_selected do |sel|
      shape = sel.shape
      if shape.is_path? || shape.is_box? || shape.is_polygon?

        # Save "area type" shapes in the selection to polygons and delete them
        input_polygons.push(RBA::Polygon::from_dpoly(shape.polygon.transformed_cplx(sel.trans)))
        cv = lv.cellview(sel.cv_index)
        source = cv.layout.cell(sel.cell_index)
        #source.shapes(sel.layer).erase(shape)
        # Remember the input layer for the output
        output_layer ||= sel.layer

      end
    end

    if input_polygons.size > 0

      # perform the "overlaps to void" operation
      # first step: detect overlaps
      ep = RBA::EdgeProcessor::new
      overlaps = ep.merge_to_polygon(input_polygons, 1, false, false)

      # second step: remove the overlaps from original
      result = ep.boolean_to_polygon(input_polygons, overlaps, RBA::EdgeProcessor::mode_and, true, false)

      # write the result to the output
      output_cv = lv.cellview(lv.active_cellview_index)
      target = output_cv.cell.shapes(output_layer)
      result.each { |p| target.insert(p) }

    end
  ensure

    # always execute that code:
    # commit transaction
    lv.commit
    # clear selection and cancel all other edit operations, so 
    # nothing refers to shapes that might have been deleted.
    lv.cancel

  end
end


def resize_layer
#Resize Layer
# Enter your Ruby code here
include RBA

app = RBA::Application.instance
mw = app.main_window
view = mw.current_view
cv = view.cellview(view.active_cellview_index)
ly = view.active_cellview.layout
cl = view.active_cellview.cell
dbu = ly.dbu

layer_info = LayerInfo.new(10,0)
layer_index = ly.layer(layer_info)
width = 25000
height = 25000
cl.each_shape(layer_index) do |shape|
    if shape.is_polygon?
        #Convert polygon to Box
        box =  shape.bbox
        puts("Processing ...")
       # puts box.center
       # puts box.width
       # puts box.height
       # puts box.p1
       # puts box.p2
       # Get Box lx,ly,ux,uy
       # puts box
         lx = box.left
         ly = box.bottom
         ux = box.right
         uy = box.top
         
         mid = box.left + box.width/2
         tid = box.top  - box.width/2
        
         box.left   = mid - width/2
         box.right  = mid + width/2
         
         box.top    = tid + width/2
         box.bottom = tid - width/2
         shape.box = box
      end
   end
end
include RBA
require 'matrix'
$app   = RBA::Application.instance
$mw   = $app.main_window
$view  = $mw.current_view
$cv      = $view.cellview($view.active_cellview_index) 
$cl       = $view.active_cellview.cell
$cv      = RBA::CellView::active
$lay     = $view.active_cellview.layout
$cell    = $cv.cell
$dbu    = $lay.dbu 
$layer_info = LayerInfo.new(10,0)
$layer_index = $lay.layer($layer_info)

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

	if $view == nil
		raise "Process Vias: No view selected"
	end

	$view.transaction( "Process Vias" )

	layer_info = LayerInfo.new(10,0)
	layer_index = $lay.layer(layer_info)
	coords = Array.new

	$cell.each_shape(layer_index) do |shape|
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
# Process Even Vias
#Global  $ee
##############################################
def even_vias     
	if $view == nil
		raise "Process Vias: No view selected"
	end
	# start transaction for "undo"
	$view.transaction( "Process Vias" )

cnt =  $ee.length()
x = 0
$ee.each do |via|
   if x.even?
        puts via.join(",")
        #set length to minus 1 to avoid nil
        #Gotta be a better way
        (0..$ee[x].length-1).each  do |en|
                xn = $ee[x][en]
                $x = $srt[xn]   
                $x1 =  $x.instance_variable_get :@x1
                $y1 =  $x.instance_variable_get :@y1
		$x2 =  $x.instance_variable_get :@x2
		$y2 =  $x.instance_variable_get :@y2
		box = RBA::Box::new($x1,$y1 ,$x2 , $y2)
		shapes = $cell.shapes($layer_index)
		shapes.each_overlapping(box) do |s|
		        puts  s
                        shapes.erase(s)
                end    
          end
      end
      x += 1
  end
 ensure

    # always execute that code:
    # commit transaction
    $view.commit
    # clear selection and cancel all other edit operations, so 
    # nothing refers to shapes that might have been deleted.
    $view.cancel

end
##############################################
##############################################
##############################################
# Process  Odd Vias
#Global  $oo
##############################################
def odd_vias     
	if $view == nil
		raise "Process Vias: No view selected"
	end
	# start transaction for "undo"
	$view.transaction( "Process Vias" )

cnt =  $ee.length()
x = 0
$oo.each do |via|
   if x.odd?
        puts via.join(",")
        #set length to minus 1 to avoid nil
        #Gotta be a better way
        (0..$oo[x].length-1).each  do |en|
                xn = $oo[x][en]
                $x = $srt[xn]   
                $x1 =  $x.instance_variable_get :@x1
                $y1 =  $x.instance_variable_get :@y1
		$x2 =  $x.instance_variable_get :@x2
		$y2 =  $x.instance_variable_get :@y2
		box = RBA::Box::new($x1,$y1 ,$x2 , $y2)
		shapes = $cell.shapes($layer_index)
		shapes.each_overlapping(box) do |s|
		        puts  s
                        shapes.erase(s)
                end    
          end
      end
      x += 1
  end
 ensure

    # always execute that code:
    # commit transaction
    $view.commit
    # clear selection and cancel all other edit operations, so 
    # nothing refers to shapes that might have been deleted.
    $view.cancel

end
##############################################
##############################################


##########################################################
#Create Power Mesh
power_mesh
#Select All
mw.menu.action("edit_menu.select_menu.select_all").trigger
#edit_menu.select_menu.select_all
#Get Overlap InterSect
overlap_intersect
mw.menu.action("edit_menu.select_menu.unselect_all").trigger
#Resize InterSect
resize_layer
##########################################################