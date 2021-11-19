extends RigidBody


var altura= 2
var fuerza= 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if linear_velocity.y>6:# controla que la fuerza de empuje hacia arriva nunca supere 5
		linear_velocity.y=5
		
	
	








	
	

		
		
