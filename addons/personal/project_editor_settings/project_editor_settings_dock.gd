@tool
extends Control

signal on_button_close_plugin_pressed
const EDITOR_SETTING_NAME_CODE_FONT_CONTEXTUAL_LIGATURES = "interface/editor/code_font_contextual_ligatures"
const PROJECT_SETTING_NAME_PATTERN_GDSCRIPT_WARNINGS = "gdscript/warnings/"
var _editor_settings = EditorInterface.get_editor_settings()

func _on_button_enbable_code_font_contextual_ligatures_pressed() -> void:
	_set_editor_setting_and_log(EDITOR_SETTING_NAME_CODE_FONT_CONTEXTUAL_LIGATURES, 0)
		
func _on_button_enbable_all_gdscript_warnings_pressed() -> void:
	var warning_project_settings = ProjectSettings.get_property_list().filter(
		func(setting): return PROJECT_SETTING_NAME_PATTERN_GDSCRIPT_WARNINGS in setting.name
	)
	assert(not warning_project_settings.is_empty(), "warning settings were not found!")
	var ignored_warning_project_settings = warning_project_settings.filter(
		func(warning_setting): 
			var current_value = ProjectSettings.get_setting(warning_setting.name)
			return current_value == 0 if current_value is int else false
	)
	if ignored_warning_project_settings.is_empty():
		print("PROJECT all ", PROJECT_SETTING_NAME_PATTERN_GDSCRIPT_WARNINGS, " settings were set correctly already")
	else:
		for setting in ignored_warning_project_settings: 
			_set_project_setting_and_log(setting.name, 1)
	ProjectSettings.save()

func _on_button_close_plugin_pressed() -> void:
	push_warning("Don't forget to reload project to get rid of UNDO risk")
	on_button_close_plugin_pressed.emit()

func _set_editor_setting_and_log(setting: String, new_value: Variant):
	var prev_value = _editor_settings.get_setting(setting)
	_editor_settings.set_setting(setting, new_value)
	_log_change("EDITOR " + setting, prev_value, new_value)

func _set_project_setting_and_log(setting: String, new_value: Variant):
	var prev_value = ProjectSettings.get_setting(setting)
	ProjectSettings.set_setting(setting, new_value)
	_log_change("PROJECT " + setting, prev_value, new_value)

func _log_change(name: String, prev_value: Variant, new_value: Variant):
	if prev_value != new_value: 
		print(name, "\n\t", prev_value, " -> ", new_value)
	else:
		print(name, "\n\twas NOT chnaged, still ", new_value)
