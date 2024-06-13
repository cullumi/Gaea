@tool
@icon("cellular_generator.svg")
class_name CellularGenerator
extends GaeaGenerator2D
## Generates a random noise grid, then uses cellular automata to smooth it out.
## Useful for islands-like terrain.
## @tutorial(Generators): https://benjatk.github.io/Gaea/#/generators/
## @tutorial(CellularGenerator): https://benjatk.github.io/Gaea/#/generators/cellular


@export var settings: CellularGeneratorSettings


func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		push_warning("%s: Editor Preview is not enabled so nothing happened!" % name)
		return

	if not settings:
		push_error("%s doesn't have a settings resource" % name)
		return

	(func(): generation_started.emit()).call_deferred()
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

	(func(): grid_updated.emit()).call_deferred()
	(func(): generation_finished.emit()).call_deferred()


func _set_noise() -> void:
	emit_section(settings.world_size.x * settings.world_size.y, "Applying Noise")
	var item_count:int = 0
	var row_count:int = 0
	for x in range(settings.world_size.x):
		for y in range(settings.world_size.y):
			if randf() > settings.noise_density:
				grid.set_valuexy(x, y, settings.tile)
			else:
				grid.set_valuexy(x, y, null)
			emit_progress((settings.world_size.y * x) + (y + 1))
		emit_progress(settings.world_size.y * (x+1))
	emit_progress(settings.world_size.x * settings.world_size.y)


func _smooth() -> void:
	var cells = grid.get_cells(settings.tile.layer)
	emit_section(settings.smooth_iterations * cells.size(), "Smoothing")
	for i in settings.smooth_iterations:
		var _temp_grid: GaeaGrid = grid.clone()
		
		var c:int = 0
		for cell in cells:
			var dead_neighbors_count: int = grid.get_amount_of_empty_neighbors(cell, settings.tile.layer)
			if grid.get_value(cell, settings.tile.layer) != null and dead_neighbors_count > settings.max_floor_empty_neighbors:
				_temp_grid.set_value(cell, null)
			elif grid.get_value(cell, settings.tile.layer) == null and dead_neighbors_count <= settings.min_empty_neighbors:
				_temp_grid.set_value(cell, settings.tile)
			c += 1
			emit_progress((cells.size() * i) + c)
		emit_progress(cells.size() * (i+1))

		grid = _temp_grid
	emit_progress(settings.smooth_iterations * cells.size())

	grid.erase_invalid()


### Editor ###


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray

	if not settings:
		warnings.append("Needs CellularGeneratorSettings to work.")

	return warnings
