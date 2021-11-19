extends Spatial


var bichosvivos= 2# cada vez que muere un bicho se restya de aqui y al terminar el nivel lo que queda se le sumaal jugador
# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("jugador").global_transform.origin= Vector3(10,0,13)
	get_parent().get_node("bolacrias").global_transform.origin=Vector3(8.872,2.123,13.115)
	# conecta la musuca y la pone en pausa
	get_node("AudioStreamPlayer").play(0.0)
	get_node("AudioStreamPlayer").stream_paused= true


func _physics_process(delta):
	#antes de edestruirse carga los bichos a ecosistema
	if get_parent().get_node("jugador").nivel!=2:# se destruye el nivel si ya a pasado el jugador al siguiente
		get_parent().get_node("jugador").ecosistema+=bichosvivos
		queue_free()
		
	if get_parent().get_node("jugador").findepartida==true:# SE DESTRUYE EL NIVEL SI SE TERMINA LA PARTIDA
		yield(get_tree().create_timer(4),"timeout")
		queue_free()
	# SI SESTA EN EL MENU O NO PONE O PAUSA LA MUSICA
	if get_parent().menu==false:
		get_node("AudioStreamPlayer").stream_paused= false
	else:
		get_node("AudioStreamPlayer").stream_paused= true


func _on_camara1_body_entered(body):# cambia la camara a las posiciones correscondientes del donde se encuentra el jugador
	if body== get_parent().get_node("jugador"):
		get_parent().get_node("Camera").global_transform.origin= get_parent().get_node("IzqAba").global_transform.origin


func _on_camara2_body_entered(body):
	if body== get_parent().get_node("jugador"):
		get_parent().get_node("Camera").global_transform.origin= get_parent().get_node("IzqArr").global_transform.origin
