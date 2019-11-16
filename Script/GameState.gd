extends Node

var firebase

var user_data = null
var room_name
var room_data

var host
var me_n



signal user_connected(user)
signal user_disconnected()
signal sing_in(sucess)
signal create_account(sucess)
signal document_added(sucess)
signal snapshot_data(data)


func _ready():
	firebase = Engine.get_singleton("FireBase")
	firebase.initWithFile("res://godot-firebase-config.json", get_instance_id())
	
func create_user(email, password):
	firebase.email_create_account(email, password)
	
func login(email, password):
	firebase.email_sign_in(email, password)
	
func sing_out():
	firebase.email_sign_out()
	
func _receive_message(tag, from, key, data):
	if tag == "FireBase":
		if from == "E&P":
			if key == "SignIn":
				emit_signal("sing_in", data)
			elif key == "CreateAccount":
				emit_signal("create_account", data)
		elif from == "Auth":
			if key == "EmailLogin":
				if data:
					user_data = parse_json(firebase.get_email_user())
					print(user_data)
					print(user_data['email'])
					user_data["name"] = user_data["email"].split("@")[0]
					emit_signal("user_connected", user_data)
				else:
					user_data = null
					emit_signal("user_disconnected", user_data)
		elif from == "Firestore":
			if key == "DocumentAdded":
				emit_signal("document_added", data)
			elif key == "SnapshotData":
				emit_signal("snapshot_data", parse_json(data))
				
func _is_connected():
	return user_data != null
	
func set_listener(col,doc):
	firebase.set_listener(col, doc)
	
func remove_listener(col,doc):
	firebase.remove_listener(col, doc)	
	
func set_document(col, doc, data):
	firebase.set_document(col, doc, data)