extends Control

func _process(delta):
	# Godotエンジンに描画更新を依頼する(_drawメソッド起動を依頼する）
	queue_redraw()
	
func _draw():
	# EnergyBarのサイズ（と使わないけど左上位置）を取得する
	var r : Rect2 = $EnergyBar.get_global_rect()
	# エネルギーバーの背景を黒で描画する
	draw_rect(r, Color.BLACK, true, -1)
	# エネルギーバーの描画領域は1ピクセルずつ小さくする
	var er = r;
	er.size     -= Vector2(2, 2)	# サイズは上下左右一回り小さくする
	er.position += Vector2(1, 1)	# 1ピクセルずつ右下に移動する
	# エネルギーの蓄積割合に従い長さを決めて黄色のバーで描画する。
	er.size.x *= GlobalVariable.get_energy_percent()	# 0.0～1.0の間
	draw_rect(er, Color.YELLOW, true, -1)

	# エネルギーのたまり具体を％（0.0%～100.0%で表示する）
	$EnergyBar/EnergyPercent.text = "%.1f%%" % ( GlobalVariable.get_energy_percent() * 100.0 )
