# save this script to "generate.rb" and run it with "klayout -r generate.rb -b"
layout = RBA::Layout::new

# database unit 1nm:
layout.dbu = 0.001

cv = RBA::CellView::active
cv.cell.shapes(cv.layout.layer(5, 0)).insert(RBA::Box::new(0, 0, 100000, 150000))