import QtQuick 2.3
import QtGraphicalEffects 1.0

Item {
	id: circle;
	property color color: 'white';
    property real centerWidth: width / 2;
    property real centerHeight: height / 2;
    property real border: 1;
    property real angleOffset: 0;
    property real angle: 360;
    property real doublePI: 2 * Math.PI;

	property int mark: 1;
	property real unitAngle: angle / mark;
	property real angleMarginFactor: 1;
	property real angleMargins: (unitAngle * angleMarginFactor) / mark;

	property bool useGradient: false;

	onMarkChanged: canvas.requestPaint()
	onAngleMarginFactorChanged: canvas.requestPaint()

    onColorChanged: canvas.requestPaint()
	onAngleChanged: canvas.requestPaint()
	onAngleOffsetChanged: canvas.requestPaint()
	onBorderChanged: canvas.requestPaint()

	Canvas {
		id: canvas;
		anchors.fill: parent;
		antialiasing: true;
		visible: !useGradient;
		renderStrategy: Canvas.Threaded;
//		renderTarget: Canvas.FramebufferObject;

		property real radius: Math.min(width, height) / 2;
		property real angleMargins: (circle.mark > 1) ? (circle.angleMargins / 360) * doublePI : 0;
		property real unitAngle: (circle.unitAngle / 360) * doublePI;
	    property real angle: (circle.angle / 360) * doublePI;
		property real angleOffset: (circle.angleOffset / 360) * doublePI - Math.PI / 2;
//		property real cx: centerWidth + Math.cos(angle + angleOffset) * (radius - border);
//		property real cy: centerHeight + Math.sin(angle + angleOffset) * (radius - border);
		property real startX: centerWidth + Math.cos(angleOffset) * radius;
		property real startY: centerHeight + Math.sin(angleOffset) * radius;

		onPaint: {
			var ctx = getContext('2d');
			ctx.save();

			ctx.clearRect(0, 0, circle.width, circle.height);

			// Drawing circle
			ctx.fillStyle = circle.color;

			for (var index = 0; index < mark; index++) {
				var offset = angleOffset + index * unitAngle;
				ctx.beginPath();
				ctx.arc(circle.centerWidth,
						circle.centerHeight,
						radius,
						offset,
						offset + unitAngle - angleMargins);
				ctx.lineTo(centerWidth, centerHeight);
				ctx.closePath();
				ctx.fill();
			}

			// Remove inner circle
			if (circle.border < radius) {
				ctx.globalCompositeOperation = 'destination-out';
				ctx.beginPath();
				ctx.arc(circle.centerWidth,
						circle.centerHeight,
						radius - circle.border,
						0,
						2 * Math.PI);
				ctx.fill();
			}

			ctx.restore();
		}
	}

	OpacityMask {
		anchors.fill: canvas;
		source: canvas;
		maskSource: gradientMask
		cached: true;
		visible: useGradient;
	}

	Item {
		id: gradientMask

		anchors.fill: parent;
		visible: false;

		RadialGradient {
			anchors.fill: parent;
			cached: true;
			gradient: Gradient {
				GradientStop { position: 0.48; color: '#00ffffff' }
				GradientStop { position: 0.53; color: '#ffffffff' }
			}
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

	Component.onCompleted: {
		canvas.requestPaint();
	}
}
