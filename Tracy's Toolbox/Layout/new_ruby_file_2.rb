
# Enter your Ruby code here
cv = RBA::CellView::active
lay = cv.layout
cell = cv.cell

iter = RBA::RecursiveShapeIterator::new(lay, cell, lay.layer_indexes)
while ! iter.at_end()
  puts iter.shape.to_s + " in cell " + iter.cell.name + " on layer " + lay.get_info(iter.layer).to_s
  iter.next
end
