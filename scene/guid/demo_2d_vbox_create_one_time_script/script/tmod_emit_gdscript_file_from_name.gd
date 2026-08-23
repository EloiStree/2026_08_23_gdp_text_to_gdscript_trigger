class_name TModEmitGDScriptFileFromName
extends TModAbstractCanReceiveGodotScriptResource


signal on_request_to_process_gdscript_resource(script_resource:TModResourceGdScriptFile)
signal on_fail_to_find_gdscript_resource_name(script_name:String)
signal on_succeed_to_find_gdscript_resource_name(script_name:String)
@export var array_of_gdscript_resources: Array[TModResourceGdScriptFile] = []

func clear() -> void:
	array_of_gdscript_resources.clear()

func append_godot_script_resource (script_resource: TModResourceGdScriptFile) -> void:
	array_of_gdscript_resources.append(script_resource)

func search_for_resource_by_name(script_name:String)->Array[TModResourceGdScriptFile]:
	script_name = script_name.strip_edges().to_lower()
	var found_resources: Array[TModResourceGdScriptFile] = []
	for script_resource in array_of_gdscript_resources:
		if script_name.find("/")>-1 or script_name.find("\\")>-1:
			if script_resource.get_relative_path().to_lower() == script_name:
				found_resources.append(script_resource)
		elif script_name.find(".")>-1:
			if script_resource.get_file_name_with_extension().to_lower() == script_name:
				found_resources.append(script_resource)
		else:
			if script_resource.get_file_name_only().to_lower() == script_name:
				found_resources.append(script_resource)
	return found_resources


func reload_file_script_per_file_name(script_name:String):
	var found_resources: Array[TModResourceGdScriptFile] = search_for_resource_by_name(script_name)
	if found_resources.size() == 0:
		on_fail_to_find_gdscript_resource_name.emit(script_name)
		return
	on_succeed_to_find_gdscript_resource_name.emit(script_name)
	for script_resource in found_resources:
		script_resource.force_reload_script_file()

func emit_godot_script_resource_from_file_name(script_name: String) -> void:
	var found_resources: Array[TModResourceGdScriptFile] = search_for_resource_by_name(script_name)
	if found_resources.size() == 0:
		on_fail_to_find_gdscript_resource_name.emit(script_name)
		return
	on_succeed_to_find_gdscript_resource_name.emit(script_name)

	for script_resource in found_resources:
		on_request_to_process_gdscript_resource.emit(script_resource)
	
	
