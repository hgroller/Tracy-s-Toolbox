# Enter your Ruby code here
#Gui to Access Top level Text and Layers and extract nets
#Tracy Groller 1/14/2021
#Need Combine the Gui 
# Enter your Ruby code here
include RBA

app = RBA::Application.instance
tracer = RBA::NetTracer::new
tech = RBA::NetTracerTechnology::new
layout = RBA::Layout::new

mw = app.main_window
view = mw.current_view
cv = view.cellview(view.active_cellview_index)
ly = view.active_cellview.layout
cl = view.active_cellview.cell
dbu = ly.dbu



layers = ly.layer_indexes.collect { |li| info = ly.get_info(li); [ info.layer, info.datatype, li ] }.sort
in_lyp = []
nets = []
result = []
layers.each do |layer,datatype,li|
  if ! cl.bbox_per_layer(li).empty?
             in_lyp << layer.to_s
             layer_info = LayerInfo.new(layer,0)
             layer_index = ly.layer(layer_info)
             cl.each_shape(layer_index) do |shape|
  if shape.is_text?
             text_obj = shape.text
             string = text_obj.string
             x =  text_obj.x.to_s
             y =  text_obj.y.to_s
             result << {
                             Net:string,
                             X:x,
                             Y:y
                            }
             #nested Array Nets and X/Y Coords
             e = ["#{string}, #{x}, #{y}" ]               
             nets << e
             #nets << string  + " x:" + x +  " y:" + y

            end
         end
     end
end
unique_nets = nets.uniq
net = nets.sort
#x_sort = net.sort_by { |h | h[x] }
#puts net.inspect
#sorted(net , key=lambda k: [k[2], k[1]])
#my_updated_list =  .sort_by(net , key=lambda k: [k[2], k[1]])
#test = net.sort_by{ |a| [ a.[0], a.[2], a.[1]] }
netsort = result.sort_by { |h | [h[:Net] ,h[:X]] }
netsort = result.sort_by { |h | [h[:Net] , h[:Y]]}
puts netsort
#puts Xsort
#puts Ysort

