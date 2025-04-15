extends Node

var player_status: Dictionary = {}
var gamerooms_data: Dictionary = {}
var player_id = ""
var player_room = ""
var db_ref
var gamerooms_ref
var go_to = ""


signal db_ref_updated
signal gamerooms_ref_updated
signal move_to

func _ready():
	pass

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:  #Both App minimized
		print("App is going to background, saving data...")
		#remove player from room
		#remove_player_from_room()	
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:  # Android User presses back button
		print("Back button pressed! Saving data...")
		#remove player from room
		remove_player_from_room()
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:  # Windows: Closing window
		print("Windows: Game is closing! Saving data...")
		#remove player from room
		remove_player_from_room()
		
func get_firebase_ready():
	db_ref = Firebase.Database.get_database_reference("player_status")
	gamerooms_ref = Firebase.Database.get_database_reference("game_rooms")
	
	db_ref.new_data_update.connect(player_status_data_updated)
	db_ref.patch_data_update.connect(player_status_data_updated)
	gamerooms_ref.new_data_update.connect(gamerooms_data_updated)
	gamerooms_ref.patch_data_update.connect(gamerooms_data_updated)

func get_player_id():
	player_id = Firebase.Auth.auth.localid

func player_status_data_updated(data):
	player_status = db_ref.get_data()
	#db_ref_updated.emit(player_status)
	emit_signal("db_ref_updated", player_status)
	#print("player_status updated")
		
func gamerooms_data_updated(data):
	var path = data.key.split("/", true)
	print("gamerooms_data_updated",data)
	if path.size() == 2:
		for value in data.data:
			if data.data[value] == null:
				print("path[0]", path[0], "path[1]", path[1], "value", value)
				gamerooms_data[path[0]][path[1]].erase(value)
			else:
				gamerooms_data[path[0]][path[1]] = value
		emit_signal("gamerooms_ref_updated", gamerooms_data)
	elif data.data == null:
		gamerooms_data.erase(data.key)
	elif data.key == "":
		pass
	else:
		gamerooms_data = gamerooms_ref.get_data()
		emit_signal("gamerooms_ref_updated", gamerooms_data)
		if go_to != "":
			emit_signal("move_to", go_to)
	#print("gamerooms_data updated")


func get_player_room():
	for room in gamerooms_data.keys():
		if room != "games_played" and gamerooms_data[room].players.has(player_id):
			player_room = room

func add_player_to_room(room, move):
	player_room = room
	go_to = move
	if gamerooms_data.has(room):
		#print("creating new player on room")
		var players_in_room = gamerooms_data[room].players
		#print("\n players_in_room\n ", players_in_room)
		players_in_room[player_id] = "not ready"
		gamerooms_ref.update(room, {"players" : players_in_room})
	else:
		#print("creating first player on room")
		#print("room and player_id", room, player_id)
		gamerooms_ref.update(room, {'players':{player_id:"not ready"}})
	
func remove_player_from_room():
	if gamerooms_data.has(player_room) and player_room.left(8)  == "gameroom":
		#print("removing player on room", player_room)
		#print("\n", gamerooms_data[player_room].players)
		var players_in_room = gamerooms_data[player_room].players
		#players_in_room.erase(player_id)
		#print("players_in_room: ", players_in_room)
		for player in players_in_room:
			players_in_room[player] = "not ready"
		players_in_room[player_id] = null
		#print("players_in_room", players_in_room)
		if players_in_room.keys().size()<=1:
			#print("empty!, removing room")
			erase_room(player_room)
		else:
			#print("not empty! removing ", player_id)
			var path = player_room + "/players"
			gamerooms_ref.update(path, players_in_room)
			#gamerooms_ref.update(path, {player: null})
	player_room = ""
	#print("emiting signal", gamerooms_data)
	emit_signal("gamerooms_ref_updated", gamerooms_data)

func player_is_ready():
	if gamerooms_data.has(player_room) and player_room.left(8)  == "gameroom":
		var path = player_room + "/players"
		gamerooms_ref.update(path, {player_id: "ready"})
		
func erase_room(room):
	#maybe it erases all rooms :V
	gamerooms_ref.update("", {room: null})
	#emit_signal("gamerooms_ref_updated", gamerooms_data)

func kick_non_ready_players_and_reset_readys():
	var new_room = {}
	for player in gamerooms_data[player_room].players.keys():
		print("PLAYER READY?", gamerooms_data[player_room].players[player])
		if gamerooms_data[player_room].players[player] != "ready":
			new_room[player] = null
		else:
			new_room[player] = "not ready"
			
	var path = player_room + "/players"
	print("new room: ", new_room)
	gamerooms_ref.update(path, new_room)
