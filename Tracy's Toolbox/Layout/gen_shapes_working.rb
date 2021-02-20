
# Enter your Ruby code here
# Enter your Ruby code here
## Draw a box.lym
## By davidnhutch
## 
## Draws a box. The x, y, width, height, are set in the code. To see the code, open Macro Editor under the Macros menu on the toolbar

# Wrapping it in 'module ... end' helps avoid namespace clashes but isn't necessary.
module DrawBox

  include RBA
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
  layer_number = 1
  datatype = 0
  layer_info = LayerInfo.new(layer_number,datatype)
  layer_index = ly.layer(layer_info)
  
  # Define the coordinates
  width  = 200 
  height = 100 
  left   = -width  / 2.0 
  bottom = -height / 2.0
  right  =  width  / 2.0
  top    =  height / 2.0
  box = Box.new(left/dbu,bottom/dbu,right/dbu,top/dbu)
  
  cell.shapes(layer_index).insert(box)
  
  lv.add_missing_layers
  
  # Zoom to show the whole box
  lv.zoom_fit
  
  
  
end

module DrawPath

  include RBA
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
  space = 12
 
  wdt  = 5
  pt1 = 0    #x1
  pt2 = 0    #y2
  pt3 = 1000 #x2
  pt4 = 0    #y2
  
  #steps in the Y
  for i in 0..25
      pts = [RBA::Point.new(pt1/dbu,pt2/dbu),RBA::Point.new(pt3/dbu,pt4/dbu)]
      layer_info = LayerInfo.new(1,0)
      layer_index = ly.layer(layer_info)
      path = Path.new(pts,wdt/dbu)
      cell.shapes(layer_index).insert(path)
      pt2 += space #step Y
      pt4 += space #step Y
  end
  
  #steps in the X
  for i in 0..25
      pts = [RBA::Point.new(pt1/dbu,pt2/dbu),RBA::Point.new(pt3/dbu,pt4/dbu)]
      layer_info = LayerInfo.new(1,0)
      layer_index = ly.layer(layer_info)
      path = Path.new(pts,wdt/dbu)
      cell.shapes(layer_index).insert(path)
      pt1 += space  #step X
      #pt4 += space  #step X
  end
  
  lv.add_missing_layers
  
  # Zoom to show the whole box
  lv.zoom_fit
  
  #msg = "Inserted a Path"
  
  #MessageBox.info("Done!",msg,MessageBox::Ok)
 
  #puts msg
  
end
