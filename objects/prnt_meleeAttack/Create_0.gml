hitList = [];

// This needs to be detected by children in whatever way they need to
function impactTarget(_target) {
	if (!array_contains(hitList, _target)) {
		array_push(hitList, _target);
		if (is_callable(hit)) hit(_target) else {
			log("Melee attack is missimg hit() fn:", object_get_name(object_index));	
		};
	}
}