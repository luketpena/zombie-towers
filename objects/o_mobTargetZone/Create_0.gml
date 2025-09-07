width = 64 * image_xscale;
height = 64 * image_yscale;

function getPosition() {
	return new Pos(x + random(width), y + random(height));	
}

r = x + width;
b = y + height;