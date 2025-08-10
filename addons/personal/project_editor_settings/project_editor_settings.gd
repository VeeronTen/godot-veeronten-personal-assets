@tool
extends EditorPlugin

const _PROJECT_EDITOR_SETTINGS_DOCK = preload("res://addons/personal/project_editor_settings/project_editor_settings_dock.tscn")
var _dock

func _enter_tree():
	_dock = _PROJECT_EDITOR_SETTINGS_DOCK.instantiate()
	_dock.on_button_close_plugin_pressed.connect(
		func(): get_editor_interface().set_plugin_enabled("personal/project_editor_settings", false)
	)
	add_control_to_dock(DOCK_SLOT_LEFT_UL, _dock)

func _exit_tree():
	_remove_dock()
	
func _remove_dock():
	remove_control_from_docks(_dock)
	_dock.queue_free()
