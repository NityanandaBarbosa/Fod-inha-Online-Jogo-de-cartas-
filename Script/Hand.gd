extends HBoxContainer

var card_pre = preload("res://Scenes/Card.tscn")

var cards_data = []

func reload():
	for c in get_children():
		c.queue_free()
		
	for c in cards_data:
		var card = card_pre.instance()
		card.set_data(c)
		add_child(card)
		
func play_card(card):
	cards_data.remove(cards_data.find(card.card_data))
	remove_child(card)
	get_parent().go_to_next()