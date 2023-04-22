@tool
extends EditorPlugin

func _enter_tree():
	add_scene_popup_plugin(preload("res://addons/scene_view_context_menu/example_popup_plugin.gd"))

func add_scene_popup_plugin(plugin : Script):
	var plugin_obj : EditorScenePopupPlugin = plugin.new()
	plugin_obj.editor_interface = get_editor_interface()
	add_child(plugin_obj)
