class_name TModEmitInOutGodotEvent
extends Node

signal on_init_event()
signal on_enter_tree_event()
signal on_ready_event()
signal on_exit_tree_event()
signal on_application_win_focus_event()
signal on_application_lost_focus_event()
signal on_application_quit_event()


func _ready() -> void:
	on_ready_event.emit()
	
func _init() -> void:
	on_init_event.emit()	

func _enter_tree() -> void:
	on_enter_tree_event.emit()

func _exit_tree() -> void:
	on_exit_tree_event.emit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		on_application_win_focus_event.emit()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		on_application_lost_focus_event.emit()	
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:	
		on_application_quit_event.emit()
