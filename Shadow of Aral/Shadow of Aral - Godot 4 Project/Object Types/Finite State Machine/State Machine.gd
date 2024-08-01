extends Node

# Finite State Machine Properties
@export var init_state: State

var cur_state: State
var states: Dictionary = {}

# Initialize the State
func _ready():
     # From the State Node Get Children Nodes
     for child in get_children():
          if child is State:
               states[child.name.to_lower()] = child
               child.Transitioned.connect(on_child_transition)
     
     # If State Exists Enter the State
     if init_state:
          init_state.Enter()
          cur_state = init_state
     
# Call the Process Update
func _process(delta):
     if cur_state:
          cur_state.Update(delta)

# Call the Physics Update
func _physics_process(delta):
     # If this State Exists Update It
     if cur_state:
          cur_state.Physics_Update(delta)
          
# Transition from Current to Next State
func on_child_transition(this_state, new_state_name):
     # Check New State Is Not Current State
     if this_state != cur_state:
          return
          
     # Get a new State from the Dictionary
     var new_state = states.get(new_state_name.to_lower())
     
     # If New State Exists
     if !new_state:
          return
     # If Current State Exists
     if cur_state:
          cur_state.Exit()
          
     # Enter New State and Update Current State to New
     new_state.Enter()
     cur_state = new_state
