extends Control

signal on_item_button_press(no)

var m_no     : int

func set_item_info(no, name, record):
	m_no     = no
	$Panel/Panel2/HBoxContainer/MarginContainer/VBoxContainer/Name.text = name
	$Panel/Panel2/HBoxContainer/MarginContainer/VBoxContainer/Record.text = record

func get_size_px() -> Vector2:
	return size

func _on_button_pressed():
	on_item_button_press.emit(m_no)
