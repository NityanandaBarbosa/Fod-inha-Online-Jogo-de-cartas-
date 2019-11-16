extends Control

enum {CREATE, WAIT, START}
var state = CREATE

var user_data
var room_data
var Host

func _ready():
	GameState.host = true
	GameState.me_n = 0
	
	GameState.connect("snapshot_data", self, "_on_snapshot_data")
	GameState.connect("document_added", self, "_on_document_added")
	
	user_data = GameState.user_data
	GameState.room_name = user_data["name"]
	
	$Back/Panel/LabInfoHost.text = "Criando sala ..."
	GameState.set_document("rooms", GameState.room_name, {"players": null, "state": "open"})
	GameState.set_document("rooms", GameState.room_name, {"players":{"0": user_data["name"]}, "state": "open"})

func _on_document_added(sucess):
	if state == CREATE:
		if sucess:
			print("Sala criada com sucesso")
			$Back/Panel/LabInfoHost.text = "Seus amigos devem da JOIN em " +  user_data["name"]  + "!"
			GameState.set_listener("rooms", user_data["name"])
			state = WAIT
		else:
			print("Falha na criação da sala")
			get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_snapshot_data(data):
	room_data = data
	if state == WAIT:
		print("Alteração nos jogadores!")
		var nplayers = room_data["players"].size()
		$Back/Panel/LabNumPlayers.text = "Players ( " + str(nplayers) + "/6):"
		for i in range(6):
			if room_data["players"].has(str(i)):
				get_node("Back/Panel/LabPlayer" + str(i)).text = room_data["players"][str(i)]
			else:
				get_node("Back/Panel/LabPlayer" + str(i)).text = "-"
		$Back/Panel/BtnStartHost.disabled = (nplayers <= 1)
	elif state == START:
		GameState.room_data = room_data
		print("Mudar de tela")
		get_tree().change_scene("res://Scenes/Game.tscn")

func _on_BtnStartHost_pressed():
	room_data["state"] = "start"
	GameState.set_document("rooms", GameState.room_name, room_data)
	state = START

func _on_BtnCancela_pressed():
	room_data["state"] = "cancel"
	room_data["players"] = null
	room_data["game"] = null
	GameState.remove_listener("rooms", GameState.room_name)
	GameState.set_document("rooms", GameState.room_name, room_data)
	get_tree().change_scene("res://Scenes/MainMenu.tscn")