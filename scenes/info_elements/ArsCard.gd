extends NinePatchRect

func paint(ars_data):
	%ArsName.text = ars_data["name"]
	%ArsGroupName.text = ars_data["ars_group_name"]
	%Level.initial_level = ars_data["level"]
	%Level.refresh()
	%Challenge.text = ars_data["challenge"]
	%Target.text = ars_data["target"]
	%Range.text = ars_data["ars_range"]
	%CastTime.text = ars_data["casting_time"]
	%Cost.text = ars_data["cost"]
	%Duration.text = ars_data["duration"]
	%Maint.text = ars_data["maintenance"]
	%Description.text = ars_data["description"]
