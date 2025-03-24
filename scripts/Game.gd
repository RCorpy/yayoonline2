extends Node2D

var player_status: Dictionary = {}
var gamerooms_data: Dictionary = {}

var db_ref = Firebase.Database.get_database_reference("player_status")
var gamerooms_ref = Firebase.Database.get_database_reference("game_rooms")
var player_id = ""
var players = []

func on_game_start():
	#identify player
	player_id = Firebase.Auth.auth.localid
	# connect both signals to data_updated instead,
	# if you don't want to deal with the parsing in new_data_udpate and patch_data_update
	db_ref.new_data_update.connect(db_ref_data_updated)
	db_ref.patch_data_update.connect(db_ref_data_updated)
	gamerooms_ref.new_data_update.connect(gamerooms_data_updated)
	gamerooms_ref.patch_data_update.connect(gamerooms_data_updated)
	#remove players from queue
	for player in players:
		db_ref.update(player, {'queue': false , 'position': 999})
	#give turn order
	
	#draw cards

func db_ref_data_updated(data):
	player_status = db_ref.get_data()
	
func gamerooms_data_updated(data):
	gamerooms_data = gamerooms_ref.get_data()
	
func _on_ready() -> void:
	#get game room, checking if you are in group
	
	#load the existing players
	
	#listen for new players
	
	#if players == 4 do a readycheck
	
	pass




func _on_leave_room_button_pressed() -> void:
	#remove player from rooms data
	gamerooms_ref[player_status[player_id].room].erase(player_id)
	#remove player data of rooms and queue
	db_ref.update(player_id, {'room': null, 'queue': null, 'position': 999})
	#go to control screen
	get_tree().change_scene_to_file("res://Control.tscn")
