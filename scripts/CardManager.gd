extends Node2D

const FINISH_DRAG_SPEED = 0.4
const MAX_CARDS_IN_SLOT = 3
const COLLISION_MASK_PLAYER_AREA = 8
const COLLISION_MASK_CARD = 2

const DEFAULT_CARD_SCALE = 0.8
const DEFAULT_HIGHLIGHT_SCALE = 0.85
const CARD_ON_SLOT_SCALE = 0.6
const SUBSEQUENT_CARD_DISPLACEMENT = Vector2(25,25)

var card_being_dragged
var screen_size
var is_hovering_on_card
var player_highlighted


func _ready():

	screen_size = get_viewport_rect().size
	$"../InputManager".connect("left_mouse_button_released", on_left_click_release)


func _process(delta):
	if card_being_dragged:
		var mouse_position = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			clamp(mouse_position.x, 0, screen_size.x), 
			clamp(mouse_position.y, 0, screen_size.y)
		)
		var player_selected = raycast_for_player_area()
		if player_selected == player_highlighted:
			pass
		elif player_selected and not player_highlighted:
			player_highlighted = player_selected
			highlight_player(player_highlighted, true)
			print("on player ", player_selected, " area")
		else:
			highlight_player(player_highlighted, false)
			player_highlighted = null
	else:
		highlight_player(player_highlighted, false)
		player_highlighted = null

func start_drag(card):
	card.scale=Vector2(DEFAULT_CARD_SCALE,DEFAULT_CARD_SCALE)
	card_being_dragged = card


func finish_drag():
	if $"../PlayerManager".is_local_player_turn():
		if player_highlighted:
			highlight_player(player_highlighted, false)
			player_highlighted = null
		card_being_dragged.scale=Vector2(DEFAULT_HIGHLIGHT_SCALE, DEFAULT_HIGHLIGHT_SCALE)
		var player_found = raycast_for_player_area()
		
		if not card_is_affordable():
			card_being_dragged.get_parent().add_card_to_hand(card_being_dragged, FINISH_DRAG_SPEED)
			print("CANT AFFORD")

		elif player_found:
			var card_slot_found = get_player_card_slot(player_found)
			if not card_slot_found:
				#HANDLE SPELLS AND SPECIALS
				resolve_card_cost_health_money(player_found, card_being_dragged.get_parent().get_parent(), $"../Deck".get_card_info(card_being_dragged.name_of_card))
				resolve_card_effects(player_found, card_being_dragged.get_parent().get_parent(), $"../Deck".get_card_info(card_being_dragged.name_of_card)[4])
				card_being_dragged.queue_free()
				
			elif card_slot_found.cards_in_slot.size()<MAX_CARDS_IN_SLOT and not is_protected(player_found , card_being_dragged):
				resolve_card_cost_health_money(player_found, card_being_dragged.get_parent().get_parent(), $"../Deck".get_card_info(card_being_dragged.name_of_card))
				
				card_being_dragged.rotation = card_slot_found.rotation + card_slot_found.get_parent().rotation
				var displacement = card_slot_found.cards_in_slot.size() * SUBSEQUENT_CARD_DISPLACEMENT.rotated(card_being_dragged.rotation)
				card_being_dragged.global_position = card_slot_found.global_position + displacement
				card_being_dragged.card_slot_of_card = card_slot_found
				card_slot_found.cards_in_slot.append(card_being_dragged)
				
				card_being_dragged.scale = Vector2(CARD_ON_SLOT_SCALE, CARD_ON_SLOT_SCALE)
				card_being_dragged.z_index = 0
				card_being_dragged.flip_card(true)

				card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
			else:
				card_being_dragged.get_parent().add_card_to_hand(card_being_dragged, FINISH_DRAG_SPEED)
		else:
			card_being_dragged.get_parent().add_card_to_hand(card_being_dragged, FINISH_DRAG_SPEED)
	else:
		card_being_dragged.get_parent().add_card_to_hand(card_being_dragged, FINISH_DRAG_SPEED)
	card_being_dragged = null

