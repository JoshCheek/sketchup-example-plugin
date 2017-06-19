require 'sketchup'
require 'set'

module Eden
  MENU    ||= UI.menu("Tools").add_submenu("Eden")
  TOOLBAR ||= UI::Toolbar.new("Eden")

  class SelectSame
    unless @loaded
      @loaded = true
      cmd = UI::Command.new("Select Same") {
        Sketchup.active_model.select_tool(new)
      }
      cmd.menu_text  = 'Select Same'
      cmd.small_icon = 'icon-16.png'
      cmd.large_icon = 'icon-24.png'
      MENU.add_item(cmd)
      TOOLBAR.add_item(cmd)
    end

    # Can define any of the methods listed here:
    # http://ruby.sketchup.com/Sketchup/Tool.html
    def activate
      Sketchup.status_text = 'Select the duplicated item'
      @source = nil
    end

    def deactivate(view)
      view.invalidate # marks the view as needing a redraw
    end

    def onMouseMove(flags, x, y, view)
      best_picked = view.pick_helper(x, y).best_picked
      return unless @source != best_picked
      @source = best_picked
      model = view.model
      model.selection.clear
      return unless @source
      model.selection.add [@source]
      select_similar model
    end

    def onLButtonUp(flags, x, y, view)
      model = view.model
      model.start_operation('Select Same', true)
      onMouseMove flags, x, y, view
      model.commit_operation
      model.tools.pop_tool
    end

    def select_similar(model)
      current_ids = Set.new(
        model.selection
             .select { |e| e.respond_to? :definition }
             .map    { |e| e.definition.entityID }
      )

      selected_ids = model.entities
                          .select { |e| e.respond_to? :definition }
                          .select { |e| current_ids.include? e.definition.entityID }

      model.selection.add selected_ids
    end
  end
end

