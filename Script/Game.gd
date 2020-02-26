extends Node

var room_data
var me_n

var card_manager
var hand

func _ready():
	
	room_data = GameState.room_data
	me_n = GameState.me_n
	
	GameState.connect("snapshot_data", self, "_on_snapshot_data")
	
	card_manager = load("res://Script/CardManager.gd").new()
	
	show_profiles()
	
	if GameState.host :
		room_data["game"] = {}
		room_data["game"]["way"] = 1
		room_data["game"]["turn"] = 0
		room_data["game"]["ncards"] = {}
		room_data["game"]["nplayers"] = 99
		room_data["game"]["state"] = "init"
		room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.gen_deck())
		#room_data["game"]["stack"] = {}
		room_data["game"]["apostas"] = {}
		room_data["game"]["acertosApostas"] = {}
		room_data["game"]["cartasHand"] = {}
		room_data["game"]["totalApostas"] = 0
		room_data["game"]["cardNext"] = 99
		room_data["game"]["roundWinner"] = 0
		room_data["game"]["roundCounter"] = 0
		room_data["game"]["recebeuCards"] = {}
		GameState.set_document("rooms", GameState.room_name, room_data)
	
func _on_snapshot_data(data):
	
	room_data = data
	
	#if room_data["game"]["state"] == "over":
	#	room_data["game"]["winner"] = room_data["players"][str(0)]
	#	GameState.set_document("rooms", GameState.room_name, room_data)
	#	GameState.remove_listener("rooms", GameState.room_name)
	#	GameState.room_data = data
	#	get_tree().change_scene("res://Scenes/WinScreen.tscn")
	#	return
	
	if room_data["game"]["state"] == "game":
		$Stack.set_top(card_manager.to_card_data(room_data["game"]["top_card"]))
		$Manilha.set_manilha(card_manager.to_card_data(room_data["game"]["manilha"]))
		show_ncards()
		var count = 0
		for i in range(6):
			if room_data["game"]["ncards"].has(str(i)):
				if room_data["game"]["ncards"][str(i)] == 0:
					count += 1
		if count == room_data["game"]["nplayers"]:
			room_data["game"]["state"] = "newTurn"
			for i in range(6):
				if room_data["game"]["apostas"].has(str(i)):
					room_data["game"]["recebeuCards"][str(me_n)] = 0
					if room_data["game"]["apostas"][str(i)] != room_data["game"]["acertosApostas"][str(i)]:
						room_data["game"]["cartasHand"][str(i)] += -1
						GameState.set_document("rooms", GameState.room_name, room_data)
			room_data["game"]["ncards"] = {}
			room_data["game"]["apostas"] = {}
			room_data["game"]["acertosApostas"] = {}
			room_data["game"]["roundCounter"] = 0
			room_data["game"]["totalApostas"] = 0
			card_manager.deckClear()
			room_data["game"]["deck"] = {}
			GameState.set_document("rooms", GameState.room_name, room_data)
			room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.gen_deck())
			GameState.set_document("rooms", GameState.room_name, room_data)
			
			
	if is_my_turn():
		
		if room_data["game"]["state"] == "init":
			card_manager.update_deck(room_data["game"]["deck"])
			if $Hand.cards_data.size() != 0:
				room_data["game"]["state"] = "normal"
				var manilha = card_manager.get_random_card()
				room_data["game"]["manilha"] = manilha.to_string()
				room_data["game"]["top_card"] = null
				GameState.set_document("rooms", GameState.room_name, room_data)
				room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.deck)
				GameState.set_document("rooms", GameState.room_name, room_data)
				var nplayers = 0
				for i in range(6):
					if room_data["players"].has(str(i)):
						room_data["game"]["cartasHand"][str(i)] = 4
						room_data["game"]["acertosApostas"][str(i)] = 0
						nplayers += 1
				room_data["game"]["nplayers"] = nplayers
				GameState.set_document("rooms", GameState.room_name, room_data)
				$Stack.set_top(card_manager.to_card_data(room_data["game"]["top_card"]))
				$Manilha.set_manilha(card_manager.to_card_data(room_data["game"]["manilha"]))
			else:
				card_manager.buy_cards($Hand.cards_data, 4)
				room_data["game"]["deck"] = null
				GameState.set_document("rooms", GameState.room_name, room_data)
				$Hand.reload()
				calc_next()
				room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.deck)
				GameState.set_document("rooms", GameState.room_name, room_data)
		
		elif room_data["game"]["state"] == "normal":
			if room_data["game"]["apostas"].has(str(me_n)):
				room_data["game"]["state"] = "game"
				$Manilha.set_manilha(card_manager.to_card_data(room_data["game"]["manilha"]))
				var ncard = room_data["game"]["manilha"].split("|")
				ncard = int(ncard[0])
				if ncard == 13:
					room_data["game"]["cardNext"] = 1
				else:
					room_data["game"]["cardNext"] = ncard + 1
				GameState.set_document("rooms", GameState.room_name, room_data)
			else:
				$Aposta0.show(); $Aposta1.show(); $Aposta2.show(); $Aposta3.show(); $Aposta4.show()
			$LabInfo.text = "Sua vez de apostar!"
		
		elif room_data["game"]["state"] == "game":
			$LabInfo.text = "Sua vez!"
			if room_data["game"]["roundCounter"] == room_data["game"]["nplayers"]:
				room_data["game"]["turn"] = room_data["game"]["roundWinner"]
				room_data["game"]["acertosApostas"][str(room_data["game"]["roundWinner"])] += 1
				room_data["game"]["roundCounter"] = 0
				room_data["game"]["top_card"] = null
				GameState.set_document("rooms", GameState.room_name, room_data)
				print("Proxima rodada !!")
			else:
				pass
		elif room_data["game"]["state"] == "newTurn":
			card_manager.update_deck(room_data["game"]["deck"])
			if $Hand.cards_data.size() != 0 or room_data["game"]["recebeuCards"][str(me_n)] == 1:
				room_data["game"]["state"] = "normal"
				var manilha = card_manager.get_random_card()
				room_data["game"]["manilha"] = manilha.to_string()
				room_data["game"]["deck"] = null
				room_data["game"]["top_card"] = null
				GameState.set_document("rooms", GameState.room_name, room_data)
				room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.deck)
				GameState.set_document("rooms", GameState.room_name, room_data)
				$Stack.set_top(card_manager.to_card_data(room_data["game"]["top_card"]))
				$Manilha.set_manilha(card_manager.to_card_data(room_data["game"]["manilha"]))
			else:
				hand = room_data["game"]["cartasHand"][str(me_n)]
				if hand == 0:
					room_data["game"]["recebeuCards"][str(me_n)] = 1
					calc_next()
					GameState.set_document("rooms", GameState.room_name, room_data)
				else:
					card_manager.buy_cards($Hand.cards_data, hand)
					room_data["game"]["deck"] = null
					GameState.set_document("rooms", GameState.room_name, room_data)
					$Hand.reload()
					calc_next()
					room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.deck)
					room_data["game"]["recebeuCards"][str(me_n)] = 1
					GameState.set_document("rooms", GameState.room_name, room_data)
			
		highlight()
			
	else:
		$Aposta0.hide(); $Aposta1.hide(); $Aposta2.hide(); $Aposta3.hide(); $Aposta4.hide()
		if room_data["game"]["state"] == "normal" or "newTurn":
			$Manilha.set_manilha(card_manager.to_card_data(room_data["game"]["manilha"]))
		highlight()
		$LabInfo.text = "Aguarde sua vez!"
		
