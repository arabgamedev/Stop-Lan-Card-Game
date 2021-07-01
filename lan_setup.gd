extends Control

func _ready():
	nw.reset_data()
	
	if OS.get_name()=="Windows":
		$vbox/hbox/ip_edit.text="127.0.0.1"
		

func _on_back_btn_pressed():
	get_tree().change_scene("res://main.tscn")

func _on_join_btn_pressed():
	nw.connect_to_server($vbox/hbox/ip_edit.text)

func _on_create_btn_pressed():
	nw.create_server()

func server_btn_pressed(_ip):
	$vbox/hbox/ip_edit.text=_ip

func _on_Listener_add_new_server(_name, _ip):
	for child in $vbox/list.get_children():
		if child.text==_name:
			return
	var btn=Button.new()
	btn.text=_name
	btn.connect("pressed",self,"join",[_ip])
	$vbox/list.add_child(btn)

func join(_ip):
	nw.connect_to_server(_ip)
