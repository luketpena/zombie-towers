width = 320;
height = 180;
mode = CameraMode.Object;

target = o_player;
target_x = 0;
target_y = 0;
focus = new Pos();

cam_speed = .1;
cam_x = target_x;
cam_y = target_y;
cam_height = 0;
sideOffset = 0;
camera = undefined;
zoom = 1;

global.vx = 0;
global.vy = 0;
global.vw = 0;
global.vh = 0;
global.zw = 0;
global.zh = 0;
global.vr = global.vx + global.vw;
global.vb = global.vy + global.vh;
global.hvw = global.vw / 2;
global.hvh = global.vh / 2;
global.hzw = global.zw / 2;
global.hzh = global.zh / 2;
global.dvw = global.vw * 2;
global.dvh = global.vh * 2;
global.midx = global.vx + global.hvw;
global.midy = global.vx + global.hvh;

global.guiw = 0;
global.guih = 0;

function focusOnLocation(_x, _y) {
	mode = CameraMode.Location;
	target_x = _x;
	target_y = _y;
}

function snapToTarget(newTarget = noone) {
	if (newTarget != noone) {
		target = newTarget;	
	}
	if (target == noone || !instance_exists(target)) exit;
	target_x = target.x;
	target_y = target.y;
	snapToPosition(target_x, target_y);
}

function snapToPosition(_x, _y) {
	cam_x = _x;
	cam_y = _y;
	
	var _new_x = cam_x - global.hzw;
	var _new_y = cam_y - global.hzh;
	camera_set_view_pos(view_camera[0], _new_x, _new_y);
}


function cam_set(_posOnly = false) {
	if (camera) {
		global.vx = camera_get_view_x(camera);
		global.vy = camera_get_view_y(camera);
		if (!_posOnly) {
			global.zw = global.vw * zoom;
			global.zh = global.vh * zoom;
	
			global.hvw = global.vw / 2;
			global.hvh = global.vh / 2;
			global.hzw = global.zw / 2;
			global.hzh = global.zh / 2;
			global.dvw = global.vw * 2;
			global.dvh = global.vh * 2;
	
		}

		global.vr = global.vx + global.vw;
		global.vb = global.vy + global.vh;
		global.midx = global.vx + global.hzw;
		global.midy = global.vy + global.hzh;
	}
}

function cam_init(_index, _target) {
	//>>this sets the ratio of the in-game camera size
	//var resolution_ratio = "16:9"; //0 = 16:9, 1 = 8:5, 2 = 5:4, 3 = 4:3
	//var camera_width, camera_height;
	//switch(resolution_ratio) {
	
	//	case "16:9":
	//	default:
	//		//>>16:9
	//		camera_width = display_get_width() / 5;
	//		camera_height = display_get_height() / 5;
	//	break;
	
	//	case "8:5":
	//		//>>8:5
	//		camera_width = 344;
	//		camera_height = 215;
	//	break;
	
	//	case "5:4":
	//		//>>5:4
	//		camera_width = 320;
	//		camera_height = 256;
	//	break;
	
	//	case "4:3":
	//		//>>4:3
	//		camera_width = 320;
	//		camera_height = 240;
	//	break;
	
	//}
	
	////>>setting up the camera
	//target = _target;
	//sysLog("Setting camera size:", camera_width, camera_height);
	view_camera[_index] = camera_create_view(0, 0, width, height, 0, noone, 0, 0, 0, 00);
	camera = view_camera[_index];
	cam_set();
	global.vw = camera_get_view_width(camera);
	global.vh = camera_get_view_height(camera);
	global.guiw = global.vw;
	global.guih = global.vh;
		
	//window_set_size(global.vw, global.vh);
	surface_resize(application_surface, global.vw, global.vh);
	display_set_gui_size(global.vw , global.vh);
}

cam_init(0, o_player);