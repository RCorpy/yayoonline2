extends Node2D

var PlayerHealth = 10
var Opponent1Health = 10
var Opponent2Health = 10
var Opponent3Health = 10

var PlayerCoins = 2
var Opponent1Coins = 2
var Opponent2Coins = 2
var Opponent3Coins = 2

var players
var current_turn
var current_player
var local_player_index
var character_skills
	#loading enriqueta by default now
const character_skills_ref = preload("res://card_effects/ENRIQUETA.gd")

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
	current_player = players[current_turn % players.size()]
	
	if current_turn % players.size() == 0:
		character_skills.character_ability(self)
		#EVENT CARD TIME
		pass
	
	$TurnTimer.start()
	if current_turn != 0:
		var turn_player_node = get_current_player_node()
		#draw a card
		$"../Deck".draw_card(turn_player_node)
		#remove 1 health, player got older, recieve pension $
		set_stats(turn_player_node,1,-1)
	
	if FirebaseData.player_id == current_player:
		$"../EndTurnButton".disabled = false
	else:
		$"../EndTurnButton".disabled = true

func get_current_player_node():
	match current_turn % players.size() - local_player_index:
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
		print(get_player_from_node(player_node.name) , " WON THE GAME")
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
	print("its local?", FirebaseData.player_id == current_player, "    ", current_player, "   ", FirebaseData.player_id )
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
	$"../WinScreen".visible = true
	$TurnTimer.stop()
	$"../EndTurnButton".disabled = true
