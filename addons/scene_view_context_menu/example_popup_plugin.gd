extends EditorScenePopupPlugin

## An example implementation of [EditorScenePopupPlugin]

func _handle_popup_populate():
	# To add a separator, pass in its text.
	add_separator("Example")
	
	# To add an item, pass in its label,
	# the callback Callabe
	# and, optionally, a Texture2D icon.
	add_popup_item(
		"Test",
		func():
			print(mouse_position_when_popup_opened)
	)
	
	# Example item that adds a new node to the scene root.
	add_popup_item(
		"Add Node2D here",
		(func():
			var node = Node2D.new()
			node.name = "Node2D"
			# Add it to the scene root (not the selected node).
			editor_interface.get_edited_scene_root().add_child(node, true)
			node.global_position = mouse_position_when_popup_opened
			editor_interface.get_selection().clear()
			editor_interface.get_selection().add_node(node)
			
			# Remember to set the owner of any newly added nodes,
			# so they'll be saved.
			node.owner = editor_interface.get_edited_scene_root()
	),
		editor_interface.get_base_control().get_theme_icon(&"Node2D", &"EditorIcons")
	)
