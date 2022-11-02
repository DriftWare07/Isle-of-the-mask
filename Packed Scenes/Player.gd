extends KinematicBody2D


export var speed = 120
export var gravity = 4000
export var slide_gravity = 2000
export var jump = 1200
export var double_jump = 1000
export var friction = 0.1
export var acceleration = 0.25
export var walljump_strength = 0.3
export var knockback = 30
var double_jumped = false

onready var anim = $AnimatedSprite
onready var cast = $RayCast2D
onready var buffer = $Jump_buffer

onready var runparticles = $Particles/RunParticles
onready var doublejumpparticles = $Particles/ExplosionParticles

onready var jump_sfx = $sounds/JumpSound
onready var walljump_sfx = $sounds/WalljumpSound
onready var doublejump_sfx = $sounds/DoublejumpSound
onready var hurt_sfx = $sounds/HurtSound
onready var fade = $UI/Control/FadeControl

var velocity = Vector2()
var dir = 0
var walljump = 0
var hp = 3

var hazardList = []

onready var heartlist = [$UI/Control/LifeBar/Heart1, $UI/Control/LifeBar/Heart2, $UI/Control/LifeBar/Heart3]

func _ready():
	fade.play("RESET")
	fade.play("fadein")

func inputs():
	dir = 0
	
	
	if Input.is_action_just_pressed("jump"):
		buffer.start()
	
	#jump code
	if buffer.time_left != 0 and is_on_floor() and hp > 0:
		velocity.y -= jump
		Input.start_joy_vibration(0, 0.5, 0.2, 0.1)
		jump_sfx.play()
		#double jump code
	elif (not is_on_floor() and Input.is_action_just_pressed("jump")) and (not double_jumped and not cast.is_colliding()):
		velocity.y = 0
		velocity.y -= double_jump+(gravity/10)
		
		double_jumped = true
		
		Input.start_joy_vibration(0, 0.3, 0.2, 0.1)
		doublejump_sfx.play()
		doublejumpparticles.emitting = true
		#walljump code
	
	
	
	if cast.is_colliding() and (not is_on_floor() and Input.is_action_just_pressed("jump") and hp > 0):
		walljump = sign(cast.cast_to.x*-1)
		$WallJump_Helper.start(walljump_strength)
		velocity.y = jump*-1
		walljump_sfx.play()
		Input.start_joy_vibration(0, 0.3, 0.2, 0.1)
	
		
	if $WallJump_Helper.time_left != 0:
		dir = walljump
		
		#github test
	if $WallJump_Helper.time_left == 0 and hp > 0:
		
		dir = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
		
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
	if is_on_floor():
		double_jumped = false
		doublejumpparticles.emitting = false
		
	if is_on_floor() and abs(velocity.x) == speed:
		runparticles.emitting = true
	
	
	
	
	if velocity.x > 0:
		cast.cast_to = Vector2(15, 0)
	elif velocity.x < 0:
		cast.cast_to = Vector2(-15, 0)

func animate():
	if dir != 0:
		anim.play("walk")
	else:
		anim.play("idle")
		
	if dir < 0:
		anim.flip_h = true
	elif dir > 0:
		anim.flip_h = false
	
	if (!is_on_floor()):
		if velocity.y < 0:
			anim.play("jump")
		elif velocity.y > 0:
			anim.play("fall")
	if cast.is_colliding() and not is_on_floor():
		anim.play("wall_slide")
	
	var i = 0
	
	heartlist[0].visible = false
	heartlist[1].visible = false
	heartlist[2].visible = false
	
	while i < hp:
		
		heartlist[i].visible = true
		
		i += 1
		
	if $damageCooldown.time_left > 0.7:
		anim.play("hit")


func _process(_delta):
	if $damageCooldown.time_left > 0.1:
		anim.modulate = "abffffff"
	else:
		anim.modulate = "ffffff"
		
	var i = 0
	while i < hazardList.size():
		velocity.x = (position.x - hazardList[i].get_parent().position.x)*knockback
		velocity.y = -400
		i += 1
	
	if hp < 1:
		$CollisionShape2D.disabled = true
		anim.stop()
		fade.play("fadeout")
		yield(fade, "animation_finished")
		get_tree().reload_current_scene()
		


func _physics_process(delta):
	if $controlLock.time_left < 0.1:
		inputs()
	animate()
	
	
	if cast.is_colliding() and velocity.y > 0:
		velocity.y += slide_gravity*delta
		
	else:
		velocity.y += gravity*delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	


func _on_Hazard_Detection_area_entered(area):
	
	if area.is_in_group("Hazard"):
		if $damageCooldown.time_left < 0.1:
			hp -= 1
			$damageCooldown.start()
			$controlLock.start()
			hurt_sfx.play()
		hazardList.push_back(area)
		#velocity.x = (position.x - area.get_parent().position.x)*knockback
		#velocity.y = (position.y - area.get_parent().position.y)*knockback


func _on_Hazard_Detection_area_exited(area):
	if area.is_in_group("Hazard"):
		hazardList.erase(area)
