extends Node

var card_data_pre = preload("res://Script/CardData.gd")

var deck = []

var stack = []

func buy_cards(hand, n=1):
	for i in range(n):
		hand.append(get_random_card())
	
func get_random_card():
	randomize()
	var r = int(rand_range(0, deck.size()))
	var card = deck[r]
	deck.remove(r)
	return card
	

func gen_deck():
	for n in range(1,14):
		for c in range(1,5):
			var card = card_data_pre.new(str(n), c)
			deck.append(card)
	return deck
	
func array_to_dic(arr):
	var dic = {}
	var j = 0
	for c in arr:
		dic[j] = c.to_string()
		j +=1
	return dic
		
func update_deck(dic):
	deck.clear()
	for k in dic:
		deck.append(to_card_data(dic[k]))
		
func to_card_data(s):
	var args = s.split("|")
	var c = card_data_pre.new(args[0], int(args[1]), int(args[2]))
	return c

func deckClear():
	deck.clear()
	print("Limpei o deck !")
	print(deck)

func printDeck():
	print(deck)
	