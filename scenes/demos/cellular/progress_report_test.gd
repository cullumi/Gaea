@tool
extends Node

@export var start_time:int
@export var report_steps_immediately = false

@export var report_name:String = ""
@export var step_max:int = 0
@export var step:int = 0

@export var prev_step:int = 0
@export var prev_step_max:int = 0
@export var prev_report_name:String

func _process(_delta):
	if not report_steps_immediately:
		process_step()

func process_step():
	if step != prev_step:
		print("Progress: (%d/%d)" % [step, step_max])
		if (step == step_max):
			var time_elapsed :int = Time.get_ticks_msec() - start_time
			print("%s: Section took %s seconds" % [report_name,  (float(time_elapsed) / 1000)])
		prev_step = step

func _on_generation_finished():
	print("Generation Finished")

func _on_generation_progressed(steps:int):
	step = steps
	if report_steps_immediately or step >= step_max:
		process_step()

func _on_generation_section_started(step_count:int, section_name:String):
	step_max = step_count
	report_name = section_name
	step = 0
	start_time = Time.get_ticks_msec()
	print("Section: %s (0/%d)" % [section_name, step_count])

func _on_generation_started():
	print("Generation Started")
