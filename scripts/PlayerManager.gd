extends Node2D

var PlayerHealth = 10
var Opponent1Health = 10
var Opponent2Health = 10
var Opponent3Health = 10

var PlayerCoins = 2
var Opponent1Coins = 2
var Opponent2Coins = 2
var Opponent3Coins = 2

var winner
var players
var current_turn
var current_player
var current_player_index
var local_player_index
var character_skills
	#loading enriqueta by default now
const character_skills_ref = preload("res://card_effects/ENRIQUETA.gd")
const IA_WAIT_TIME = 2 #WTF si lo cambio a mas o menos empiezan a salir errores de posicionamientos

func _ready():
	character_skills = character_skills_ref.new()
	
	if FirebaseData.playing_IA:
		players = [FirebaseData.player_id, "IA1", "IA2", "IA3"]
	else:
		#get all the players, order them
		players = [FirebaseData.player_id]
	local_player_index = players.find(FirebaseData.player_id)
	next_turn(0)
	update_values()


func works():
	print("it does work")

func next_turn(turn):
	
	current_turn = turn
	current_player_index = current_turn % players.size()
	current_player = players[current_player_index]
	
	if current_turn % players.size() == 0:
		character_skills.character_ability(self)
		#EVENT CARD TIME
		pass
	if not winner:
		$TurnTimer.start()
	if current_turn != 0:
		var turn_player_node = get_player_node(current_turn % players.size() - local_player_index)
		#draw a card
		$"../Deck".draw_card(turn_player_node)
		#remove 1 health, player got older, recieve pension $
		var total_pension = turn_player_node.get_node("CardSlots").get_node("CardSlot4").cards_in_slot.size() + 1
		set_stats(turn_player_node,total_pension,-1)
	
	if FirebaseData.player_id == current_player:
		$"../EndTurnButton".disabled = false
	else:
		$"../EndTurnButton".disabled = true
		if current_player.left(2)=="IA" and current_player.length() == 3 and not winner:
			await get_tree().create_timer(IA_WAIT_TIME).timeout
			IA_decision()
			

func get_player_node(player_index):
	match player_index:
		0:
			return $"../Player"
		1:
			return $"../Opponent1"
		2:
			return $"../Opponent2"
		3:
			return $"../Opponent3"

func update_values():
	#player values
	$"../Player/Resources/CoinsText".text = str(PlayerCoins)
	$"../Player/Resources/HealthText".text = str(PlayerHealth)
	#Opponent1 values
	$"../Opponent1/Resources/CoinsText".text = str(Opponent1Coins)
	$"../Opponent1/Resources/HealthText".text = str(Opponent1Health)
	#Opponent2 values
	$"../Opponent2/Resources/CoinsText".text = str(Opponent2Coins)
	$"../Opponent2/Resources/HealthText".text = str(Opponent2Health)
	#Opponent3 values
	$"../Opponent3/Resources/CoinsText".text = str(Opponent3Coins)
	$"../Opponent3/Resources/HealthText".text = str(Opponent3Health)
	
	
func set_stats(player_node, amount_money ,amount_health ):
	var player = player_node.name
	match player:
		"Player":
			PlayerCoins += amount_money
			PlayerHealth += amount_health
		"Opponent1":
			Opponent1Coins += amount_money
			Opponent1Health += amount_health
		"Opponent2":
			Opponent2Coins += amount_money
			Opponent2Health += amount_health
		"Opponent3":
			Opponent3Coins += amount_money
			Opponent3Health += amount_health
		_:
			print("unknown player")
	update_values()
	if get_stats(player_node)[1] <= 0:
		player_win_screen(get_player_from_node(player_node.name))

func get_stats(parent_node):
	var player = parent_node.name
	match player:
		"Player":
			return [PlayerCoins, PlayerHealth]
		"Opponent1":
			return [Opponent1Coins, Opponent1Health]
		"Opponent2":
			return [Opponent2Coins, Opponent2Health]
		"Opponent3":
			return [Opponent3Coins, Opponent3Health]
		_:
			print("unknown player")


