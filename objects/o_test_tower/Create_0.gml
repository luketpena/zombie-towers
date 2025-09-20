alarmSet = seconds(.5);
alarm[0] = irandom(alarmSet);
depth = -y;

hp = 15;
function damage(_value) {
	hp -= _value;
	if (hp <= 0) {
		instance_destroy();	
	}
}