extends Control

signal on_list_item_button_pressed(id)

var m_id : int

func set_info(id, name, record):
	m_id = id
	$PanelContainer/PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/LabelName.text = name
	$PanelContainer/PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/LabelRecord.text = record
	

func _on_button_pressed():
	on_list_item_button_pressed.emit(m_id)
