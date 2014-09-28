import QtQuick 2.3

Item {
	id: circle;
	property color color: 'white';
    property real centerWidth: width / 2;
    property real centerHeight: height / 2;
    property real border: 1;
    property real angleOffset: -Math.PI / 2;
    property real angle: 360;

    onColorChanged: canvas.requestPaint()
	onAngleChanged: canvas.requestPaint()
	onBorderChanged: canvas.requestPaint()

	Canvas {
		id: canvas;
		anchors.fill: parent;
		antialiasing: true;

		property real radius: (Math.min(width, height) / 2) - Math.floor(circle.border * 0.5);
	    property real angle: (circle.angle / 360) * 2 * Math.PI;

		onPaint: {
			var ctx = getContext('2d');
			ctx.save();

			ctx.clearRect(0, 0, circle.width, circle.height);

			// Drawing circle
			ctx.beginPath();
			ctx.lineWidth = circle.border;
			ctx.strokeStyle = circle.color;
			ctx.arc(circle.centerWidth,
					circle.centerHeight,
					radius,
					circle.angleOffset,
					circle.angleOffset + angle);
			ctx.stroke();

			ctx.restore();
		}
	}
}
