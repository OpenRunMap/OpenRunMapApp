#import "Route.js"

var target = UIATarget.localTarget();

var steps = route.steps;

target.delay(5);

for (var idx = 0; idx < steps.length; idx++) {
	var step = steps[idx];
	var coordinates = step.coordinates;
	var i = 0;
	while (i < coordinates.length) {
		var coordinate = coordinates[i];
		target.setLocation({latitude: coordinate.lat, longitude: coordinate.lon});
		target.delay(0.2);
		i++;
	}		
}