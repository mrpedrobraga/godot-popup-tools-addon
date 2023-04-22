extends Node
class_name EditorScenePopupPlugin

## Class that allows adding entries to the CanvasItemEditor's popup menu.
##
## Do not implement your custom options here,
## instead, create a class that extends this one.
##
## With this plugin, there's an example already.

## The position of the cursor (in world) when the popup opened.
var mouse_position_when_popup_opened : Vector2 = Vector2(0, 0)

## The editor interface. Useful to get things like the currently selected node.
var editor_interface : EditorInterface
var _main_screen
var _canvas_item_editor
## The CanvasItemEditor's popup menu.[br]
## Its contents only exist after it's been opened (by RMB).
var popup_menu : PopupMenu

func _enter_tree():
	_main_screen = editor_interface.get_editor_main_screen()
	_canvas_item_editor = _main_screen.get_child(0)
	
	_canvas_item_editor.get_child(1).get_child(0).get_child(0).get_child(0).\
	get_child(1).gui_input.connect(_canvas_item_hijack)

func _exit_tree():
	_canvas_item_editor.get_child(1).get_child(0).get_child(0).get_child(0).\
	get_child(1).gui_input.disconnect(_canvas_item_hijack)

var _current_popup_callbacks : Dictionary = {}

func _canvas_item_hijack(ev = null):
	if ev is InputEventMouseButton:
		if not ev.pressed: return
		
		if ev.button_index == MOUSE_BUTTON_RIGHT:
			await get_tree().process_frame
			var scene := editor_interface.get_edited_scene_root()
			_current_popup_callbacks.clear()
			if scene is CanvasItem:
				mouse_position_when_popup_opened = scene.get_local_mouse_position() + scene.global_position
			else:
				# TODO: get mouse position in world without needing the scene.
				mouse_position_when_popup_opened = Vector2(0, 0)
			# Set the popup menu to the canvas item popup menu;
			if popup_menu:
				popup_menu.id_pressed.disconnect(_popup_menu_id_pressed)
			popup_menu = _canvas_item_editor.get_child(4)
			popup_menu.id_pressed.connect(_popup_menu_id_pressed)
			_handle_popup_populate()

## Virtual function to be overriden by the user;
##
## Adds a new entry to the context menu.
func _handle_popup_populate() -> void:
	pass

## Adds a new item to the current popup menu.[br][br]
## Needs to be called inside [method _handle_popup_populate].
func add_popup_item(label:String, callback:Callable, icon=null):
	var index = popup_menu.item_count
	popup_menu.add_item(label, index + 1)
	_current_popup_callbacks[index + 1] = callback
	if icon:
		popup_menu.set_item_icon(index, icon)

## Adds a new separator to the current popup menu.[br][br]
## Needs to be called inside [method _handle_popup_populate].
func add_separator(label : String) -> void:
	popup_menu.add_separator(label)

func _popup_menu_id_pressed(id : int):
	var scene := editor_interface.get_edited_scene_root()
	if _current_popup_callbacks.has(id):
		_current_popup_callbacks[id].call()
