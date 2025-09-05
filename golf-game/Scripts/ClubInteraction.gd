extends CharacterBody3D

signal pullBack(shaftLength)
signal headSpeed(headSpeed)

var speed = 0
var moveDir = Vector3.FORWARD

var clubSpeed = 0
const max_speed = 30
var clubTTTmeasure = 0
var clubTimeToTravel = 0.1

var clubLength = 0
var pullback = 0

var pos = Vector3()

func _ready() -> void:
	pass
	
func _process(delta: float) -> void: #für performance ggf in physics_process umwandeln
	var input_strength = Input.get_axis("back", "forward")
	
	var pullback_max = sqrt((clubLength * clubLength) + (0.7 * 0.7)) * PI * 5/8 * input_strength
	if pullback >= pullback_max:
		pullback = pullback_max
	
	if input_strength == -1:
		clubTTTmeasure += delta
	if Input.is_action_pressed("back"):
		emit_signal("pullBack", pullback)

	if Input.is_action_pressed("forward") and input_strength > 0.2:
		print(clubTTTmeasure)
		if input_strength == 1:
			clubTimeToTravel = clubTTTmeasure
			#print(clubTimeToTravel)
		clubSpeed = pullback / clubTimeToTravel * 3
		clubSpeed = sqrt(clubSpeed * clubSpeed)
		if clubSpeed > max_speed:
			clubSpeed = max_speed
		emit_signal("headSpeed", clubSpeed)
		print(clubSpeed)
		speed = 1
		
	if Input.is_action_just_released("back"):
		pass

	move_and_collide(moveDir * speed * delta)
	
func _physics_process(_delta: float) -> void:
	pass


func _on_area_3d_area_entered(_area: Area3D) -> void:
	speed = 0
	print("STOP")


func _on_clubs_club_used(ClubStats: Variant) -> void:
	clubLength = ClubStats[0]


func _on_ball_reset():
	var Ball = $"../Ball"
	pos = Ball.global_transform.origin
	pos.z =  pos.z + 0.2
	print(pos)
	global_position = pos
	speed = 0
	pullback = 0
	clubTTTmeasure = 0
	clubTimeToTravel = 0
