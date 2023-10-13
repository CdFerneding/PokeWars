extends CanvasLayer

var time = 0

func update_game_timer():
	var GameTimerLabel: Label = $HUDMainSeparation/PlayerMenu/GameInformation/GameTimerLabel
	var minutes
	var hours
	var time_formatted = ""
	if time > 3600:
		hours = time / 3600
		time_formatted += str(hours)+"h "
	if time > 60:
		minutes = (time / 60) % 60
		time_formatted += str(minutes)+"m "
	
	time_formatted += str(time % 60)+"s"
#	print(time_formatted)
	GameTimerLabel.text = str("Time : "+time_formatted)


func _on_timer_timeout():
	time+=1
	update_game_timer()

func _process(delta):
	var size = get_viewport().size
	$TextureRect.size.x = size.x
	offset.y = size.y - $HUDMainSeparation/PlayerMenu.size.y
	
