extends MultiPopup

const LOBBY_SCENE = preload("res://Scenes/States/Multiplayer/MultiLobby.tscn")
const DEFAULT_PORT = "3624"

func goto_lobby():
	Main.change_scene_transition(LOBBY_SCENE)

func get_ip_and_port(_string):
	return _string.split(":", false)

func create_info():
	Multiplayer.my_info = {}
	Multiplayer.my_info.name = Settings.multi_data.get("name", "Boyfriend")
	
	var _character = Settings.multi_data.get("character", {})
	Multiplayer.my_info.character = _character

	Multiplayer.my_info.multi_data = Settings.multi_data

func _on_host_button_pressed():
	var _port = $Menu/container/container/host_container/host_port.text
	var _max_players = 10
	
	if !_port.is_valid_integer():
		Main.create_popup("Invalid port number.")
		return
		
	create_info()
	
	var _e = Multiplayer.host_game(int(_port), _max_players)
	if _e == OK:
		goto_lobby()
	else:
		Main.create_popup("Could not create server.\nERROR " + str(_e))

func _on_join_button_pressed():
	var _ip = get_ip_and_port($Menu/container/container/join_container/join_ip.text)
	var _max_players = 10
	
	if len(_ip) == 0:
		Main.create_popup("Nothing has been entered lmao.\nEnter something in the IP box.")
		return
	if len(_ip) <= 1:
		_ip.append(DEFAULT_PORT)
	if !_ip[1].is_valid_integer():
		Main.create_popup("Invalid port number.")
		return
	
	create_info()
		
	var _e = Multiplayer.join_game(_ip[0], int(_ip[1]))
	if _e == OK:
		goto_lobby()
	else:
		Main.create_popup("Could not connect.\nERROR " + str(_e))
