extends Node

var type
var naipe
var used

func _init(t, c, u=0):
	type = t
	naipe = c
	used = u
func to_string():
	return type + "|" + str(naipe) + "|" +str(used)
	
func to_tex():
	return type + "|" + str(naipe)
	
