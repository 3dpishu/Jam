extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# warning-ignore:unused_argument
func _physics_process(delta):
	pass


func _on_Area_body_entered(body):
	if body==get_tree().get_nodes_in_group("bolacrias")[0]:
		get_tree().get_nodes_in_group("jugador")[0]._pasa_de_nivel()
