extends Node2D

var player_deck = ["demon", "demon", "demon"]

const CARD_SCENE_PATH = "res://scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.4

func draw_card():
	var card_draw = player_deck[0]
	player_deck.erase(card_draw)
	
	if player_deck.size() == 0:
		print("DECK FINISHED")
		
	var card_scene = preload(CARD_SCENE_PATH)
	print("INSTANCIATING")
	var new_card = card_scene.instantiate()
	new_card.position = position
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	#new_card.position = Vector2(center_screen_x,50)
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
