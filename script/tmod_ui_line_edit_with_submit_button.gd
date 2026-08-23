class_name TModUiLineEditWithSubmitButton
extends Node


signal on_line_edit_submit(text:String)
signal on_line_edit_text_changed(text:String)
signal on_submit_button_pressed(text:String)
signal on_line_edit_any_action(text:String)

@export var line_edit:LineEdit
@export var submit_button:Button


func _ready():
	if line_edit:
		line_edit.text_changed.connect(Callable(self, "_on_line_edit_text_changed"))
		line_edit.text_submitted.connect( Callable(self, "_on_line_edit_submit"))
	if submit_button:
		submit_button.pressed.connect( Callable(self, "_on_submit_button_pressed"))
	
func _on_line_edit_text_changed(new_text:String):
	on_line_edit_text_changed.emit(new_text)
	on_line_edit_any_action.emit(new_text)

func _on_line_edit_submit(submitted_text:String):
	on_line_edit_submit.emit(submitted_text)
	on_line_edit_any_action.emit(submitted_text)

func _on_submit_button_pressed():
	if line_edit:
		var text = line_edit.text
		on_submit_button_pressed.emit(text)
		on_line_edit_any_action.emit(text)
