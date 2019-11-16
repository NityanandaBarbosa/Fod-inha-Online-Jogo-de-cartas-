extends Control

func _ready():
	$Panel/Name.text = GameState.room_data["game"]["winner"]

func _on_BtnExit_pressed():
	 get_tree().change_scene("res://Scenes/MainMenu.tscn")
