import QtQuick 2.3

Item {
	id: polygon;
	property color color: 'white';
    property real centerX: width / 2;
    property real centerY: height / 2;
	property real border: 1;
	property int edge: 3;
	property int edgeOffset: 0;
	property int availableEdges: edge;
    property real doublePI: 2 * Math.PI;

	onWidthChanged: canvas.requestPaint()
	onHeightChanged: canvas.requestPaint()
    onColorChanged: canvas.requestPaint()
	onBorderChanged: canvas.requestPaint()
	onEdgeChanged: canvas.requestPaint()
	onEdgeOffsetChanged: canvas.requestPaint()
	onAvailableEdgesChanged: canvas.requestPaint()

	Canvas {
		id: canvas;
		anchors.fill: parent;
		antialiasing: true;

		property real radius: Math.min(polygon.centerX, polygon.centerY);
		property real angle: doublePI / polygon.edge;
		property real baseAngle: -doublePI * 0.25;

		onPaint: {
			var ctx = getContext('2d');
			ctx.save();

			ctx.clearRect(0, 0, polygon.width, polygon.height);

			// No need to draw 
			if (availableEdges == 0) {
				ctx.restore();
				return;
			}

			// Drawing Triangle
			ctx.beginPath();
			ctx.fillStyle = polygon.color;

			// Figure edge number
			var edgeNum = availableEdges + polygon.edgeOffset;
			edgeNum++;

			// Outer
			for (var index = polygon.edgeOffset; index < edgeNum; index++) {

				var _angle = baseAngle + angle * index
				var vertexX = polygon.centerX + Math.cos(_angle) * radius;
				var vertexY = polygon.centerY + Math.sin(_angle) * radius;

				// First vertex
				if (index == polygon.edgeOffset) {
					ctx.moveTo(vertexX, vertexY);
					continue;
				}

				ctx.lineTo(vertexX, vertexY);
			}

			if (polygon.availableEdges < edge) {
				// Center of polygon
				ctx.lineTo(polygon.centerX, polygon.centerY);
			}
			ctx.closePath();
			ctx.fill();

			// Inner
			ctx.globalCompositeOperation = 'destination-out';
			ctx.beginPath();

			for (var index = 0; index < edge; index++) {

				var _angle = baseAngle + angle * index
				var _radius = radius - polygon.border;
				var vertexX = polygon.centerX + Math.cos(_angle) * _radius;
				var vertexY = polygon.centerY + Math.sin(_angle) * _radius;

				// First vertex
				if (index == 0) {
					ctx.moveTo(vertexX, vertexY);
					continue;
				}

				ctx.lineTo(vertexX, vertexY);
			}

			ctx.closePath();
			ctx.fill();

			ctx.restore();

		}
	}

	Component.onCompleted: {
		canvas.requestPaint();
	}
}
