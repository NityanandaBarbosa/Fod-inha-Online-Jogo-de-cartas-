extends TextureRect

var card_data_manilha 

func set_manilha(card_data):
	self.card_data_manilha = card_data
	texture = load("res://Assets/Cards/" + card_data.to_tex() + ".png")