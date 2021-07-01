extends Node

signal add_new_server(_name, _ip)

const port=91055
var packet=PacketPeerUDP.new()

func _ready():
	var timer=Timer.new()
	timer.wait_time=0.1
	add_child(timer)
	timer.connect("timeout",self,"Timer_timeout")
	timer.start()

func Timer_timeout():
	if not packet.is_listening():
		packet.listen(port)
	var packet_c=packet.get_available_packet_count()
	if packet_c==0:
		return
	var val=packet.get_var()
	if val:
		emit_signal("add_new_server",val,packet.get_packet_ip())
