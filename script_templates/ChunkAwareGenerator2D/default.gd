@tool
extends ChunkAwareGenerator2D


# Change this to a custom resource class that extends GeneratorSettings2D.
@export var settings: GeneratorSettings2D


func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		push_warning("%s: Editor Preview is not enabled so nothing happened!" % name)
		return

	if not settings:
		push_error("%s doesn't have a settings resource" % name)
		return

	var time_now: int = Time.get_ticks_msec()

	generation_started.emit()

	if starting_grid == null:
		erase()
	else:
		grid = starting_grid

	# Write your generation code here.

	if is_instance_valid(next_pass):
		next_pass.generate(grid)
		return

	var time_elapsed :int = Time.get_ticks_msec() - time_now
	if OS.is_debug_build():
		print("%s: Generating took %s seconds" % [name, float(time_elapsed) / 100 ])

	grid_updated.emit()
	generation_finished.emit()


func generate_chunk(chunk_position: Vector2i, starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		push_warning("%s: Editor Preview is not enabled so nothing happened!" % name)
		return

	if not settings:
		push_error("%s doesn't have a settings resource" % name)
		return

	if starting_grid == null:
		erase_chunk(chunk_position)
	else:
		grid = starting_grid

	# Write your generation code here.

	generated_chunks.append(chunk_position)

	if is_instance_valid(next_pass):
		if not next_pass is ChunkAwareGenerator2D:
			push_error("next_pass generator is not a ChunkAwareGenerator2D")
		else:
			next_pass.generate_chunk(chunk_position, grid)
			return

	chunk_updated.emit(chunk_position)
	chunk_generation_finished.emit(chunk_position)
