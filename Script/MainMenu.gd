extends Control

func _on_BtnHost_pressed():
	get_tree().change_scene("res://Scenes/HostGame.tscn")

func _on_BtnJoin_pressed():
	get_tree().change_scene("res://Scenes/JoinGame.tscn")

func _on_BtnOut_pressed():
	GameState.sing_out()
	get_tree().change_scene("res://Scenes/Login.tscn")
