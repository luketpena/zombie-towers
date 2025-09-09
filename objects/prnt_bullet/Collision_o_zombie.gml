other.damage(1, owner);
other.shove(moveDirection, 5);
if (is_callable(onImpact)) onImpact();
instance_destroy();