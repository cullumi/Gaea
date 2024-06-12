@tool
extends Node

@export var report_increment:int = 1000
@export var report_name:String = ""
@export var step_max:int = 0
@export var step:int = 0
@export var tried_once:bool = false
@export var try_only_once:bool = false
@export var start_time:int

func _on_generation_finished():
	print("Generation Finished")

func _on_generation_progressed(steps:int):
	step += steps
	if (not try_only_once or not tried_once):
		if (not (step % report_increment) or step == step_max):
			tried_once = true
			print("Progress: (%d/%d)" % [step, step_max])
			if (step == step_max):
				var time_elapsed :int = Time.get_ticks_msec() - start_time
				print("%s: Section took %s seconds" % [report_name,  (float(time_elapsed) / 1000)])

func _on_generation_section_started(step_count:int, section_name:String):
	step_max = step_count
	report_name = section_name
	step = 0
	start_time = Time.get_ticks_msec()
	tried_once = false
	print("Section: %s (0/%d)" % [section_name, step_count])

func _on_generation_started():
	print("Generation Started")
