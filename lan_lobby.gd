extends Control

const NAME_BOX=preload("res://name_box.tscn")

var total_cards0=[
	{"type":0,"size":5},
	{"type":1,"size":4},
	{"type":2,"size":4},
	{"type":3,"size":4},
	{"type":4,"size":4},
	{"type":5,"size":4},
	{"type":6,"size":4},
	{"type":7,"size":4},
	]
var total_cards:Array
var child_count=0
func _ready():
	randomize()
	if not get_tree().is_network_server():
		$vbox/hbox/start_btn.disabled=true
	for pl in nw.players:
		new_name(nw.players[pl])

func new_name(_name):
	var clr="000"
	var new_box=NAME_BOX.instance()
	if _name==nw.nickname:
		clr="f00"
	new_box.set_txt(_name,clr)
	new_box.name=_name
	$vbox/vbox.add_child(new_box)
	set_players_count(1)

func remove_name(_name):
	$vbox/vbox.get_node(_name).queue_free()
	set_players_count(-1)

func set_players_count(n):
	child_count+=n
	$vbox/players.text="players ("+str(child_count)+")"

func _on_start_btn_pressed():
	if nw.players.size()<3 or nw.players.size()>8:
		return
	
	for i in nw.players.size():
		total_cards.append(total_cards0[i])
	for pl in nw.players:
		nw.pl_cards[pl]=nw.my_cards.duplicate(true)
		var s=4+int(pl==1)
		for j in s:
			add_card_to_player(pl,j)
	
	nw.my_cards=nw.pl_cards[nw.this_id]
	for pl in nw.players:
		rpc_id(pl,"go_to_game",nw.pl_cards[pl])

sync func go_to_game(_cards):
	nw.my_cards=_cards
	get_tree().change_scene("res://game.tscn")


func add_card_to_player(_pl,_pos):
	var rand_n:int=floor(randf()*total_cards.size())
	total_cards[rand_n]["size"]-=1
	nw.pl_cards[_pl][_pos]=total_cards[rand_n]["type"]
	if total_cards[rand_n]["size"]==0:
		total_cards.remove(rand_n)


func _on_back_btn_pressed():
	nw.close_cnn()
	get_tree().change_scene("res://main.tscn")