func is_protected(player_node , card_being_dragged):
	var card_slot_nodes = player_node.get_node("CardSlots").get_children()
	for card_slot_node in card_slot_nodes:
		for card in card_slot_node.cards_in_slot:
			
			var effect = $"../Deck".get_card_info(card.name_of_card)[4]
			print("effect", effect)
			if effect and effect.split(" ")[0]=="proteger" and effect.split(" ")[1] == card_being_dragged.card_type:
				return true
	return false

func get_player_card_slot(player):
	for node in player.get_node("CardSlots").get_children():
		if node.card_slot_type == CardDataBase.CARDS[card_being_dragged.name_of_card][0]:
			return node
	return null
	
func card_is_affordable():
	if $"../PlayerManager".get_stats(card_being_dragged.get_parent().get_parent())[0] >= $"../Deck".get_card_info(card_being_dragged.name_of_card)[1]:
		return true
	else:
		return false

func resolve_card_cost_health_money(target_player, casting_player, card_info):
	$"../PlayerManager".set_stats(
	casting_player,
	-card_info[1],
	0) 
 #Apply card effects
	$"../PlayerManager".set_stats(
		target_player,
		card_info[2],
		card_info[3])
	card_being_dragged.get_parent().remove_card_from_hand(card_being_dragged, FINISH_DRAG_SPEED)

func resolve_card_effects(target_player, current_player, effect):
	print("target_player ", target_player)
	print("current_player ", current_player)
	print("effect ", effect)
	if effect:
		if effect.split(" ")[0]=="eliminar":
			for node in target_player.get_node("CardSlots").get_children():
				if node.card_slot_type == effect.split(" ")[1]:
					if node.cards_in_slot.size()>0:
						var card_ref = node.cards_in_slot[-1]
						card_ref.queue_free()
						node.cards_in_slot.erase(card_ref)
		elif effect.split(" ")[0]=="transferir":
			var max_spots_available
			var target_card_slot
			for node in target_player.get_node("CardSlots").get_children():
				if node.card_slot_type == effect.split(" ")[1]:
					max_spots_available = MAX_CARDS_IN_SLOT-node.cards_in_slot.size()
					target_card_slot = node
					
			for node in current_player.get_node("CardSlots").get_children():
				if node.card_slot_type == effect.split(" ")[1]:
					if node.cards_in_slot.size()>0:
						var amount_cards_to_pass = min(node.cards_in_slot.size(), max_spots_available)
						for card_number in range(amount_cards_to_pass):
							var this_card = node.cards_in_slot[-1] #maybe i need -card_number too
							#remove from slot, then add to target card_slot
							node.cards_in_slot.erase(this_card)
							
							this_card.rotation = target_card_slot.rotation + target_card_slot.get_parent().rotation
							var displacement = target_card_slot.cards_in_slot.size() * SUBSEQUENT_CARD_DISPLACEMENT.rotated(this_card.rotation)
							this_card.global_position = target_card_slot.global_position + displacement
							this_card.card_slot_of_card = target_card_slot
							target_card_slot.cards_in_slot.append(this_card)
				
				card_being_dragged.scale = Vector2(CARD_ON_SLOT_SCALE, CARD_ON_SLOT_SCALE)
							
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
	parameters.collision_mask = COLLISION_MASK_CARD
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
	if card.has_method("_on_area_2d_mouse_entered"):
		if hovered:
			card.scale=Vector2(DEFAULT_HIGHLIGHT_SCALE,DEFAULT_HIGHLIGHT_SCALE)
			card.z_index = 2
		else:
			card.scale=Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
			card.z_index = 1

func highlight_player(player_highlighted, highlighted):
	if player_highlighted:
		player_highlighted.get_node("HighlightRect").visible = highlighted
	
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
