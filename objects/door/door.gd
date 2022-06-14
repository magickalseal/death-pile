extends Area2D


var next_scene: String = ""


func set_next_scene(new_next_scene: String):
	next_scene = new_next_scene


func _on_Door_body_entered(body):
	if !next_scene:
		print("ERROR: No Next Scene defined")
	
	if body.name == "Player":
		get_tree().change_scene(next_scene)
