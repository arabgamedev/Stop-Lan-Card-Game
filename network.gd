extends Node


const port=2598

var max_players=6
var host
var this_id

var pl_cards:Dictionary
var my_cards:Array
var nickname
var players:Dictionary

func _ready():
	reset_data()

func reset_data():
	pl_cards={}
	my_cards=[-1,-1,-1,-1,-1]
	nickname=sg.settings["nickname"]
	players={}

func create_server():
	get_tree().connect("network_peer_disconnected",self,"peer_discnn")
	host=NetworkedMultiplayerENet.new()
	host.create_server(port,max_players)
	get_tree().set_network_peer(host)
	this_id=get_tree().get_network_unique_id()
	players[1]=nickname
	get_tree().change_scene("res://lan_lobby.tscn")

func connect_to_server(_ip="127.0.0.1"):
	host=NetworkedMultiplayerENet.new()
	get_tree().connect("connected_to_server",self,"connected_to_server")
	get_tree().connect("server_disconnected",self,"server_discnn")
	host.create_client(_ip,port)
	get_tree().set_network_peer(host)
	this_id=get_tree().get_network_unique_id()

func close_cnn():
	host.close_connection()

func connected_to_server():
	# run only on joined player
	rpc_id(1,"new_player",this_id,nickname)

func peer_discnn(peer_id):
	# only on server
	if get_tree().current_scene.name=="lan_lobby":
		rpc("remove_name_from_lobby",peer_id)
	elif get_tree().current_scene.name=="game":
		rpc("someone_discnn")

sync func remove_name_from_lobby(_id):
	if !get_tree().current_scene.name=="lan_lobby":
		return
	if !players.has(_id):
		return
	get_tree().current_scene.remove_name(players[_id])
	players.erase(_id)

sync func someone_discnn():
	#get_tree().quit()
	get_tree().change_scene("res://main.tscn")
	

func server_discnn():
	#get_tree().quit()
	get_tree().change_scene("res://main.tscn" )

remote func new_player(_id,_name):
	if !get_tree().current_scene.name=="lan_lobby":
		return
	
	if get_tree().is_network_server():
		print(_name)
		_name=check_name(_name)
		players[_id]=_name
		
		get_node("../lan_lobby").new_name(_name)
		rpc_id(_id,"game_data",["players","nickname"],[players,_name])
		
		for pl in players:
			rpc_id(pl,"new_player",_id,_name)
	if !players.has(_id):
		players[_id]=_name
		get_node("../lan_lobby").new_name(_name)

remote func game_data(vars,vals):
	for i in range(vars.size()):
		set(vars[i],vals[i])
	get_tree().change_scene("res://lan_lobby.tscn")

func check_name(_name) :
	for pl in players:
		if players[pl]==_name:
			_name+=str(floor(randf()*10000))
	return _name

