class_name TModGodotScriptGroupHolder
extends Node


signal on_emit_stored_godot_script(script_resource:TModResourceGdScriptFile)
signal on_emit_stored_godot_script_as_array(script_resources:Array[TModResourceGdScriptFile])

@export var _group_of_godot_Script: Array[TModResourceGdScriptFile] = []


func clear () -> void:
	_group_of_godot_Script.clear()

func append_godot_script(script_resource: TModResourceGdScriptFile) -> void:
	if script_resource:
		_group_of_godot_Script.append(script_resource)

func remove_godot_script(script_resource: TModResourceGdScriptFile) -> void:
	if script_resource:
		_group_of_godot_Script.erase(script_resource)


func trigger_stored_godot_script() -> void:
	for script_resource in _group_of_godot_Script:
		if script_resource:
			on_emit_stored_godot_script.emit(script_resource)

	if _group_of_godot_Script.size() > 0:
		on_emit_stored_godot_script_as_array.emit(_group_of_godot_Script)
	else:
		on_emit_stored_godot_script_as_array.emit([])
