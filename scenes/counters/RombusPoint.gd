extends Control

func mark():
	$Marked.show()
	$Crossed.hide()

func cross():
	$Crossed.show()

func is_empty():
	$Marked.hide()
	$Crossed.hide()

func is_full():
	return $Marked.visible or $Crossed.visible
	
