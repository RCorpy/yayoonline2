extends Control

var player_status: Dictionary = {}
var gamerooms_data: Dictionary = {}



# Called when the node enters the scene tree for the first time.
func _ready():
	FirebaseData.connect("gamerooms_ref_updated", Callable(self, "_gamerooms_data_updated"))
	FirebaseData.connect("db_ref_updated", Callable(self, "_player_status_updated"))
	FirebaseData.connect("move_to", Callable(self, "_on_move_to"))
	FirebaseData.get_player_id()
	if gamerooms_data.is_empty():
		FirebaseData.get_firebase_ready()
		
	
	
	#player_id = Firebase.Auth.auth.localid
	# connect both signals to data_updated instead,
	# if you don't want to deal with the parsing in new_data_udpate and patch_data_update
	#db_ref.new_data_update.connect(new_data_updated)
	#db_ref.patch_data_update.connect(patch_data_updated)
	#gamerooms_ref.new_data_update.connect(gamerooms_data_updated)
	#gamerooms_ref.patch_data_update.connect(gamerooms_data_updated)

func _on_tree_exited() -> void:
	if FirebaseData.is_connected("gamerooms_ref_updated", Callable(self, "_gamerooms_data_updated")):
		FirebaseData.disconnect("gamerooms_ref_updated", Callable(self, "_gamerooms_data_updated"))
	if FirebaseData.is_connected("db_ref_updated", Callable(self, "_player_status_updated")):
		FirebaseData.disconnect("db_ref_updated", Callable(self, "_player_status_updated"))
	if FirebaseData.is_connected("move_to", Callable(self, "_on_move_to")):
		FirebaseData.disconnect("move_to", Callable(self, "_on_move_to"))
		
func _on_move_to(room):
	print("signal recieved moving to room", room)
	if room == "game":
		go_to_game()
	FirebaseData.go_to = ""

func _player_status_updated(data):
	pass
	#print("player_status_updated")
	#print(data)
		
func _gamerooms_data_updated(data):
	FirebaseData.get_player_room()
	if FirebaseData.player_room != "":
#			cant access get_tree() yet, so just change button text
		$VBoxContainer2/PlaySoloButton.text = "Rejoin"

	
func go_to_game():
	get_tree().change_scene_to_file("res://Game.tscn")



func _on_update_button_pressed():
	FirebaseData.db_ref.update(FirebaseData.player_id, {'name': %NameLineEdit.text, 'status': %StatusLineEdit.text})


func _on_logout_button_pressed():
	Firebase.Auth.logout()
	FirebaseData.remove_player_from_room()
	FirebaseData.player_id = ""
	
	get_tree().change_scene_to_file("res://Authentication.tscn")

	

	

func calculate_position():
	if FirebaseData.player_status.has(FirebaseData.player_id) and FirebaseData.player_status[FirebaseData.player_id].has('position') and FirebaseData.player_status[FirebaseData.player_id].position <990:
		return FirebaseData.player_status[FirebaseData.player_id].position
	var position = 1
	for player in FirebaseData.player_status.keys():
		if FirebaseData.player_status[player].has('queue') and FirebaseData.player_status[player].queue and FirebaseData.player_id != player:
			position += 1
	return position

func _on_play_solo_button_pressed() -> void:
	#get into qeue
	
	#Are we already on a room?
	if FirebaseData.player_room != "":
		print("going to my game")
		go_to_game()
		return
			
	#get all rooms and see the first one that fits (getting the data automatic in gamerooms_data_updated)
	
	#if we find 0 the program didnt load the dictionaries, it should, we disconnect for now to avoid errors
	if FirebaseData.gamerooms_data.keys().size() == 0:
		_on_logout_button_pressed()
	#create room if there are no rooms
	if FirebaseData.gamerooms_data.keys().size() == 1:
		print("creating room since there are no rooms")
		var new_room_number = "gameroom1"
		FirebaseData.add_player_to_room(new_room_number, "game")
		
	#if there are rooms existing, try to join the first one that hasnt got 4 players
	else:
		var room_found = false
		for room in FirebaseData.gamerooms_data.keys():
			if room != "games_played" and not room_found:
				if FirebaseData.gamerooms_data[room].keys().size()<4:
					print("joining room since we fit", room)
					room_found = true
					FirebaseData.add_player_to_room(room,"game")
					
		#if you still havent found a room, create a new room (maybe they are full and playing already)
		if not room_found:
			print("creating room since all other rooms are full gameroom")
			var new_room_number = "gameroom" + str(FirebaseData.gamerooms_data.keys().size())
			
			FirebaseData.add_player_to_room(new_room_number, "game")
			
			
	#go to game
	print("going to game")
	


func create_room():
	pass

func _on_group_up_butoon_pressed() -> void:
	##get_tree().change_scene_to_file("res://GroupUp.tscn")
	pass # Replace with function body.


func _on_tutorial_pressed() -> void:
	#get_tree().change_scene_to_file("res://Game.tscn")
	pass # Replace with function body.


func _on_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Game.tscn")
	pass # Replace with function body.


#func new_data_updated(data):
#
#	var path = data.key.split("/", true)
#	if path.size() > 1:
#		if data.data:
#			# When a field is updated from the *console*, for example change the name of a player to Amy
#			# {key:player_id/name, data:"Amy"}
#			player_status[path[0]][path[1]] = data.data
#		else:
#			# When a field is deleted (not possible from this app, but possible on console), for example deleted the status field
#			# {key:player_id/status, data:<null>}
#			player_status[path[0]].erase(path[1])
#	else:
#		if data.data:
#			# When first connected to the database
#			# {key:player_id, data:{ "name": "Bob", "status": "Happy"}
#			player_status[path[0]] = data.data
#		else:
#			# When a player is deleted (not possible from this app, but possible on console)
#			# {key: player_id, data:<null>}
#			player_status.erase(path[0])
#			
#	update_player_list()
	
#func patch_data_updated(data):
#	
#	if data.key.is_empty():
#		# When a new player is added to the player_status, the data.key will be empty. The actual "player_id" key will be in data.data:
#		# example: {key:, data:{ "new_player_id": {"name":"Bob", "status": "Angry"}
#		for key in data.data.keys():
#			player_status[key] = data.data[key]
#			
#	else:
#		var path = data.key.split("/", true)
#		if path.size() > 1:
#			# Seems that no case falls here, but we have this implemented anyway for good measure
#			for key in data.data.keys():
#				player_status[path[0]][path[1]][key] = data.data[key]
#		else:
#			# When a player updates a field (from this app), for example, Bob changed his status from Happy to Angry, the name stays the same
#			# {key: player_id, data: {"status": "Angry"}
#			# When a player updates a field (from this app), for example, Bob changed his status from Happy to Angry, the name from Bob to Amy
#			# {key: player_id, data: {"name": "Amy", "status": "Angry"}
#			if player_status.has(path[0]):
#				for key in data.data.keys():
#					player_status[path[0]][key] = data.data[key]
#			else:
#				player_status[path[0]] = data.data
#			
#	update_player_list()
