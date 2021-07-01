extends TextureButton

const ns=[
	"res://sprites/apple.png",
	"res://sprites/banana.png",
	"res://sprites/orange.png",
	"res://sprites/cherries.png",
	"res://sprites/strawberrie.png",
	"res://sprites/pears.png",
	"res://sprites/lemon.png",
	"res://sprites/watermelon.png",
]
const clr0=Color("feffb2")
const clr1=Color("bae74c")
var n
func _ready():
	self_modulate=clr0
	n=int(name.substr(4,1))

func change_sp(n:int):
	show()
	$Sprite.texture=load(ns[n])


func _on_card_pressed():
	if self_modulate!=clr0:
		self_modulate=clr0
		get_parent().get_parent().crr_card=null
		return
	for child in get_parent().get_children():
		if child.is_in_group("card"):
			child.self_modulate=clr0
	self_modulate=clr1
	get_parent().get_parent().crr_card=n


func _on_card_hide():
	self_modulate=clr0
