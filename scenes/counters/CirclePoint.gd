extends Control

func fill():
	$Permanent.hide()
	$Full.show()

func permanent():
	$Full.hide()
	$Permanent.show()

func empty():
	$Full.hide()
	$Permanent.hide()

func is_full():
	return $Full.visible or $Permanent.visible
	
