extends Node2D

signal hovered
signal hovered_off

var card_position
var card_slot_of_card
var card_type

func _ready():
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)
