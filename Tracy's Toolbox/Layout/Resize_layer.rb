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

layer_info = LayerInfo.new(5,0)
layer_index = ly.layer(layer_info)
width = 25000
height = 25000
cl.each_shape(layer_index) do |shape|
    if shape.is_box?
        #Solve it by bbox() method and 
        #then applying center(), height(), width() and so on
       
        box =  shape.bbox
       
        puts("Processing ...")
       # puts box.center
       # puts box.width
       # puts box.height
       # puts box.p1
       # puts box.p2
       # Get Box lx,ly,ux,uy
         puts box
         lx = box.left
         ly = box.bottom
         ux = box.right
         uy = box.top
         
         mid = box.left + box.width/2
         tid = box.top  + box.width/2
         box.left   = mid - width/2
         box.right  = mid + width/2
         
         box.top    = tid + width/2
         box.bottom = tid - width/2
         shape.box = box
     end
end




