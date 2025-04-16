extends Node2D

var players = {}



	
func _on_ready() -> void:
	#listen for new players
	FirebaseData.connect("gamerooms_ref_updated", Callable(self, "_gamerooms_data_updated"))
	
	#get game room, checking if you are in group
	if not FirebaseData.gamerooms_data.has(FirebaseData.player_room):
		print("game not found ", FirebaseData.player_room)
		get_tree().change_scene_to_file("res://Control.tscn")
	else:
		print("joining room ", FirebaseData.player_room)
		players = FirebaseData.gamerooms_data[FirebaseData.player_room].players
	#load the existing players
	print("updating players because on ready")
	show_players()

	
	#if players == 4 do a readycheck
	
func _gamerooms_data_updated(data):
	#maybe we need to stop the timer sometimes	
	if FirebaseData.gamerooms_data.has(FirebaseData.player_room):
		players = FirebaseData.gamerooms_data[FirebaseData.player_room].players
		#print("show_players updated")
		show_players()
	else:
		_on_leave_room_button_pressed()

func show_players():
	var TextEditText = "Game Room \n Players:\n"
	for player in players.keys():
		TextEditText+=(player+"\n")
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
	get_tree().change_scene_to_file("res://Control.tscn")


func _on_ready_button_pressed():
	#print("readybutton pressed")
	#send signal to agree to readycheck
	FirebaseData.player_is_ready()
	
	$Container/ReadyButton.disabled = true


func _on_kick_not_ready_pressed():
	FirebaseData.kick_non_ready_players_and_reset_readys()
	$Container/ReadyButton.visible = false
	$Container/ReadyButton.disabled = true
	$Container/KickNotReady.visible = false
	$Container/KickNotReady.disabled = true
