import QtQuick 2.3
import QtQuick.Controls 1.2
import '../components'

ApplicationWindow {
	visible: true;
	width: 640;
	height: 480;

	Circle {
		id: circle;
		anchors.fill: parent;
		color: 'orange';
		border: 20;
		angle: 0;

		Behavior on angle {
			NumberAnimation {
				duration: 2000;
				easing.type: Easing.OutCubic;
			}
		}
	}

	Component.onCompleted: {
		circle.angle = 360;
	}
}
