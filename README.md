A couple simple MATLAB simulations to settle the debate between walking and running in the rain.

Raindrop_SimpleTime.m moves through time, moving the position of each raindrop and checking for intersection with the hitbox every time.

Raindrop_DiscreteRayExtension.m works similarly, but iterates over each raindrops entire path at once. dividing it up into discrete points and checking for intersection with the hitbox.

Results.png shows the average of 100 Raindrop_DiscreteRayExtension runs for 20 different "walking speeds" between 0 and 3. These speeds are relative to the rain's falling speed.
