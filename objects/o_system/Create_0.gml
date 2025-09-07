global.pathGrid = mp_grid_create(0, 0, room_width / 16, room_height / 12, 16, 12);
mp_grid_add_instances(global.pathGrid, prnt_block, false);
gamepad_set_axis_deadzone(0, .3);

global.ecto = 0;