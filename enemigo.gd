extends KinematicBody


var velocidad= -6
var camina= true
var vida=2
var impacto= null
var golpe= vida
var muerto= false# si esta muerto el escarabajogrande
var objetivo= null
var velobje= 1
var ataque= false
var eco=true# para que no quite eco 2 veces


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("camina")
	move_lock_x


func _physics_process(delta):
	if global_transform.origin.y!= 0:
		global_transform.origin.y= 0
	if objetivo!= null && vida>0:
		global_transform=global_transform.interpolate_with(global_transform.looking_at(objetivo.global_transform.origin,Vector3(0,1,0)),velobje*delta)
		global_transform=global_transform.orthonormalized()
		
	
	
	if vida>0:
		if camina== true:
			impacto= move_and_collide(global_transform.basis.z*velocidad*delta)
			
			if impacto && get_node("AnimationPlayer").current_animation==("camina"):
				if impacto.collider == get_tree().get_nodes_in_group("jugador")[0]:
					get_node("AnimationPlayer").play("poseataque",-1,2)
					camina= false
					
				else:
					global_transform.basis= global_transform.basis.rotated(global_transform.basis.y,-3.14159)
					global_transform= global_transform.orthonormalized()
			
					
					
		if get_node("AnimationPlayer").is_playing()==false:
			get_node("AnimationPlayer").play("camina")
			impacto= move_and_collide(global_transform.basis.z*velocidad*delta)
			if impacto:
				if impacto.collider == get_tree().get_nodes_in_group("jugador")[0]:
					_danyo(delta)
					get_node("AnimationPlayer").playback_speed=0
					yield(get_tree().create_timer(2),"timeout")
					get_node("AnimationPlayer").playback_speed=1
			camina=true
				

			
	if vida<1:
		if muerto== false:
			get_node("Timer").start(-1)
			get_node("AnimationPlayer").play("muerte",-1,2)
			muerto= true
		_muere(delta)

	

func _danyo(delta):
	if get_tree().get_nodes_in_group("jugador")[0].ecosistema>0:
		get_node("AnimationPlayer").play("camina",-1)
		get_tree().get_nodes_in_group("jugador")[0].ecosistema=get_tree().get_nodes_in_group("jugador")[0].ecosistema-1
		var danyo= str(get_tree().get_nodes_in_group("jugador")[0].ecosistema)
		get_tree().get_nodes_in_group("jugador")[0].get_node("datos/eco").text=danyo
	
func _muere(delta):
	if get_node("Timer").time_left==0 and muerto== true && eco== true:
		var resta= get_tree().get_nodes_in_group("jugador")[0].ecosistema
		resta-=1
		get_tree().get_nodes_in_group("jugador")[0].ecosistema= resta
		eco= false
		get_parent().bichosvivos-=1
		queue_free()


func _on_Area_body_entered(body):
	if body== get_tree().get_nodes_in_group("jugador")[0]:
		objetivo= body
		


func _on_Area_body_exited(body):
	if body== get_tree().get_nodes_in_group("jugador")[0]:
		objetivo= null
