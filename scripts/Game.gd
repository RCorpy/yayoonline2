extends Node2D

const TOTAL_PLAYERS = 4
var game_started = false
var players = {}
var local_player = FirebaseData.player_status[FirebaseData.player_id].name
var player_order = []

func _on_ready() -> void:
	if game_started:
		start_board()
	else:
		if FirebaseData.playing_IA:
			players = {
				"IA1":{"ready": "ready"},
				"IA2":{"ready": "ready"},
				"IA3":{"ready": "ready"},
				local_player:{"ready": "not ready"}
			}
			show_players()
			#$NameText.visible = false
			#$Container.visible = false
		else:
			#listen for new players
			FirebaseData.connect("gamerooms_ref_updated", Callable(self, "_gamerooms_data_updated"))
			#get game room, checking if you are in group
			if not FirebaseData.gamerooms_data.has(FirebaseData.player_room):
				print("game not found ", FirebaseData.player_room)
				get_tree().change_scene_to_file("res://scenes/Control.tscn")
			else:
				print("joining room ", FirebaseData.player_room)
				players = FirebaseData.gamerooms_data[FirebaseData.player_room].players
			#load the existing players
			print("updating players because on ready")
			show_players()
			$NameText.text = FirebaseData.player_status[FirebaseData.player_id].name
	
	#if players == 4 do a readycheck
func _gamerooms_data_updated(data):
	#maybe we need to stop the timer sometimes	
	if FirebaseData.gamerooms_data.has(FirebaseData.player_room):
		players = FirebaseData.gamerooms_data[FirebaseData.player_room].players
		#print("show_players updated")
		show_players()
	else:
		get_tree().change_scene_to_file("res://scenes/Control.tscn")

func show_players():
	var TextEditText = "Game Room \n Players:\n"
	var all_ready = true
	if FirebaseData.playing_IA:
		for player in players.keys():
			TextEditText+=player
			if players[player].ready == "ready":
				TextEditText+=" V"+"\n"
			else:
				TextEditText+=" X"+"\n"
				all_ready = false
	else:
		for player in players.keys():
			TextEditText+=(FirebaseData.player_status[player].name)
			if FirebaseData.gamerooms_data[FirebaseData.player_room].players[player].ready == "ready":
				TextEditText+=" V"+"\n"
			else:
				TextEditText+=" X"+"\n"
				all_ready = false
	$Container/TextEdit.text = TextEditText

	if players.keys().size()>3:
		if players.keys().size()>4:
			print("mas de 4 jugadores, nos hemos pasado")
		$Container/ReadyButton.disabled = false
		$Container/ReadyButton.visible = true
		$Timer.start()
	else: 
		$Container/ReadyButton.visible = false
		$Container/ReadyButton.disabled = true
		$Container/KickNotReady.visible = false
		$Container/KickNotReady.disabled = true
		
	if all_ready:
		game_started = true
		start_board()
		
func start_board():
	print("started board")
	#hide previous shit
	$Container.visible = false
	#decide order of players
	if FirebaseData.playing_IA:
		set_IAgame_info()
	else:
		set_game_info()
	#start drawing new shit
	$GameContainer.visible = true
	#apply character variables
	
func set_IAgame_info():
	FirebaseData.game_info = {
		"player_order": [local_player, "IA1", "IA2", "IA3"],
		"turn": 1,
		"wealth":{
			local_player:0,
			"IA1":0,
			"IA2":0,
			"IA3":0
			},
		"life_expectancy":{
			local_player:10,
			"IA1":10,
			"IA2":10,
			"IA3":10
			},
		"propierties":{
			local_player:0,
			"IA1":0,
			"IA2":0,
			"IA3":0
			},
		"pets":{
			local_player:0,
			"IA1":0,
			"IA2":0,
			"IA3":0
			},
		"granchildren":{
			local_player:0,
			"IA1":0,
			"IA2":0,
			"IA3":0
			},
		"plants":{
			local_player:0,
			"IA1":0,
			"IA2":0,
			"IA3":0
			},
	}

func set_game_info():
	#do the same as with IA but only once, only the player that should move first should set the game
	pass
	
func _on_timer_timeout():
	#Allow votekick
	if $Container/ReadyButton.disabled:
		$Container/KickNotReady.visible = true
		$Container/KickNotReady.disabled = false
	
func on_game_start():
	pass
	#give turn order
	
	#draw cards

func _on_leave_room_button_pressed() -> void:
	#remove player from rooms data
	#FirebaseData.trying_shit()
	print(FirebaseData.player_status)
	print(FirebaseData.gamerooms_data)
	FirebaseData.remove_player_from_room()
	#gamerooms_ref[player_status[player_id].room].players.erase(player_id)
	#remove player data of rooms and queue
	players={}
	#db_ref.update(player_id, {'room': null, 'queue': null, 'position': 999})
	#go to control screen
	FirebaseData.player_room = ""
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/Control.tscn")

func _on_ready_button_pressed():
	#print("readybutton pressed")
	#send signal to agree to readycheck
	if FirebaseData.playing_IA:
		players[local_player].ready = "ready"
		show_players()
	else:
		FirebaseData.player_is_ready()
		
		$Container/ReadyButton.disabled = true

func _on_kick_not_ready_pressed():
	FirebaseData.kick_non_ready_players_and_reset_readys()
	$Container/ReadyButton.visible = false
	$Container/ReadyButton.disabled = true
	$Container/KickNotReady.visible = false
	$Container/KickNotReady.disabled = true


func _on_end_game_button_pressed() -> void:
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/Control.tscn")
