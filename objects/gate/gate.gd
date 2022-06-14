extends StaticBody2D

onready var CollisionShape2D_node = get_node("CollisionShape2D")

func open():
	CollisionShape2D_node.disabled = true
	hide()


func close():
	CollisionShape2D_node.disabled = false
	show()
