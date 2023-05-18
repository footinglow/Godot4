extends Control

@export var m_scn_item : PackedScene

var m_test_list = [
	["Taro", "Score 90000"],
	["Jiro", "Score 80000"],
	["Saburo", "Score 70000"],
	["Shiro", "Score 60000"],
	["Goro", "Score 50000"],
	["Rokuro", "Score 40000"],
	["Shichiro", "Score 30000"],
	["Hachiro", "Score 20000"],
	["Kuro", "Score 10000"],
	["Juro", "Score 00000"],
]


func _ready():
	var no=0
	for info in m_test_list:
		var ins = m_scn_item.instantiate()
		ins.set_item_info(no, info[0], info[1])
		$ScrollContainer/VBoxContainer.add_child(ins)
		no = no + 1
		# シグナルを接続する
		ins.on_item_button_press.connect(on_item_button_press)


func on_item_button_press(no):
	print(no)
