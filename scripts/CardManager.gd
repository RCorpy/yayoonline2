extends Node2D

const FINISH_DRAG_SPEED = 0.4
const MAX_CARDS_IN_SLOT = 1
const COLLISION_MASK_PLAYER_AREA = 8

const DEFAULT_CARD_SCALE = 0.8
const DEFAULT_HIGHLIGHT_SCALE = 0.85
const CARD_ON_SLOT_SCALE = 0.6

var card_being_dragged
var screen_size
var is_hovering_on_card
var player_hand_reference


func _ready():

	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_release)


func _process(delta):
	if card_being_dragged:
		var mouse_position = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			clamp(mouse_position.x, 0, screen_size.x), 
			clamp(mouse_position.y, 0, screen_size.y)
		)


func start_drag(card):
	card.scale=Vector2(DEFAULT_CARD_SCALE,DEFAULT_CARD_SCALE)
	card_being_dragged = card


func finish_drag():
	print("finished drag")
	card_being_dragged.scale=Vector2(DEFAULT_HIGHLIGHT_SCALE, DEFAULT_HIGHLIGHT_SCALE)
	var player_found = raycast_for_player_area()
	print("player_found", player_found)
	
	if player_found:
		var card_slot_found = get_player_card_slot(player_found)
		print("card slot found", card_slot_found)
		if card_slot_found.cards_in_slot.size()<MAX_CARDS_IN_SLOT:
			player_hand_reference.remove_card_from_hand(card_being_dragged, FINISH_DRAG_SPEED)
			card_being_dragged.rotation = card_slot_found.rotation + card_slot_found.get_parent().rotation
			card_being_dragged.global_position = card_slot_found.global_position
			card_being_dragged.scale = Vector2(CARD_ON_SLOT_SCALE, CARD_ON_SLOT_SCALE)
			card_being_dragged.card_slot_of_card = card_slot_found
			#print(card_slot_found.position)
			#
			card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
			card_slot_found.cards_in_slot.append(card_being_dragged)
		else:
			player_hand_reference.add_card_to_hand(card_being_dragged, FINISH_DRAG_SPEED)
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, FINISH_DRAG_SPEED)
	card_being_dragged = null

func get_player_card_slot(player):
	for node in player.get_node(player.name + "CardSlots").get_children():
		if node.card_slot_type == CardDataBase.CARDS[card_being_dragged.name_of_card][0]:
			return node
	

func raycast_for_player_area():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER_AREA
	var result = space_state.intersect_point(parameters)
	if result.size()>0:
		return result[0].collider.get_parent()
	return null


func raycast_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	#parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size()>0:
		return get_card_with_highest_z(result)#result[0].collider.get_parent()
	return null


func connect_card_signals(card):
	card.connect("hovered", _on_hovered_over_card)
	card.connect("hovered_off", _on_hovered_off_card)
	
	
func _on_hovered_over_card(card):
	if not is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)


func _on_hovered_off_card(card):
	if not card_being_dragged and not card.card_slot_of_card:
		highlight_card(card, false)
		var new_card_hovered = raycast_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false


func highlight_card(card, hovered):
	if hovered:
		card.scale=Vector2(DEFAULT_HIGHLIGHT_SCALE,DEFAULT_HIGHLIGHT_SCALE)
		card.z_index = 2
	else:
		card.scale=Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
		card.z_index = 1


func on_left_click_release():
	if card_being_dragged:
		finish_drag()


func get_card_with_highest_z(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index >  highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
