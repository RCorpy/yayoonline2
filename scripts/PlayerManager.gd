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

func _ready():
	if FirebaseData.playing_IA:
		players = [FirebaseData.player_id, "IA1", "IA2", "IA3"]
	else:
		#get all the players, order them
		players = [FirebaseData.player_id]
	current_turn = -1
	local_player_index = players.find(FirebaseData.player_id)
	next_turn()
	update_values()

func next_turn():
	current_turn += 1
	current_player = players[current_turn % players.size()]
	if current_turn != 0:
		$"../Deck".draw_card(get_current_player_node())
	
	#if FirebaseData.player_id == current_player:
	#	$"../EndTurnButton".disabled = false

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
	next_turn()
