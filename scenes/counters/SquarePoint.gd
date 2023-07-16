extends Control

func mark():
	$Marked.show()

func is_empty():
	$Marked.hide()

func is_marked():
	return $Marked.visible
	
