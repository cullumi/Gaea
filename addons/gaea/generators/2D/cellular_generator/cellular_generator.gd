@tool
@icon("cellular_generator.svg")
class_name CellularGenerator
extends GaeaGenerator2D
## Generates a random noise grid, then uses cellular automata to smooth it out.
## Useful for islands-like terrain.
## @tutorial(Generators): https://benjatk.github.io/Gaea/#/generators/
## @tutorial(CellularGenerator): https://benjatk.github.io/Gaea/#/generators/cellular

## Decides whether any tile coordinates under the noise density threshold should be cleared.
@export var clear_under_threshold: bool = false
@export var settings: CellularGeneratorSettings


func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		push_warning("%s: Editor Preview is not enabled so nothing happened!" % name)
		return

	if not settings:
		push_error("%s doesn't have a settings resource" % name)
		return

	generation_started.emit()
	var time_now :int = Time.get_ticks_msec()

	if starting_grid == null:
		erase()
	else:
		grid = starting_grid

	_set_noise()
	_smooth()
	_apply_modifiers(settings.modifiers)

	if is_instance_valid(next_pass):
		next_pass.generate(grid)
		return

	var time_elapsed :int = Time.get_ticks_msec() - time_now
	if OS.is_debug_build():
		print("%s: Generating took %s seconds" % [name,  (float(time_elapsed) / 1000)])

	grid_updated.emit()
	generation_finished.emit()


func _set_noise() -> void:
	for x in range(settings.world_size.x):
		for y in range(settings.world_size.y):
			if randf() > settings.noise_density:
				grid.set_valuexy(x, y, settings.tile, settings.tile.tilemap_layer)
			elif clear_under_threshold:
				grid.set_valuexy(x, y, null, settings.tile.tilemap_layer)


func _smooth() -> void:
	for i in settings.smooth_iterations:
		var _temp_grid: GaeaGrid = grid.clone()

		for cell in grid.get_cells(settings.tile.layer):
			var dead_neighbors_count: int = grid.get_amount_of_empty_neighbors(cell, settings.tile.layer)
			if grid.get_value(cell, settings.tile.layer) != null and dead_neighbors_count > settings.max_floor_empty_neighbors:
				_temp_grid.set_value(cell, null)
			elif grid.get_value(cell, settings.tile.layer) == null and dead_neighbors_count <= settings.min_empty_neighbors:
				_temp_grid.set_value(cell, settings.tile)

		grid = _temp_grid

	grid.erase_invalid()


### Editor ###


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray

	if not settings:
		warnings.append("Needs CellularGeneratorSettings to work.")

	return warnings
