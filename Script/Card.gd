extends Control

var card_pre = load("res://Scenes/Card.tscn")

var card_data

func set_data(data):
	card_data = data
	$Texture.texture = load("res://Assets/Cards/" + card_data.to_tex() + ".png")

func get_drag_data(position):
	var card = card_pre.instance()
	card.set_data(card_data)
	card.get_node("Texture").set_position(Vector2(-119/2, -181/2))
	set_drag_preview(card)
	return self