extends Node

const port=91055
var packet=PacketPeerUDP.new()

func _ready():
	if not get_tree().is_network_server():
		return
	packet.set_broadcast_enabled(true)
	var timer=Timer.new()
	timer.wait_time=0.1
	add_child(timer)
	timer.connect("timeout",self,"Timer_timeout")
	timer.start()

func Timer_timeout():
	var dest_ip="255.255.255.255"
	for address in IP.get_local_addresses():
		var parts = address.split('.')
		if (parts.size() == 4 and "192.168" in address):
			parts[3] = "255"
			dest_ip=parts.join('.')
			break
	packet.set_dest_address(dest_ip,port)
	packet.put_var(nw.players[1])
