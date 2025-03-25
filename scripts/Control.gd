extends Control

var player_status: Dictionary = {}
var gamerooms_data: Dictionary = {}
var player_id = ""
var db_ref = Firebase.Database.get_database_reference("player_status")
var gamerooms_ref = Firebase.Database.get_database_reference("game_rooms")
# Called when the node enters the scene tree for the first time.
func _ready():
	FirebaseData.get_firebase_ready()
	FirebaseData.get_player_id()
	
	player_id = Firebase.Auth.auth.localid
	# connect both signals to data_updated instead,
	# if you don't want to deal with the parsing in new_data_udpate and patch_data_update
	db_ref.new_data_update.connect(new_data_updated)
	db_ref.patch_data_update.connect(patch_data_updated)
	gamerooms_ref.new_data_update.connect(gamerooms_data_updated)
	gamerooms_ref.patch_data_update.connect(gamerooms_data_updated)

		
		
func _process(delta):
	pass
	
func gamerooms_data_updated(data):
	
	gamerooms_data = gamerooms_ref.get_data()
		#IF PLAYER SHOULD BE IN A ROOM, GO TO THAT ROOM
	for room in gamerooms_data.keys():
		if room != "games_played" and gamerooms_data[room].players.has(player_id):
			#cant access get_tree() yet, so just change button text
			$VBoxContainer2/PlaySoloButton.text = "Rejoin"
	
func go_to_game():
	get_tree().change_scene_to_file("res://Game.tscn")
	
func data_updated(data):
	player_status = db_ref.get_data()
	update_player_list()
	print("DATA_UPDATED FUNCTION -> i will never run!")

func new_data_updated(data):

	var path = data.key.split("/", true)
	if path.size() > 1:
		if data.data:
			# When a field is updated from the *console*, for example change the name of a player to Amy
			# {key:player_id/name, data:"Amy"}
			player_status[path[0]][path[1]] = data.data
		else:
			# When a field is deleted (not possible from this app, but possible on console), for example deleted the status field
			# {key:player_id/status, data:<null>}
			player_status[path[0]].erase(path[1])
	else:
		if data.data:
			# When first connected to the database
			# {key:player_id, data:{ "name": "Bob", "status": "Happy"}
			player_status[path[0]] = data.data
		else:
			# When a player is deleted (not possible from this app, but possible on console)
			# {key: player_id, data:<null>}
			player_status.erase(path[0])
			
	update_player_list()
	
func patch_data_updated(data):
	
	if data.key.is_empty():
		# When a new player is added to the player_status, the data.key will be empty. The actual "player_id" key will be in data.data:
		# example: {key:, data:{ "new_player_id": {"name":"Bob", "status": "Angry"}
		for key in data.data.keys():
			player_status[key] = data.data[key]
			
	else:
		var path = data.key.split("/", true)
		if path.size() > 1:
			# Seems that no case falls here, but we have this implemented anyway for good measure
			for key in data.data.keys():
				player_status[path[0]][path[1]][key] = data.data[key]
		else:
			# When a player updates a field (from this app), for example, Bob changed his status from Happy to Angry, the name stays the same
			# {key: player_id, data: {"status": "Angry"}
			# When a player updates a field (from this app), for example, Bob changed his status from Happy to Angry, the name from Bob to Amy
			# {key: player_id, data: {"name": "Amy", "status": "Angry"}
			if player_status.has(path[0]):
				for key in data.data.keys():
					player_status[path[0]][key] = data.data[key]
			else:
				player_status[path[0]] = data.data
			
	update_player_list()

func update_player_list():
	var list = "Players' on queue:\n"
	for key in player_status.keys():
		if player_status[key].has('queue') and player_status[key].queue:
			var cur_player_status = player_status[key]
			var name = "anonymous"
			if cur_player_status.has('name') and !cur_player_status.name.is_empty():
				name = cur_player_status.name
				if key == player_id and %NameLineEdit.text.is_empty():
					%NameLineEdit.text = name
				
			var status = "unknown"
			if cur_player_status.has('status') and !cur_player_status.status.is_empty():
				status = cur_player_status.status
				if key == player_id and %StatusLineEdit.text.is_empty():
					%StatusLineEdit.text = status
					
			list +=name+" ("+status+") "+str(cur_player_status.position).split(".")[0]+"\n" #chapuza para quitar la coma
		
	%PlayerListLabel.text = list

func _on_update_button_pressed():
	db_ref.update(player_id, {'name': %NameLineEdit.text, 'status': %StatusLineEdit.text})


func _on_logout_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://Authentication.tscn")



func queue_data_updated():
	pass

func calculate_position():
	if player_status.has(player_id) and player_status[player_id].has('position') and player_status[player_id].position <990:
		return player_status[player_id].position
	var position = 1
	for player in player_status.keys():
		if player_status[player].has('queue') and player_status[player].queue and player_id != player:
			position += 1
	return position

func _on_play_solo_button_pressed() -> void:
	#get into qeue
	
	#Are we already on a room?
	for room in gamerooms_data.keys():
		if room != "games_played" and gamerooms_data[room].players.has(player_id):
			print("going to my game")
			go_to_game()
			return
			
	#get all rooms and see the first one that fits (getting the data automatic in gamerooms_data_updated)
	
	#create room if there are no rooms
	if gamerooms_data.keys().size() == 1:
		print("creating room since there are no rooms")
		var new_room_number = "gameroom1"
		gamerooms_ref.update(new_room_number, {'players':{player_id:"not ready"}})
	#if there are rooms existing, try to join the first one that hasnt got 4 players
	else:
		var room_found = false
		for room in gamerooms_data.keys():
			if room != "games_played" and not room_found:
				if gamerooms_data[room].keys().size()<4:
					print("joining room since we fit", room)
					room_found = true
					gamerooms_ref.update(room, {'players':{player_id:"not ready"}})
		#if you still havent found a room, create a new room (maybe they are full and playing already)
		if not room_found:
			print("creating room since all other rooms are full")
			var new_room_number = "gameroom" + str(gamerooms_data.keys().size())
			gamerooms_ref.update(new_room_number, {'players':{player_id:"not ready"}})
			
	#show queue position for some reason
	db_ref.update(player_id, {'queue': true, 'position': calculate_position()})
	
	#go to game
	print("going to game")
	go_to_game()


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
