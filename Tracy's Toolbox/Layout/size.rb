
# Enter your Ruby code here
lv = RBA::LayoutView::current

r = RBA::Region::new
lv.each_object_selected do |s|
  if s.shape.is_polygon? || s.shape.is_box? || s.shape.is_path?
    r += s.trans * s.shape.polygon
  end
end
r.sized(100)
puts "Sizing"
puts r.sized(100)
