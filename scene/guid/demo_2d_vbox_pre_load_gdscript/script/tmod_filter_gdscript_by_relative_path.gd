class_name TModFilterGdScriptByRelativePath
extends TModAbstractCanReceiveGodotScriptResource

signal on_godot_script_found( script_found : TModResourceGdScriptFile)

@export var _contains_black_list: Array[String] = []
@export var _contains_white_list: Array[String] = []
@export var _is_equals_to: Array[String] = []
@export var _ignore_case: bool = true


func _ready() -> void:
	if _ignore_case:
		for i in range(_contains_black_list.size()):
			_contains_black_list[i] = _contains_black_list[i].to_lower()
		for i in range(_is_equals_to.size()):
			_is_equals_to[i] = _is_equals_to[i].to_lower()
		for i in range(_contains_white_list.size()):
			_contains_white_list[i] = _contains_white_list[i].to_lower()

func push_in_godot_script_resource(gd_script:TModResourceGdScriptFile) -> void:
	var relative_path = gd_script.get_relative_path_without_file_name().trim_prefix("/").trim_suffix("/").trim_prefix("\\").trim_suffix("\\")
	if _ignore_case:
		relative_path = relative_path.to_lower()
	
	if _contains_black_list.size() > 0:
		for contains_path in _contains_black_list:
			if contains_path in relative_path:
				return
	
	if _is_equals_to.size() > 0:
		for equals_path in _is_equals_to:
			if equals_path == relative_path:
				on_godot_script_found.emit(gd_script)
				return

	if _contains_white_list.size() > 0:
		for contains_path in _contains_white_list:
			if contains_path in relative_path:
				on_godot_script_found.emit(gd_script)
				return
