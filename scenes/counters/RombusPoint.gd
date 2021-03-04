extends Control

func mark():
	$Marked.show()
	$Crossed.hide()

func cross():
	$Crossed.show()

func empty():
	$Marked.hide()
	$Crossed.hide()

func is_full():
	return $Marked.visible or $Crossed.visible
	
