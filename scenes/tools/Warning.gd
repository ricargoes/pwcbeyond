extends NinePatchRect

func _ready():
	hide()

func send_warning(message):
	%Message.text = message
	show()
	$Fade.start()

func _on_Fade_timeout():
	hide()
