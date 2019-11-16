extends TextureRect

var card_data 

func set_top(card_data):
	self.card_data = card_data
	texture = load("res://Assets/Cards/" + card_data.to_tex() + ".png")
	
func can_drop_data(position, data):
	if not get_parent().is_my_turn(): 
		return false
	data = data.card_data
	return true

func drop_data(position, card):
	set_top(card.card_data)
	get_node("../Hand").play_card(card)