
class_name TModResourceGdScriptFile
extends Resource

@export var _absolute_path: String
@export var _relative_path: String
@export var _relative_path_without_file_name: String
@export var _file_name_not_dot: String
@export var _file_extension_not_dot: String
@export_multiline() var _text_content: String
@export var _random_guid_at_new: String 

@export var _loaded_script:Script

func load_script_if_not_loaded():
	if _loaded_script==null:
		force_reload_script_file()
func force_reload_script_file():
	_loaded_script = ResourceLoader.load(
		_absolute_path,
		"GDScript",
		ResourceLoader.CACHE_MODE_IGNORE
	)
	
func get_script_and_load()->Script:
	load_script_if_not_loaded()
	return _loaded_script
	
func _init(absolute_path: String, relative_path: String, file_name_not_dot: String, file_extension_not_dot: String, text_content: String) -> void:
	_absolute_path = absolute_path
	_relative_path = relative_path
	_file_name_not_dot = file_name_not_dot
	_file_extension_not_dot = file_extension_not_dot
	_text_content = text_content
	_relative_path_without_file_name = relative_path.replace(_file_name_not_dot + "." + _file_extension_not_dot, "")
	_random_guid_at_new = str(randi()) + "_" + str(randi()).replace("-","_")


func get_absolute_path() -> String:
	return _absolute_path

func get_relative_path() -> String:
	return _relative_path

func get_relative_path_without_file_name() -> String:
	return _relative_path_without_file_name

func get_file_name_only() -> String:
	return _file_name_not_dot

func get_file_extension_only() -> String:
	return _file_extension_not_dot

func get_file_name_with_extension() -> String:
	return _file_name_not_dot + "." + _file_extension_not_dot

func get_text_content() -> String:
	return _text_content

func get_guid() -> String:
	return _random_guid_at_new

func reload_text_content_from_file() -> void:
	## Check if still exists
	if  FileAccess.file_exists(_absolute_path):
		var file = FileAccess.open(_absolute_path, FileAccess.READ)
		_text_content = file.get_as_text()
		file.close()
	else :
		_text_content = "extends Node"
