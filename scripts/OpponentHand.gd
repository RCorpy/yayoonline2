extends Node2D

const HAND_COUNT = 2
const CARD_WIDTH = 80
const X_HAND_OFFSET_VAR = 0.01

var player_hand = []

@export var rotate:float = 0


func _ready():
	
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
		card.rotate(deg_to_rad(rotate))
		card.disable_card(true)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.card_position, speed)
	
func update_hand_positions(speed):
	print("UPDATING HAND_POSITIONS")
	for i in range(player_hand.size()):
		var new_position = calculate_card_position(i)
		var card = player_hand[i]
		card.card_position = new_position
		card.scale = Vector2(0.5, 0.5)
		animate_card_to_position(card, new_position, speed)
		
		
func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var offset = Vector2((index + X_HAND_OFFSET_VAR) * CARD_WIDTH - total_width/2, 0)

	return offset.rotated(deg_to_rad(rotate))
	
func animate_card_to_position(card, position, speed):
	var tween = get_tree().create_tween()
	#print(position)
	tween.tween_property(card, "position", position, speed)

func remove_card_from_hand(card, speed):
	print("CARDS BEFORE: ", player_hand)
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(speed)
	print("CARDS AFTER: ", player_hand)
