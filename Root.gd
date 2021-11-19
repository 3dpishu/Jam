extends Spatial

var puntero=("jugar")
var menu= true# si esta o no activado
var nive1= preload("res://niveles/nivel1/Nivel1.tscn")
var nivel2= preload("res://niveles/nivel2/nivel2.tscn")
var niveltre= 0#nivel que se encuentra en el arbol raiz
var velocidadscroll= 20

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused= true
	if get_node("jugador").nivel==1:
		get_node("Camera").global_transform.origin= get_node("IzqAba").global_transform.origin


func _physics_process(delta):
	if get_node("jugador").nivel!= niveltre:#carga nivel
		_carga_de_niveles(delta)
	_menu(delta)
	# datos del jugador
	if menu== true:
		get_node("jugador/datos").visible=false
		if get_node("Nivel1")!= null:
			get_node("Nivel1/tuto").visible= false	
	else:
		get_node("jugador/datos").visible=true
		if get_node("Nivel1")!= null && get_node("Nivel1").tuto==false:
			get_node("Nivel1/tuto").visible= true	
	
	



func _menu(delta):
	if menu==true:
		get_tree().paused= true
		get_node("menu").visible= true
		get_node("menu/musicamenu").stream_paused= false
		
		
		if Input.is_action_just_pressed("adelante"):
			if puntero==("jugar") && get_node("menu/animacionmenu").is_playing()==false :
				get_node("menu/animacionmenu").play("jugar",-1)
				get_node("menu/animacionmenuback").play_backwards("salir",-1)
				puntero=("salir")
				
			elif puntero==("salir")&& get_node("menu/animacionmenu").is_playing()==false :
				get_node("menu/animacionmenu").play("salir",-1)
				get_node("menu/animacionmenuback").play_backwards("opciones",-1)
				puntero=("opciones")
			elif puntero==("opciones")&& get_node("menu/animacionmenu").is_playing()==false:
				get_node("menu/animacionmenu").play("opciones",-1)
				get_node("menu/animacionmenuback").play_backwards("jugar",-1)
				puntero=("jugar")
				
		if Input.is_action_just_pressed("atras"):
			if puntero==("jugar") && get_node("menu/animacionmenu").is_playing()==false :
				get_node("menu/animacionmenu").play("jugar",-1)
				get_node("menu/animacionmenuback").play_backwards("opciones",-1)
				puntero=("opciones")
			elif puntero==("opciones")&& get_node("menu/animacionmenu").is_playing()==false :
				get_node("menu/animacionmenu").play("opciones",-1)
				get_node("menu/animacionmenuback").play_backwards("salir",-1)
				puntero=("salir")
				
			elif puntero==("salir")&& get_node("menu/animacionmenu").is_playing()==false :
				get_node("menu/animacionmenu").play("salir",-1)
				get_node("menu/animacionmenuback").play_backwards("jugar",-1)
				puntero=("jugar")
			
				
		if Input.is_action_just_pressed("lanzar"):
			if puntero==("salir"):
				get_tree().quit(-1)
			if puntero==("opciones"):
				_opciones(delta)
			if puntero==("jugar"):# acion para jugar partida
				get_tree().paused= false
				menu= false# no hay menu
				if get_node("jugador").nivel==1:
					if get_node("Nivel1").tuto== false:
						get_node("Nivel1").paso-=1
	
	else:
		get_node("menu").visible= false
		get_node("menu/musicamenu").stream_paused= true
		# scroll del volumen
	_scrollvolumen(delta)
	
func _carga_de_niveles(delta):
	# aqui va cargando los niveles conforme avanza el juego
	get_node("jugador/escarabajo/AnimationPlayer").current_animation=("stop")
	if menu== false:
		#pantalla de siguiente nivel
		get_tree().paused=true
		get_node("Panel/animacion alfa").play("alfa",-1)
		yield(get_tree().create_timer(1.5),"timeout")
		get_tree().paused=false
	
	get_node("bolacrias").visible=false
	get_node("bolacrias/CollisionShape").disabled=true
	get_node("Camera").global_transform.origin= get_node("IzqAba").global_transform.origin
	# carga los distintos niveles, destruyendo los niveles anteriores
	if niveltre!=get_node("jugador").nivel:
		niveltre=get_node("jugador").nivel
		if get_node("jugador").nivel==1:
			var newnivel= nive1.instance()
			add_child(newnivel)
			newnivel.global_transform.origin= global_transform.origin
		if get_node("jugador").nivel==2:
			
			var newnivel=nivel2.instance()
			add_child(newnivel)
			newnivel.global_transform.origin= global_transform.origin
				
func _opciones(delta):
	if get_node("menu/HScrollBar").visible==false:
		get_node("menu/HScrollBar").visible=true
	else:
		get_node("menu/HScrollBar").visible=false

func _scrollvolumen(delta):
	if get_node("menu/HScrollBar").visible==true && menu== true:
		var valor=get_node("menu/HScrollBar").value
		if Input.is_action_pressed("derecha"):
			valor+=velocidadscroll*delta
		if Input.is_action_pressed("izquierda"):
			valor-=velocidadscroll*delta
		get_node("menu/HScrollBar").value=valor	
		var volumen= AudioServer.get_bus_volume_db(0)
		volumen= volumen*valor/100
		AudioServer.set_bus_volume_db(0,-80+valor)
		
