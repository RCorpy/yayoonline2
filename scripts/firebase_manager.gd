extends Node

var db_ref = Firebase.Database.get_database_reference("player")

func _ready():
	# Initialize Firestore instance
	db_ref.new_data_update.connect(new_data_updated)
	db_ref.patch_data_update.connect(patch_data_updated)


func new_data_updated(data):
	print("new data")
	print(data)
	
func patch_data_updated(data):
	print("patch data")
	print(data)
