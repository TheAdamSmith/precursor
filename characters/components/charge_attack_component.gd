class_name ChargeAttackComponent
extends AttackComponenent

@export var dash_component : DashComponent

var arena_group : String


func _ready():
	dash_component.set_process_unhandled_input(false)
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)


func _attack():
	var player = ArenaUtilities.find_closest_in_arena_by_group(self, "player", arena_group)
	if not player:
		return
	var direction = player.global_position - global_position
	enemy.move_direction = direction
	dash_component.dash()
