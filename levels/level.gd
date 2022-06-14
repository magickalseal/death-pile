extends Node2D


var player_scene = preload("res://characters/player/player.tscn")


func initialize_level(
		next_level: String,
		door_node_name: String = "Door",
		first_spawn_altar_node_name: String = "SpawnAltar",
		respawn_falling_mark_node_name: String = "RespawnMarkFalling"
	):
	
	var door_node = get_node(door_node_name)
	door_node.set_next_scene(next_level)
	
	var player = player_scene.instance()
	
	var spawn_altar_node = get_node(first_spawn_altar_node_name)
	player.set_spawn_altar(spawn_altar_node)
	
	var respawn_falling_mark_node = get_node(respawn_falling_mark_node_name)
	player.set_respawn_falling_mark(respawn_falling_mark_node)
	
	player.position = spawn_altar_node.position
	
	add_child(player)
