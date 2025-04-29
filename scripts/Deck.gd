extends Node2D

var player_deck = [
	"ANGUSTIAS_PER",
	"ENRIQUETA_PER",
	"GERTRUDIS_PER",
	"GREGORIO_PER",
	"JEREMIAS_PER",
	"LIBERTO_PER",
	"URSULA_PER"]
	
var card_databaseref

const CARD_SCENE_PATH = "res://scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2



func _ready():
	card_databaseref = preload("res://scripts/CardDataBase.gd")
	player_deck.shuffle()

func draw_card():
	var card_draw_name = player_deck[0]
	player_deck.erase(card_draw_name)
	
	if player_deck.size() == 0:
		print("DECK FINISHED")
		
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://assets/"+ card_draw_name +".png") 
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.position = position
	new_card.card_type = card_databaseref[card_draw_name][0]
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	#new_card.position = Vector2(center_screen_x,50)
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")
