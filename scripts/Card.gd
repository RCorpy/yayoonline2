extends Node2D

signal hovered
signal hovered_off

var card_position
var card_slot_of_card
var card_type
var name_of_card
var flipped = false

func _ready():
	get_parent().get_parent().get_parent().get_node("CardManager").connect_card_signals(self)

func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)

func flip_card(flip):
	if flip:
		flipped = flip
		$AnimationPlayer.play("card_flip")
