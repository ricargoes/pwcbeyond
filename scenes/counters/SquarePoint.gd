extends Control

func mark():
	$Marked.show()

func empty():
	$Marked.hide()

func is_marked():
	return $Marked.visible
	