func is_my_turn():
	return room_data["game"]["turn"] == me_n
	
func show_profiles():
	var player = me_n
	for i in range(6):
		if room_data["players"].has(str(player)):
			get_node("Player" + str(i)).show()
			get_node("Player" + str(i) + "/Name").text = room_data["players"][str(player)]
		player = (player + 1)%6

func calc_next():
	var way = room_data["game"]["way"]
	var next = room_data["game"]["turn"]
	for i in range(6):
		next = next + way
		if next == 6: next = 0
		if room_data["players"].has(str(next)):
			room_data["game"]["turn"] = next
			return

func calc_num_player(p):
	var r = p - me_n if p - me_n >= 0 else 6 + p - me_n
	return r

func highlight():
	for i in range(6):
		if i == room_data["game"]["turn"]:
			get_node("Player" + str(calc_num_player(i))).self_modulate = Color(1, 0, 0)
		else:
			get_node("Player" + str(calc_num_player(i))).self_modulate = Color(1, 1, 1)
	
func go_to_next():
	calc_next()
	room_data["game"]["ncards"][str(me_n)] = $Hand.cards_data.size()
	if room_data["game"]["top_card"] == null:
		room_data["game"]["top_card"] = $Stack.card_data.to_string()
		room_data["game"]["roundWinner"] = me_n
		room_data["game"]["roundCounter"] +=1
	else:
		var testTop = $Stack.card_data.to_string().split("|")
		var topPassada = room_data["game"]["top_card"].split("|")
		print(testTop)

		if int(testTop[0]) == room_data["game"]["cardNext"]:
			if int(testTop[0]) == int(topPassada[0]) and int(testTop[0][1]) > int(topPassada[0][1]) :
				room_data["game"]["top_card"] = $Stack.card_data.to_string()
				room_data["game"]["roundWinner"] = me_n
				room_data["game"]["roundCounter"] +=1
			elif int(topPassada[0]) != room_data["game"]["cardNext"]:
				room_data["game"]["top_card"] = $Stack.card_data.to_string()
				room_data["game"]["roundWinner"] = me_n
				room_data["game"]["roundCounter"] +=1

		elif int(testTop[0]) >= int(topPassada[0]):
			if int(topPassada[0]) != room_data["game"]["cardNext"]:
				room_data["game"]["top_card"] = $Stack.card_data.to_string()
				room_data["game"]["roundWinner"] = me_n
				room_data["game"]["roundCounter"] +=1
			elif int(testTop[0]) == int(topPassada[0]) and int(testTop[0][1]) > int(topPassada[0][1]):
				room_data["game"]["top_card"] = $Stack.card_data.to_string()
				room_data["game"]["roundWinner"] = me_n
				room_data["game"]["roundCounter"] +=1
		else:
			room_data["game"]["roundCounter"] +=1
	GameState.set_document("rooms", GameState.room_name, room_data)
	
func show_ncards():
	for i in range(6):
		if room_data["game"]["ncards"].has(str(i)):
			if calc_num_player(i) != 0:
				get_node("Player" + str(calc_num_player(i)) + "/Number").text = str(room_data["game"]["ncards"][str(i)])

func aposta(aposta):
	room_data["game"]["totalApostas"] += aposta
	room_data["game"]["apostas"][str(me_n)] = aposta
	calc_next()
	GameState.set_document("rooms", GameState.room_name, room_data)

func _on_Aposta0_pressed():
	var aposta = 0
	aposta(aposta)

func _on_Aposta1_pressed():
	var aposta = 1
	aposta(aposta)

func _on_Aposta2_pressed():
	var aposta = 2
	aposta(aposta)
	
func _on_Aposta3_pressed():
	var aposta = 3
	aposta(aposta)

func _on_Aposta4_pressed():
	var aposta = 4
	aposta(aposta)