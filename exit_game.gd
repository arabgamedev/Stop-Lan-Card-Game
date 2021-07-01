extends Control



func _on_cancel_btn_pressed():
	hide()


func _on_yes_btn_pressed():
	nw.close_cnn()
	get_tree().change_scene("res://main.tscn")
