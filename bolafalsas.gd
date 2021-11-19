extends RigidBody


var altura= 2
var fuerza= 3
var cogido= false
var estado= Vector3()
var potencia= 3


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_nodes_in_group("jugador")[0].bolas=1

func _physics_process(delta):
	
	if linear_velocity.y>6:# controla que la fuerza de empuje hacia arriva nunca supere 5
		linear_velocity.y=5



	

# esta funcion detecta una señaly si el cuerpo totado esta en el grupo jugador y el el shape 1 entonces lo agarrara
func _on_bolacrias_body_shape_entered(body_id, body, body_shape, local_shape):
	get_node("CPUParticles").emitting= true
	
		
	if body.is_in_group("jugador") && body_shape==1:# LO AGARRA SI EL SHAPE ES EL DE LAS PATAS TRASERAS
		if cogido== false&& get_node("Timer").time_left==0:
			var bolareal= get_tree().get_nodes_in_group("bolacrias")[0]
			bolareal.global_transform= get_tree().get_nodes_in_group("jugador")[0].get_node("agarrebola").global_transform
			bolareal.get_node("CollisionShape").disabled= false
			bolareal.visible= true
			queue_free()
	_integrate_forces(linear_velocity)		
	if estado.z>5 or estado.z<5:
		if body.is_in_group("enemigo"):
			get_node("enemigo").emitting= true
			body.vida-=1
		
func _integrate_forces(state):
	estado= state
	return estado
		

func _on_VisibilityNotifier_screen_exited():
	var jugador= get_tree().get_nodes_in_group("jugador")[0]
	jugador.bolas= 0
	queue_free()




		
