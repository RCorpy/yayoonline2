extends Node2D

var event_deck
var player_deck
var card_databaseref

const CARD_SCENE_PATH = "res://scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2
const EVENT_CARD_SCALE = 0.75



func _ready():
	card_databaseref = preload("res://scripts/CardDataBase.gd")

	player_deck = card_databaseref.FULL_DECK.duplicate()
	player_deck.shuffle()
	
	event_deck = card_databaseref.EVENT_DECK.duplicate()
	event_deck.shuffle()

func draw_card(player_parent_node):
	var card_draw_name = player_deck[0]
	player_deck.erase(card_draw_name)
	
	if player_deck.size() <= 0:
		player_deck = card_databaseref.FULL_DECK.duplicate()
		
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://assets/"+ card_draw_name +".png") 
	new_card.global_position = global_position
	
	#PERSONALIZE CARD // get info about the card
	new_card.card_type = card_databaseref.CARDS[card_draw_name][0]
	var image = load(card_image_path)
	if image is Texture2D:
		new_card.get_node("CardImage").texture = image
	else:
		print("Warning: Could not load image at path: ", card_image_path)
		new_card.get_node("CardImage").texture = preload("res://assets/URSULA_PER.png")
	new_card.get_node("CardName").text = str(card_draw_name)
	new_card.get_node("Cost").text = str(card_databaseref.CARDS[card_draw_name][1])
	new_card.get_node("MoneyGain").text = str(card_databaseref.CARDS[card_draw_name][2])
	new_card.get_node("HealthGain").text = str(card_databaseref.CARDS[card_draw_name][3])
	#END OF PERSONALIZE CARD
	
	player_parent_node.get_node("Hand").add_child(new_card)
	new_card.scale = Vector2($"../CardManager".DEFAULT_CARD_SCALE,$"../CardManager".DEFAULT_CARD_SCALE) 
	new_card.name = "Card"
	new_card.name_of_card = card_draw_name
	#new_card.position = Vector2(center_screen_x,50)
	player_parent_node.get_node("Hand").add_card_to_hand(new_card, CARD_DRAW_SPEED)
	
	if player_parent_node.name == "Player":#only flip if its the player
		new_card.flip_card(true)

func get_card_info(card):
	return card_databaseref.CARDS[card]

func draw_new_event():
	var card_draw_name = event_deck[0]
	event_deck.erase(card_draw_name)
	
	if event_deck.size() <= 0:
		event_deck = card_databaseref.FULL_DECK.duplicate()
		
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://assets/"+ card_draw_name +".png") 
	new_card.global_position = global_position
	
	#GET CARD COLOR (we still call it card_type)
	new_card.card_type = card_databaseref.CARDS[card_draw_name][0]
	var image = load(card_image_path)
	if image is Texture2D:
		new_card.get_node("CardImage").texture = image
	else:
		print("Warning: Could not load image at path: ", card_image_path)
		new_card.get_node("CardImage").texture = preload("res://assets/URSULA_PER.png")
	new_card.get_node("CardName").text = str(card_draw_name)
	new_card.get_node("Cost").text = ""
	new_card.get_node("MoneyGain").text = ""
	new_card.get_node("HealthGain").text = ""
	#END OF PERSONALIZE CARD
	
	$"../EventCardSlot".add_child(new_card)
	new_card.scale = Vector2(EVENT_CARD_SCALE,EVENT_CARD_SCALE) 
	new_card.name = "Card"
	new_card.name_of_card = card_draw_name
	new_card.global_position = $"../EventCardSlot".global_position
	
	new_card.flip_card(true)
	
	#Remove health from characters with the same color as event
	var card_color = card_databaseref.CARDS[card_draw_name][0]
	$"../PlayerManager".event_resolution(card_color)
	#Resolve event
