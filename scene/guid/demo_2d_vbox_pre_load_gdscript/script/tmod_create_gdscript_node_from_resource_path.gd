class_name TModCreateGdscriptNodeFromResourcePath
extends Node


signal on_created_node(node_created:Node)
signal on_created_node_with_resource(node_created:Node, resource:TModResourceGdScriptFile)
signal on_created_holding_node_with_resource(holding_node: TModCreatedGDScriptNodeWithResourceHolder)
signal on_resource_not_gdscript(script_resource:TModResourceGdScriptFile)
signal on_file_dont_exist(script_resource:TModResourceGdScriptFile)

@export var _allows_process:bool=true
@export var _allows_physics_process:bool=false

@export var _where_to_create_node:Node
@export var _create_node_as_node_3d:bool=false

@export var _force_file_reload:bool=false

func load_and_run_text_as_godot_script(script_resource:TModResourceGdScriptFile) -> void:
	if script_resource==null:
		return
		 
	var script_path: String = script_resource.get_absolute_path()
	if not FileAccess.file_exists(script_path):
		on_file_dont_exist.emit(script_resource)
		return
		
	if _force_file_reload:
		script_resource.force_reload_script_file()
		
	var script: Script=script_resource.get_script_and_load()
	if not script is GDScript:
		push_error("That not a Godot Script")
		on_resource_not_gdscript.emit(script_resource)
		return
	
	var node :Node =  Node3D.new() if _create_node_as_node_3d else Node.new()
	node.set_script(script)
	node.set_process(_allows_process)
	node.set_physics_process(_allows_physics_process)

	if _where_to_create_node:
		_where_to_create_node.add_child(node)
	else:
		add_child(node)
		
	on_created_node.emit(node)
	on_created_node_with_resource.emit(node, script_resource)

	var holder: TModCreatedGDScriptNodeWithResourceHolder = TModCreatedGDScriptNodeWithResourceHolder.new()
	holder.set_holding_resource(script_resource)
	holder.set_holding_node_and_parent_it(node)
	on_created_holding_node_with_resource.emit(holder)
