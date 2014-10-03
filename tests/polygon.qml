import QtQuick 2.3
import QtQuick.Controls 1.2
import '../components'

ApplicationWindow {
	visible: true;
	width: 640;
	height: 480;

	Polygon {
		id: polygon;
		anchors.fill: parent;
		color: 'orange';
		edge: 10;
		edgeOffset: 3;
		availableEdges: 0;
		border: 20

		Behavior on availableEdges {
			NumberAnimation {
				duration: 2000;
			}
		}
	}

	Component.onCompleted: {
		polygon.availableEdges = 10;
	}
}
