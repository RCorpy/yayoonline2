extends Node2D

var players = []



	
func _on_ready() -> void:
	#get game room, checking if you are in group
	if FirebaseData.player_room == "":
		print("game not found ", FirebaseData.player_room)
		get_tree().change_scene_to_file("res://Control.tscn")
	else:
		print("joining room ", FirebaseData.player_room)
	
	#load the existing players
	
	#listen for new players
	
	#if players == 4 do a readycheck
	
	pass

func on_game_start():
	pass
	#give turn order
	
	#draw cards



func _on_leave_room_button_pressed() -> void:
	#remove player from rooms data
	#FirebaseData.trying_shit()
	print(FirebaseData.player_status)
	print(FirebaseData.gamerooms_data)
	#gamerooms_ref[player_status[player_id].room].players.erase(player_id)
	#remove player data of rooms and queue
	#db_ref.update(player_id, {'room': null, 'queue': null, 'position': 999})
	#go to control screen
	get_tree().change_scene_to_file("res://Control.tscn")