func _on_end_turn_button_pressed() -> void:
	next_turn(current_turn + 1)


func _on_turn_timer_timeout():
	if FirebaseData.playing_IA:
		next_turn(current_turn + 1)
	#can only pass the turn through timeout the next player
	elif FirebaseData.player_id == players[(current_turn+1) % players.size()]:
		next_turn(current_turn + 1)
		
func is_local_player_turn():
	return FirebaseData.player_id == current_player

func get_player_from_node(node):
	match node:
		"Player":
			return players[0]
		"Opponent1":
			return players[1]
		"Opponent2":
			return players[2]
		"Opponent3":
			return players[3]
		_:
			print("unknown player")

func player_win_screen(player):
	$"../EndGamePopUp".visible = true
	$TurnTimer.stop()
	$"../EndTurnButton".disabled = true
	$"../EndGamePopUp/Container/EndGame Button".disabled = false
	print("comparing", player, players[local_player_index])
	if player == players[local_player_index]:
		$"../EndGamePopUp/Container/EndGameText".text = "Congratulations, you won!"
	else:
		$"../EndGamePopUp/Container/EndGameText".text = "You lost, " + str(player) + " won"

func IA_decision():
	print("winner", winner)
	if current_player.length() != 3:
		return
	if not winner:
		var my_coins = get_stats(get_player_node(current_player_index))[0]
		var my_health = get_stats(get_player_node(current_player_index))[1]

		var opponent_healths = []
		
		for enemy_index in range(players.size()):
			var next_player_in_order = (current_player_index+enemy_index)%players.size()
			if not next_player_in_order == current_player_index:
				opponent_healths+= [[players[next_player_in_order], get_stats(get_player_node(next_player_in_order))[1]]]
		var cards = get_player_node(current_player_index).get_node("Hand").player_hand

		var card_to_use
		var card_to_use_score = 0
		var card_to_use_type 
		var card_to_use_target
		var card_to_use_health_gain
		var priority_target = null
		var secondary_target = current_player
		
		if my_health <= 2:
			priority_target = current_player
			
		for opponent in opponent_healths:
			if not priority_target:
				if opponent[1] <= 2:
					priority_target = opponent[0]
		
		if not priority_target:
			priority_target = current_player
			secondary_target = opponent_healths[0][0]
		
		for card in cards:
			var card_info = $"../Deck".get_card_info(card.name_of_card)
			
			if card_info[1] <= my_coins:  # Check if the AI can afford the card
				var card_type = card_info[0]
				var card_cost = card_info[1]
				var card_money_gain = card_info[2]
				var card_health_gain = card_info[3]
				var card_score = 1
				var use_on_self = card_health_gain < 0
				
				# If the card is a "propiedad", prioritize it 
				if card_type == "propiedad":
					card_score = 15
					use_on_self = true
					priority_target = current_player
					secondary_target = current_player
				
				# If the card has no health gain but provides money, AI might use it on itself
				if card_health_gain == 0 and card_money_gain > 0:
					use_on_self = true

				# Prioritize using on the AI if the card heals or benefits it and priority_target is the AI
				if use_on_self and priority_target == current_player:
					card_score += 5
				
				# If the card doesn't benefit the AI but helps the opponent, prioritize if the target is not the AI
				if not use_on_self and priority_target != current_player:
					card_score += 5
				
				# Add the card's health and money gain values to the score
				card_score += abs(card_health_gain) + card_money_gain
				
				# If the card heals the AI, avoid it completely (since healing should never be used on the AI)
				if card_health_gain > 0 and use_on_self:
					card_score = -1  # Don't select healing cards for the AI
				
				# Make sure the AI can handle the card in the given context (e.g., player node)
				if not can_handle_card(card, get_player_node(players.find(get_real_target(use_on_self, priority_target, secondary_target)))):
					card_score = -1  # Invalid card, don't select it
				
				#Objective might be protected
				if card_type == "nieto" or card_type == "planta" or card_type == "mascota":
					if is_protected(get_player_node(players.find(get_real_target(use_on_self, priority_target, secondary_target))), card):
						card_score = -1  # Invalid card, don't select it
					
				# Now, if this card is better than the previous card in terms of score, select it
				if card_score > card_to_use_score:
					card_to_use = card
					card_to_use_score = card_score
					card_to_use_target = get_real_target(use_on_self, priority_target, secondary_target)

		if card_to_use:
			#print("---------")
			#print("current_player: ", current_player)
			#print("card_to_use_score ", card_to_use_score)
			#print("card to use: ", card_to_use)
			#print("card to use: ", card_to_use.get_parent().get_parent())
			#print("card to use: ", card_to_use.name_of_card)
			#print("target ", card_to_use_target)
			#print("---------")
			
			handle_card(card_to_use, get_player_node(players.find(card_to_use_target)))

			await get_tree().create_timer(IA_WAIT_TIME).timeout
			IA_decision()
		else:
			next_turn(current_turn + 1)


