extends Control

var username
var password = "123456"

func _ready():
	GameState.connect("user_connected", self, "_on_user_connected")
	GameState.connect("create_account", self, "_on_create_account")
	GameState.connect("sing_in", self, "_on_sign_on")
	 
func _on_user_connected(user):
	$Panel/LabInfo.text = "Conectado !!"
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func _on_create_account(success):
	if not success:
		$Panel/LabInfo.text = "Falha ao criar, username já cadastrado."

func _on_sign_on(success):
	if success == false:
		$Panel/LabInfo.text = "Falha ao logar !"

func _on_BtnSingin_pressed():
	username = $Panel/Username.text
	if username.empty():
		$Panel/LabInfo.text = "Username está vazio"
		return
	GameState.create_user(username + "@fodinhaOnline.com", password)
	GameState.login(username + "@fodinhaOnline.com", password)
	$Panel/LabInfo.text = "Conectando, aguarde um momento."
	
#func _on_BtnSingup_pressed():
#	username = $Panel/Username.text
#	if username.empty():
#		$Panel/LabInfo.text = "Username a ser cadastrado está vazio"
#		return
#	GameState.create_user(username + "@fodinhaOnline.com", password)
#	$Panel/LabInfo.text = "Criando, aguarde um momento."
#	$Panel/LabInfo.text = "Username criado, clique em logar."




