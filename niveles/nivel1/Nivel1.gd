extends Spatial


var tuto= false# si ha hecho el tuto
var paso=0# lugar donde se encuentra del tuto
var bichosvivos=1

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("jugador").global_transform.origin= Vector3(-25.439,0,9.131)
	get_parent().get_node("bolacrias").global_transform.origin=Vector3(-25.405,2.123,13.115)
	

func _physics_process(delta):
	if get_parent().get_node("jugador").nivel!=1:# se destruye el nivel si ya a pasado el jugador al siguiente
		get_parent().get_node("jugador").ecosistema+=bichosvivos
		queue_free()
	if get_parent().menu==false:
		get_node("musicamenu2").stream_paused=false
	else:
		get_node("musicamenu2").stream_paused= true
	if tuto==false:
		match paso:
			0:
				get_node("tuto/paso1").visible= true
			1:
				get_node("tuto/paso1").visible= false
				get_node("tuto/paso2").visible= true
			
			2:
				get_node("tuto/paso2").visible= false
				get_node("tuto/paso3").visible= true
			3:
				get_node("tuto/paso3").visible= false
				get_node("tuto/paso4").visible= true
			4:
				get_node("tuto/paso4").visible= false
				get_node("tuto/paso5").visible= true
			5:
				get_node("tuto").visible= false
				tuto= true
				
				