func get_real_target(use_on_self, priority_target, secondary_target):
	if use_on_self:
		return current_player
	else:
		if priority_target == current_player:
			return secondary_target
		else:
			return priority_target
	
func get_player_card_slot(card, target_player):
	for node in target_player.get_node("CardSlots").get_children():
		if node.card_slot_type == CardDataBase.CARDS[card.name_of_card][0]:
			return node
	return null

func can_handle_card(card, target_player):
	if card.card_type == "spell" or card.card_type == "special":
		return true
	else:
		var card_slot_found = get_player_card_slot(card, target_player)
		if card_slot_found.cards_in_slot.size()<$"../CardManager".MAX_CARDS_IN_SLOT:
			return true
	return false

func handle_card(card, target_player):

	var card_slot_found = get_player_card_slot(card, target_player)
	
	if not card_slot_found:
		#HANDLE SPELLS AND SPECIALS
		resolve_card_cost_health_money(card, target_player, card.get_parent().get_parent(), $"../Deck".get_card_info(card.name_of_card))
		card.get_parent().remove_card_from_hand(card, $"../CardManager".FINISH_DRAG_SPEED)
		card.queue_free()
			
	elif card_slot_found.cards_in_slot.size()<$"../CardManager".MAX_CARDS_IN_SLOT:
			
		resolve_card_cost_health_money(card, target_player, card.get_parent().get_parent(), $"../Deck".get_card_info(card.name_of_card))

		

		card.rotation = card_slot_found.rotation + card_slot_found.get_parent().rotation
		var displacement = card_slot_found.cards_in_slot.size() * $"../CardManager".SUBSEQUENT_CARD_DISPLACEMENT.rotated(card.rotation)
		card.card_position = card_slot_found.global_position + displacement
		card.global_position = card_slot_found.global_position + displacement
		card.card_slot_of_card = card_slot_found
		card.get_parent().remove_card_from_hand(card, $"../CardManager".FINISH_DRAG_SPEED)
		card_slot_found.cards_in_slot.append(card)
		
		card.scale = Vector2($"../CardManager".CARD_ON_SLOT_SCALE, $"../CardManager".CARD_ON_SLOT_SCALE)
		card.z_index = 0
		card.flip_card(true)

		card.get_node("Area2D/CollisionShape2D").disabled = true
			
func resolve_card_cost_health_money(card, target_player, casting_player, card_info):
	set_stats(
	casting_player,
	-card_info[1],
	0) 
	set_stats(
		target_player,
		card_info[2],
		card_info[3]
		)
		
	if get_stats(target_player)[1] <= 0:
		winner = str(get_player_from_node(target_player))

func is_protected(player_node , card_being_dragged):
	var card_slot_nodes = player_node.get_node("CardSlots").get_children()
	for card_slot_node in card_slot_nodes:
		for card in card_slot_node.cards_in_slot:
			
			var effect = $"../Deck".get_card_info(card.name_of_card)[4]

			if effect and effect.split(" ")[0]=="proteger" and effect.split(" ")[1] == card_being_dragged.card_type:
				return true
	return false
