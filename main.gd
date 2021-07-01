extends Control


func _ready():
	if sg.settings["first_time"]:
		$nickname.show()
	else:
		$nickname.hide()

func _on_play_pressed():
	get_tree().change_scene("res://lan_setup.tscn")

func _on_Name_pressed():
	$nickname.show()
