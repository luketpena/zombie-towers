function test(_x = mouse_x, _y = mouse_y) {
	effect_create_above(ef_flare, _x, _y, .01, c_red);
}

function testx() {
	effect_create_below(ef_flare, x, y, .1, c_red);
}

function testx1(x, y) {
	effect_create_above(ef_flare, x, y, 1, c_red);
}

function testx2(x, y, col) {
	effect_create_above(ef_flare, x, y, 1, col);
}

function testx3(x, y, col, ef) {
	effect_create_above(ef, x, y, 1, col);
}

function log() {
	var finalString = "";
	for (var i=0; i<argument_count; i++) {
		if (i > 0) {
			finalString += " | ";	
		}
		finalString += string(argument[i]);	
	}
	show_debug_message(finalString);
}

function sysLog() {
	var finalString = "SYS: ";

	for (var i=0; i<argument_count; i++) {
		finalString += " | " + string(argument[i]);	
	}
	
	show_debug_message(finalString);
}

function fnLog() {
	var finalString = "FN: ";

	for (var i=0; i<argument_count; i++) {
		finalString += " | " + string(argument[i]);	
	}
	
	show_debug_message(finalString);
}

function errLog() {
	var finalString = "ERR: ";

	for (var i=0; i<argument_count; i++) {
		finalString += " | " + string(argument[i]);	
	}
	
	show_debug_message(finalString);
}