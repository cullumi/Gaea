@tool
class_name ThreadedGeneratorStarter
extends GaeaGenerator
## @experimental

@export var threaded:bool = true
@export var generator:GaeaGenerator

var queued:Callable
var task:int = -1

func _process(_delta):
	if task > -1:
		if WorkerThreadPool.is_task_completed(task):
			WorkerThreadPool.wait_for_task_completion(task)
			task = -1
			run_job(queued)

func generate(starting_grid: GaeaGrid = null) -> void:
	if not threaded:
		generator.generate()
	else:
		var job:Callable = func ():
			generator.generate()
		
		if task > -1:
			queued = job
		else:
			run_job(job)

func run_job(job:Callable):
	if job:
		task = WorkerThreadPool.add_task(job, false, "Some Threaded Job")

