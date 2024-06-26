class_name Enemy extends CharacterBody2D

# Enemy Signals

# Enemy Properties
@export var health: float = 100
@export var speed: float = 700.0
@export var jump_velocity: float = -900.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var can_shoot: bool = true
var is_crouching: bool = false
var start_falling: bool = false
var stuck_under_obj: bool = false

# Enemy Attributes
var knockback_force := 200
var is_chasing: bool = false
var is_roaming: bool = false
#@onready var player_body: Node2D = $"Player Rig"
#@onready var player_collision: Node2D = $Collision
#@onready var crouch_front_raycast: Node2D = $CrouchFrontRayCast
#@onready var crouch_back_raycast: Node2D = $CroucBackRayCast
#var standing_collision = preload("res://Object Types/Main Assets/Player/player_standing.tres")
#var crouching_collision = preload("res://Object Types/Main Assets/Player/player_crouching.tres")

func _physics_process(delta):
     # Enemy is Moving
     if direction:
          velocity.x = direction.x * speed
     # Enemy Not Moving
     else:
          velocity.x = move_toward(velocity.x, 0, speed)

     # Enemy Falling
     if not is_on_floor():
          velocity.y += gravity * delta
          velocity.x = 0
          
     move_and_slide()


func _on_timer_timeout():
     $Timer.wait_time = choose([0.5, 1, 1.5])
     
     if !is_chasing:
          direction = choose([Vector2.RIGHT, Vector2.LEFT])
#          velocity.x = 0

func choose(array):
     array.shuffle()
     return array.front()
