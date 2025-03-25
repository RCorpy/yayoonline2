extends Node

var player_status: Dictionary = {}
var gamerooms_data: Dictionary = {}
var player_id = ""
var db_ref
var gamerooms_ref

func _ready():
	pass


func get_firebase_ready():
	print("firebase ready")
	db_ref = Firebase.Database.get_database_reference("player_status")
	gamerooms_ref = Firebase.Database.get_database_reference("game_rooms")
	
	db_ref.new_data_update.connect(player_statys_data_updated)
	db_ref.patch_data_update.connect(player_statys_data_updated)
	gamerooms_ref.new_data_update.connect(gamerooms_data_updated)
	gamerooms_ref.patch_data_update.connect(gamerooms_data_updated)

func get_player_id():
	player_id = Firebase.Auth.auth.localid

func player_statys_data_updated(data):
	player_status = db_ref.get(data)
	print(player_status)
		
func gamerooms_data_updated(data):
	
	gamerooms_data = gamerooms_ref.get_data()
#		#IF PLAYER SHOULD BE IN A ROOM, GO TO THAT ROOM
#	for room in gamerooms_data.keys():
#		if room != "games_played" and gamerooms_data[room].players.has(player_id):
#			#cant access get_tree() yet, so just change button text
#			$VBoxContainer2/PlaySoloButton.text = "Rejoin"
	print(gamerooms_data)
