extends CanvasLayer

func update_game_timer(time):
	var minutes
	var hours
	var time_formatted
	if time > 60:
		minutes = time / 60
		time = time % 60
		time_formatted = str(time)+str(minutes)
	if time > 3600:
		hours = time / 60 / 60
		minutes = time / 60
		time = time % 3600
		time_formatted = str(time)+str(minutes)+str(hours)
	$GameTimerLabel.text(time_formatted)
