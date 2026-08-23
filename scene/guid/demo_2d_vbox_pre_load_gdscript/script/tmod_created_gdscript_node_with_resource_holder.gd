class_name TModCreatedGDScriptNodeWithResourceHolder
extends Node

@export var _holding_node: Node
@export var _holding_resource: TModResourceGdScriptFile

func set_holding_node_and_parent_it(given_node: Node) -> void:
	if given_node:
		_holding_node = given_node
		if _holding_node.get_parent():
			_holding_node.get_parent().remove_child(_holding_node)
		add_child(_holding_node)
	
func set_holding_resource(resource: TModResourceGdScriptFile) -> void:
	_holding_resource = resource

func destroy_node_and_holding_node() -> void:
	if _holding_node:
		_holding_node.queue_free()
		_holding_node = null
	if _holding_resource:
		_holding_resource = null
	self.queue_free()

func get_guid_of_resource() -> String:
	if _holding_resource:
		return _holding_resource.get_guid()
	return ""
