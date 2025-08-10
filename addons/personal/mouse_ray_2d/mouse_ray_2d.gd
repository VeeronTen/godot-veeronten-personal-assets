@tool
@icon("res://addons/personal/mouse_ray_2d/mouse_ray_2d_icon.svg")
class_name MouseRay2D 
extends RayCast2D
## A ray to cast from and to the mouse position

var _restrictions: Restrictions = Restrictions.new()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		target_position = Vector2.ZERO
		hit_from_inside = true
		update_configuration_warnings()
	
func cast() -> String:
	if _restrictions.is_any_violated([
		Restriction.new(func() -> bool: 	return target_position == Vector2.ZERO, "`target_position` as mouse offset have to be 0"), 
		Restriction.new(func() -> bool: return hit_from_inside, "the ray length is 0, so it has to `hit_from_inside`")
	]): return ""
	global_position = get_global_mouse_position()
	force_raycast_update()
	if is_colliding():
		var node = get_collider() as Node2D
		return str(node.name)  
	else:
		return ""
