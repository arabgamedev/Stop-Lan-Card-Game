extends Control

var crr_card=null setget selected_changed

var my_cards=nw.my_cards
var next_peer_id=null
func _ready():
	$nickname.text=nw.nickname
	next_pl()
	cards_change()
	$vbox/give_it.text=""
	$vbox/center/give_btn.disabled=true
	$hbox/stop_btn.disabled=true

func selected_changed(_n):
	crr_card=_n
	var cards_size=0
	for i in my_cards:
		if i>=0:
			cards_size+=1
	if _n!=null and cards_size==5:
		$vbox/give_it.text="give it to "+nw.players[next_peer_id]
		$vbox/center/give_btn.disabled=false
	else:
		$vbox/give_it.text=""
		$vbox/center/give_btn.disabled=true

func _on_back_btn_pressed():
	$exit_game.show()

func _on_give_btn_pressed():
	rpc_id(next_peer_id,"recive_card",my_cards[crr_card])
	my_cards[crr_card]=-1
	$base.get_node("card"+str(crr_card)).hide()
	$hbox/stop_btn.disabled=false
	selected_changed(null)

remote func recive_card(_card_n):
	for i in my_cards.size():
		if my_cards[i]==-1:
			my_cards[i]=_card_n
			$base.get_node("card"+str(i)).change_sp(_card_n)
			$hbox/stop_btn.disabled=true
			break

func next_pl():
	var players_ar=nw.players.keys()
	var i=players_ar.find(nw.this_id)
	if i==players_ar.size()-1:
		next_peer_id=players_ar[0]
	else:
		next_peer_id=players_ar[i+1]

func cards_change():
	for i in my_cards.size():
		if my_cards[i]==-1:
			$base.get_node("card"+str(i)).hide()
		else:
			$base.get_node("card"+str(i)).change_sp(my_cards[i])

func _on_stop_btn_pressed():
	#Array
	var card_n=my_cards[int(my_cards[0]==-1)]
	if my_cards.count(card_n)==4:
		rpc("winner",nw.nickname)

sync func winner(_name):
	$winner.show()
	$hbox/stop_btn.disabled=true
	
	if _name==nw.nickname:
		$winner/vbox/win.text="you win!"
	else:
		$winner/vbox/win.text=_name+"\nwon!"
	
