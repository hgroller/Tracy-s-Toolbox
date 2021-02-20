class MenuAction < RBA::Action
  def initialize( title, shortcut, &action ) 
    self.title = title
    self.shortcut = shortcut
    @action = action
  end
  def triggered 
    @action.call( self ) 
  end
private
  @action
end

menu_handler = MenuAction.new( "Overlaps To Intersect", "" ) do 

  app = RBA::Application.instance
  mw = app.main_window

  lv = mw.current_view
  if lv == nil
    raise "Overlaps To Void: No view selected"
  end

  # start transaction for "undo"
  lv.transaction( "Overlaps To Void" )

  begin

    # because objects might be referenced multiple times (thru different hierarchy paths)
    # we must first copy and then delete them

    input_polygons = []
    layer_number = 5
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

app = RBA::Application.instance
mw = app.main_window

menu = mw.menu
menu.insert_item("edit_menu.selection_menu.intersection", "overlaps_to_void", menu_handler)