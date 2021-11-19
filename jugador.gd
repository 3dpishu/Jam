extends KinematicBody

var velocidad=10
var rotacion=2
var bolareal= preload("res://bolafalsa.tscn")
var bolas=0
var estado= {"idle":true,"camina":false,"cogepelota":false,"idlepelota":false}
var nivel= 1# el nivelpor el que se encuentra
var ecosistema= 2# es la vida, si llega a cero pierdes. cad vez que pasas de nivel, los bichos que no has matado te puntuan 1, si matas alguno, te resta 1, si te atacan te resta 1, si pies la bola te resta 1
var findepartida= false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("escarabajo/AnimationPlayer").play("idle")
	ecosistema= str(ecosistema)
	get_node("datos/eco").text= ecosistema
	ecosistema= str2var(ecosistema)

func _physics_process(delta):
	# sale al menu y hace pausa
	if Input.is_action_just_pressed("menu"):
		get_parent().menu= true
	# actualiza el ecosistema
	ecosistema= str(ecosistema)
	get_node("datos/eco").text= ecosistema
	ecosistema= str2var(ecosistema)
	
	if ecosistema<1:
		_pierdes(delta)
	if global_transform.origin.y!= 0:
		global_transform.origin.y= 0
	if findepartida==false:
		_movimiento(delta)
	if ecosistema<1 && get_node("escarabajo/AnimationPlayer").current_animation!=("muerto"):
		if findepartida==false:
			_muere(delta)

		
	if bolas<1 && get_tree().get_nodes_in_group("bolacrias")[0].visible==false && findepartida== false:# si no hay bolas
		var bolacria= get_tree().get_nodes_in_group("bolacrias")[0]
		bolacria.visible= false
		bolacria.get_node("CollisionShape").disabled= true
		var newbola= bolareal.instance()# instancia y coloca la bola falsa 
		get_tree().get_nodes_in_group("root")[0].add_child(newbola)
		newbola.global_transform= get_node("agarrebola").global_transform
		newbola.global_transform.origin.y+=10
	
func _movimiento(delta):
	
	if Input.is_action_pressed("atras"): 
		var personaje= move_and_collide(global_transform.basis.z*((velocidad/2)*delta))
		if get_tree().get_nodes_in_group("bolacrias")[0].visible==true:
			get_node("escarabajo/AnimationPlayer").play("caminarpelota")
		else:
			get_node("escarabajo/AnimationPlayer").play("caminar")
	if Input.is_action_pressed("izquierda"): 
		global_transform.basis=global_transform.basis.rotated(Vector3(0,1,0),rotacion*delta)
		if get_tree().get_nodes_in_group("bolacrias")[0].visible== true:
			get_node("escarabajo/AnimationPlayer").play("caminarpelota")
		else:
			get_node("escarabajo/AnimationPlayer").play("caminar")
	if Input.is_action_pressed("derecha"): 
		global_transform.basis=global_transform.basis.rotated(Vector3(0,1,0),-rotacion*delta)
		if get_tree().get_nodes_in_group("bolacrias")[0].visible== true:
			get_node("escarabajo/AnimationPlayer").play("caminarpelota")
		else:
			get_node("escarabajo/AnimationPlayer").play("caminar")
	if Input.is_action_pressed("adelante"):
		var personaje= move_and_collide(global_transform.basis.z*(-velocidad*delta))
		get_node("escarabajo/AnimationPlayer").play("caminar",-1,2)
		var bolacria= get_tree().get_nodes_in_group("bolacrias")[0]
		if bolacria.visible== true:
			bolacria.visible= false
			bolacria.get_node("CollisionShape").disabled= true
			var newbola= bolareal.instance()
			get_tree().get_nodes_in_group("root")[0].add_child(newbola)
			newbola.global_transform= get_node("agarrebola").global_transform
	if Input.is_action_just_pressed("lanzar"):
		get_node("escarabajo/AnimationPlayer").play("idle")
		var bolacria= get_tree().get_nodes_in_group("bolacrias")[0]
		if bolacria.visible== true:
			bolacria.visible= false
			bolacria.get_node("CollisionShape").disabled= true
			var newbola= bolareal.instance()
			get_tree().get_nodes_in_group("root")[0].add_child(newbola)
			newbola.global_transform= get_node("agarrebola").global_transform
			newbola.apply_impulse(Vector3(1,1,1),global_transform.basis.z.normalized()*100)
		if nivel==1:
			if get_parent().get_node("Nivel1").tuto==false && get_parent().get_node("Nivel1").visible== true:# va pasando el tutorial comforme pulsas 
				get_parent().get_node("Nivel1").paso+=1

			
	if Input.is_action_just_released("adelante"):
		get_node("escarabajo/AnimationPlayer").play("idle")
	if  Input.is_action_just_released("atras") && get_tree().get_nodes_in_group("bolacrias")[0].visible==false:
		get_node("escarabajo/AnimationPlayer").play("idle")
	if  Input.is_action_just_released("atras") && get_tree().get_nodes_in_group("bolacrias")[0].visible==true:
		get_node("escarabajo/AnimationPlayer").play("idlebola")
	if Input.is_action_just_released("derecha")||Input.is_action_just_released("izquierda"):
		if get_tree().get_nodes_in_group("bolacrias")[0].visible== true:
			get_node("escarabajo/AnimationPlayer").play("idlebola")
		else:
			get_node("escarabajo/AnimationPlayer").play("idle")
			
func _muere(delta):
	get_node("escarabajo/AnimationPlayer").play("muerte",-1)
	findepartida= true
	
	
func _pierdes(delta):
	yield(get_tree().create_timer(3),"timeout")
	get_tree().reload_current_scene()


	
func _pasa_de_nivel():
	nivel+=1


func _on_Nivel1_tree_exiting():
	pass # Replace with function body.



		
