
# Enter your Ruby code here
# This script requires two selections
# * the first selection is the "subject" 
# * the second selection (Shift + click on object) is the "mask"
# The script will take all polygons from the subject and 
# separate it into parts inside and outside of the mask. 
# 
# TODO: 
# * as a side effect, the polygons are merged currently
#   (solution: pass them separately through the boolean operation)
# The Above has been implemented 

#Modifications 
#testing
include RBA

app = RBA::Application.instance
mw = app.main_window
view = mw.current_view
cv = view.cellview(view.active_cellview_index)
ly = view.active_cellview.layout
dbu = ly.dbu
layout = RBA::Layout::new
# database unit 1nm:
layout.dbu = 0.001
cv1 = RBA::CellView::active


x1 = 20000
y1 = 20000
x2 = 100000
y2 = 150000

pt1 = 10
pt2 = 0
pt3 = 200
pt4 = 0
# 'Chop Box'
set_shortcut("edit_menu.mode_menu.chop_box", "")
##Box Class
dbox = RBA::DBox::new(x1, y1, x2, y2)
box = RBA::Box::new(dbox)
puts(box)
layer_info = LayerInfo.new(1,0)
layer_index = ly.layer(layer_info)
cv1.cell.shapes(cv.layout.layer(5, 0)).insert(RBA::Box::new(x1,y1,x2,y2))

##Polygon Class
pts = [RBA::Point.new(pt1/dbu,pt2/dbu),RBA::Point.new(pt3/dbu,pt4/dbu)]
wdt = 25
layer_info = LayerInfo.new(1,0)
layer_index = ly.layer(layer_info)
cv.cell.shapes(layer_index).insert(Path.new(pts,wdt/dbu))


##Regions Class
#l11 = cv.layer(1, 0)
#l21 = cv.layer(25, 0)

#r11 = RBA::Region::new(ly.top_cell.begin_shapes_rec(l11))
#r21 = RBA::Region::new(ly.top_cell.begin_shapes_rec(l21))

#ly.top_cell.shapes(ly.layer(1000, 0)).insert(r11 & r21)