function seconds(_value) {
	return round(_value * game_get_speed(gamespeed_fps));	
}

function seconds_range(_min, _max) {
	return random_range(seconds(_min), seconds(_max));	
}

function minutes(_value) {
	return seconds(_value * 60);
}
