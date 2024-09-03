class_name RangedAttackComponent
extends AttackComponenent

@export var gun : Gun

var arena_group : String

func _ready():
	gun.set_physics_process(false)
	arena_group = ArenaUtilities.get_arena_name_by_position(global_position)
	if arena_group and arena_group not in get_groups():
		add_to_group(arena_group)


func _attack():
	var player = ArenaUtilities.find_closest_in_arena_by_group(self, "player", arena_group)
	if player:
		var direction = (player.global_position - global_position)
		gun.rotation = direction.angle()
	gun._fire()
