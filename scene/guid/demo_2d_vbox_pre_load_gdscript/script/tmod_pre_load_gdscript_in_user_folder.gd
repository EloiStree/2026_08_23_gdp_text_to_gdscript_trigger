class_name TModPreLoadGDScriptInUserFolder
extends Node



signal on_godot_script_found( script_found : TModResourceGdScriptFile)


@export var _user_folder_path: String = "user://data/config/modding/gdscript"
@export var _res_folder_path: String = "res://data/config/modding/gdscript"

@export var _create_folder_if_not_existing: Array[String] = [
	"at_ready",
	"at_exit_tree",
	"interpreter_sc",
	"interpreter_cmd",
	"at_focus_enter",
	"at_focus_exit"
	]

@export var _node_listeners: Array[TModAbstractCanReceiveGodotScriptResource] = []

@export var _use_print_at_ready: bool = false
@export_group("Pre-load GDScript in user folder")
@export var _all_file_paths_in_gdscript_folder: Array[String] = []
@export var _all_gdscript_file_paths_in_gdscript_folder: Array[String] = []
@export var _pre_load_gdscript_in_user_folder: Dictionary[String, TModResourceGdScriptFile] ={}

func _ready() -> void:
	created_folder_if_not_exists(_user_folder_path)
	var is_in_editor:bool = Engine.is_editor_hint()
	if not is_in_editor:
		created_folder_if_not_exists(_res_folder_path)
	reload_all_files_in_gdscript_folder()
	if _use_print_at_ready:
		var user_absolute_path = turn_godot_path_to_absolute_path(_user_folder_path)
		var res_absolute_path = turn_godot_path_to_absolute_path(_res_folder_path)
		print("User absolute path:", user_absolute_path)
		print("Res absolute path:", res_absolute_path)	
		print("User:", _user_folder_path)
		print("Res: ", _res_folder_path)
		print("\n\n\nAll files:", _display_joined_array(_all_file_paths_in_gdscript_folder))
		print("\n\n\nAll GDScript files:", _display_joined_array(_all_gdscript_file_paths_in_gdscript_folder))
		print("\n\n\nPre-loaded GDScript:", _display_joined_array(_pre_load_gdscript_in_user_folder.keys()))
	for node_listener in _node_listeners:
		if node_listener:
			for gd_script_resource in _pre_load_gdscript_in_user_folder.values():
				node_listener.push_in_godot_script_resource(gd_script_resource)
				#print("Pushed GDScript resource to node listener:", node_listener, "Resource:", gd_script_resource)

func turn_godot_path_to_absolute_path(godot_path: String) -> String:
	if godot_path.begins_with("user://"):
		return godot_path.replace("user://", OS.get_user_data_dir() + "/")
	if godot_path.begins_with("res://"):
		return godot_path.replace("res://", ProjectSettings.globalize_path("res://"))
	return godot_path

func reload_all_files_in_gdscript_folder() -> void:
	_all_file_paths_in_gdscript_folder.clear()
	_all_gdscript_file_paths_in_gdscript_folder.clear()
	_pre_load_gdscript_in_user_folder.clear()
	
	_scan_directory_recursive(_user_folder_path)
	var absolute_path_user_folder = turn_godot_path_to_absolute_path(_user_folder_path)
	var absolute_path_res_folder = turn_godot_path_to_absolute_path(_res_folder_path)

	for file_path in _all_gdscript_file_paths_in_gdscript_folder:
		var absolute_path = file_path
		var relative_path = file_path.replace(absolute_path_user_folder, "").replace(absolute_path_res_folder, "")
		var file_name_not_dot = relative_path.get_file().get_basename()
		var file_extension_not_dot = relative_path.get_file().get_extension()
		var text_content = ""
		if FileAccess.file_exists(absolute_path):
			var file = FileAccess.open(absolute_path, FileAccess.READ)
			text_content = file.get_as_text()
			file.close()

		var gd_script_resource = TModResourceGdScriptFile.new(absolute_path, relative_path, file_name_not_dot, file_extension_not_dot, text_content)
		_pre_load_gdscript_in_user_folder[file_path] = gd_script_resource
		on_godot_script_found.emit(gd_script_resource)
		if _use_print_at_ready:
			print("\nPre-loaded GDScript file:", file_path, 
			"\nRelative path:", relative_path,
			"\nFile name:", file_name_not_dot,
			"\nExtension:", file_extension_not_dot)

func _display_joined_array(array: Array) -> String:
	return "\n".join(array)


func _scan_directory_recursive(folder_path: String) -> void:
	var absolute_path = turn_godot_path_to_absolute_path(folder_path)
	var dir_access: DirAccess = DirAccess.open(absolute_path)
	if dir_access:
		dir_access.list_dir_begin()
		var file_name: String = dir_access.get_next()
		while file_name != "":
			if file_name.begins_with("."):
				file_name = dir_access.get_next()
				continue
			
			var file_path: String = absolute_path.path_join(file_name)
			
			if dir_access.current_is_dir():
				_scan_directory_recursive(file_path)
			else:
				_all_file_paths_in_gdscript_folder.append(file_path)
				if file_name.ends_with(".gd"):
					_all_gdscript_file_paths_in_gdscript_folder.append(file_path)
					var file_name_no_ext = file_name.get_basename()
					var file_ext = file_name.get_extension()
					var text_content = ""
					if FileAccess.file_exists(file_path):
						var file = FileAccess.open(file_path, FileAccess.READ)
						text_content = file.get_as_text()
						file.close()
					var file := TModResourceGdScriptFile.new(file_path, file_path, file_name_no_ext, file_ext, text_content)

					_pre_load_gdscript_in_user_folder[file_path] = file
			
			file_name = dir_access.get_next()
		dir_access.list_dir_end()


func created_folder_if_not_exists(folder_path: String) -> void:
	if folder_path.begins_with("user://"):
		folder_path = turn_godot_path_to_absolute_path(folder_path)
		if not DirAccess.dir_exists_absolute(folder_path):
			DirAccess.make_dir_recursive_absolute(folder_path)
		return 
		
	if not Engine.is_editor_hint():
		if folder_path.begins_with("res://"):
			folder_path = turn_godot_path_to_absolute_path(folder_path)
		if not DirAccess.dir_exists_absolute(folder_path):
			DirAccess.make_dir_recursive_absolute(folder_path)
		return 
	
	if not DirAccess.dir_exists_absolute(folder_path):
			DirAccess.make_dir_recursive_absolute(folder_path)

	## check the absolute path


func _on_input_text_dictionary_true_false_value_to_actions_on_action_found(action_name: String) -> void:
	pass # Replace with function body.
