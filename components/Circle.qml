import QtQuick 2.3

Item {
	id: circle;
	property color color: 'white';
    property real centerWidth: width / 2;
    property real centerHeight: height / 2;
    property real border: 1;
    property real angleOffset: 0;
    property real angle: 360;
    property real doublePI: 2 * Math.PI;

    onColorChanged: canvas.requestPaint()
	onAngleChanged: canvas.requestPaint()
	onAngleOffsetChanged: canvas.requestPaint()
	onBorderChanged: canvas.requestPaint()

	Canvas {
		id: canvas;
		anchors.fill: parent;
		antialiasing: true;

		property real radius: Math.min(width, height) / 2;
	    property real angle: (circle.angle / 360) * doublePI;
		property real angleOffset: (circle.angleOffset / 360) * doublePI - Math.PI / 2;
		property real cx: centerWidth + Math.cos(angle + angleOffset) * (radius - border);
		property real cy: centerHeight + Math.sin(angle + angleOffset) * (radius - border);
		property real startX: centerWidth + Math.cos(angleOffset) * radius;
		property real startY: centerHeight + Math.sin(angleOffset) * radius;

		onPaint: {
			var ctx = getContext('2d');
			ctx.save();

			ctx.clearRect(0, 0, circle.width, circle.height);

			// Drawing circle
			ctx.beginPath();
			ctx.fillStyle = circle.color;
			ctx.arc(circle.centerWidth,
					circle.centerHeight,
					radius,
					angleOffset,
					angleOffset + angle);
			ctx.lineTo(centerWidth, centerHeight);
			ctx.closePath();
			ctx.fill();

			// Remove inner circle
			ctx.globalCompositeOperation = 'destination-out';
			ctx.beginPath();
			ctx.arc(circle.centerWidth,
					circle.centerHeight,
					radius - circle.border,
					0,
					2 * Math.PI);
			ctx.fill();

			ctx.restore();

		}
	}

	function isPointInArea(mouseX, mouseY) {

			var vector = {
				x: mouseX - centerWidth,
				y: mouseY - centerHeight
			};

			// Figure radius
			var r = Math.sqrt(Math.pow(vector.x, 2) + Math.pow(vector.y, 2));
			if (r > canvas.radius)
				return false;

			if (r < canvas.radius - circle.border)
				return false;

			// Figure angle
			var theta = Math.atan2(vector.y, vector.x);

			var startAngle = canvas.angleOffset;
			var endAngle = canvas.angleOffset + canvas.angle;
			if (theta >= startAngle && theta < endAngle)
				return true;

			if (theta < 0)
				theta += doublePI;

			if (theta < startAngle || theta > endAngle)
				return false;

			return true;
	}
}
