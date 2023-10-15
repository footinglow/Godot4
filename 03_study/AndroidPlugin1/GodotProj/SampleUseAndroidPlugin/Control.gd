extends Control

func _ready():
	if Engine.has_singleton("GodotExtendedPlugin"):
		var singleton = Engine.get_singleton("GodotExtendedPlugin")
		$Label.text = singleton.getMyMessage()
	else:
		$Label.text = "No Plugin"
