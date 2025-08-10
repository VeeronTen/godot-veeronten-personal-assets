extends GutTest

var mouse_ray_2d: MouseRay2D
	
func before_each() -> void:
	mouse_ray_2d = MouseRay2D.new()
	mouse_ray_2d._restrictions.violation_report_mode = Restrictions.ViolationReportMode.SILENT_TEST

func test_cast_restrictions() -> void:
	mouse_ray_2d.target_position = Vector2.DOWN
	mouse_ray_2d.hit_from_inside = false
	mouse_ray_2d.cast()
	assert_ne(mouse_ray_2d._restrictions.last_violations_count, 0, "ray was configured wrong")

func test_cast_to_nothing():
	mouse_ray_2d.target_position = Vector2.ZERO
	mouse_ray_2d.hit_from_inside = true
	assert_eq(mouse_ray_2d.cast(), "", "there was no target colladir")
	

func test_cast():
	var test_area = Area2D.new()
	add_child(test_area)
	test_area.name = "target"
	
	var collision = CollisionShape2D.new()
	test_area.add_child(collision)
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(10000, 10000)
	collision.global_position = mouse_ray_2d.get_global_mouse_position() - Vector2(500, 500)
	
	add_child(mouse_ray_2d)
	mouse_ray_2d.target_position = Vector2.ZERO
	mouse_ray_2d.hit_from_inside = true
	mouse_ray_2d.collide_with_areas = true
	
	simulate(self, 1, 1)
	assert_eq(mouse_ray_2d.cast(), test_area.name, "there was a target collider")
