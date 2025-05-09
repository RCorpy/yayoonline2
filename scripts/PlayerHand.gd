extends Node2D

const HAND_COUNT = 15
const CARD_WIDTH = 160
const HAND_Y_POSITION = 970
const X_HAND_OFFSET_VAR = 0.01

var player_hand = []
var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x /2 
	
	for i in range(HAND_COUNT):
		$"../../Deck".draw_card(get_parent())
		#print("INSTANCIATING")
		#var new_card = card_scene.instantiate()
		#$"../CardManager".add_child(new_card)
		#new_card.name = "Card"
		##new_card.position = Vector2(center_screen_x,50)
		#add_card_to_hand(new_card)
		
func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.card_position, speed)
	
func update_hand_positions(speed):
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.card_position = new_position
		animate_card_to_position(card, new_position, speed)
		
		
func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + (index + X_HAND_OFFSET_VAR) * CARD_WIDTH - total_width/2
	#print("center_screen_x ", center_screen_x, "index ", index, "CARD_WIDTH ", CARD_WIDTH, "total_width ", total_width)
	return x_offset
	
func animate_card_to_position(card, position, speed):
	var tween = get_tree().create_tween()
	#print(position)
	tween.tween_property(card, "position", position, speed)

func remove_card_from_hand(card, speed):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(speed)
