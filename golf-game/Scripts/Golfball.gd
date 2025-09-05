extends RigidBody3D

signal reset()

var rollingBall = false
var shot_timer = 0.0
var wait_for_check = 1.0

var ClubUsed = [0, 0]
var pullBack = 0
var clubSpeed = 0

#Richtungsvariablen:
var force = 0
var upward = Vector3.UP

#Position
var oldPos = 0
var ballPosition = 0
var hit_length = 0

func _ready():
	$CameraRig.top_level = true
	
	
func _physics_process(_delta):
	#move camera to ball
	$CameraRig.global_transform.origin = lerp(
		$CameraRig.global_transform.origin,
		global_transform.origin, 0.1
	)
	
	if shot_timer >= wait_for_check and hasBallStopped():
		ballReset()
		#print("reset2")
		
func _process(delta: float) -> void:
	if rollingBall:
		shot_timer += delta
		

func _on_area_3d_area_entered(_area: Area3D) -> void:
	oldPos = global_transform.origin
	freeze = false
	force = ClubUsed[2] * clubSpeed * clubSpeed / 2 * pullBack  * ClubUsed[0] * cos(ClubUsed[1])
	print(clubSpeed)
	print(force)
	#print(pullBack)
	var forward = $CameraRig.basis.z.normalized()
	print("forward")
	print(forward)
	apply_central_force(upward * force * sin(ClubUsed[1]))
	apply_central_force(forward * force * cos(ClubUsed[1]))
	rollingBall = true
	print("HIT")

func ballReset():
	freeze = true
	rollingBall = false
	shot_timer = 0
	print(global_transform.origin)
	emit_signal("reset")
	ballPosition = global_transform.origin
	hit_length = sqrt((ballPosition.x - oldPos.x) * (ballPosition.x - oldPos.x) + (ballPosition.z - oldPos.z) * (ballPosition.z - oldPos.z))
	hit_length = sqrt(hit_length * hit_length)
	print(hit_length)
	print("reset")
 
func hasBallStopped():
	if rollingBall == true:
		var velocity = 0
		var velocityZX = 0
		velocity = linear_velocity.x + linear_velocity.z + linear_velocity.y
		velocity = sqrt(velocity * velocity)
		velocityZX = sqrt(linear_velocity.z * linear_velocity.z) + sqrt(linear_velocity.x * linear_velocity.x)
		if velocity < 0.15 and velocityZX < 0.15:
			return true
		#print(linear_velocity)


func _on_clubs_club_used(ClubStats):
	ClubUsed = ClubStats
	print(ClubStats)


func _on_club_sim_pull_back(shaftLength):
	pullBack = shaftLength
	pullBack = sqrt(pullBack * pullBack)
	#print(shaftLength)


func _on_club_sim_head_speed(headSpeed):
	clubSpeed = headSpeed
