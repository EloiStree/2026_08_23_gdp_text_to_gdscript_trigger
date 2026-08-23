class_name TModKillNodeHolderAfterLifeTimeOut
extends Node



@export var _life_time_in_seconds: float = 0.1

var _fifo_node_to_kill: Array[NodeKiller] = []


func kill_with_inspector_time(node_holder: Node) -> void:
	kill_with_custom_time(node_holder, _life_time_in_seconds)

func kill_with_custom_time(node_holder: Node, custom_time: float) -> void:
	var node_killer = NodeKiller.new()
	node_killer.kill_in_seconds(node_holder, custom_time)
	_fifo_node_to_kill.append(node_killer)


func _process(delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	var list_count = _fifo_node_to_kill.size()
	for i in range(list_count - 1, -1, -1):
		var node_killer = _fifo_node_to_kill[i]
		if node_killer._when_to_kill_it <= current_time:
			node_killer.kill_it()
			_fifo_node_to_kill.remove_at(i)


class NodeKiller:
	var _node_to_kill: Node
	var _when_to_kill_it: float

	func get_current_time() -> float:
		return Time.get_ticks_msec() / 1000.0
	
	func kill_in_seconds(node_holder: Node, seconds: float) -> void:
		self._node_to_kill = node_holder
		_when_to_kill_it = get_current_time() + seconds

	func kill_it() -> void:
		if _node_to_kill:
			_node_to_kill.queue_free()
			_node_to_kill = null
