extends Control

func _ready():
	$Panel/vbox/name_edit.text=sg.settings["nickname"]

func _on_cancel_btn_pressed():
	hide()
	$Panel/vbox/name_edit.text=sg.settings["nickname"]

func _on_save_btn_pressed():
	sg.settings["nickname"]=$Panel/vbox/name_edit.text
	sg.settings["first_time"]=false
	sg.save_settings()
	hide()
