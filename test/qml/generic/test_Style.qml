/*
 * \copyright Copyright (c) 2018-2019 Governikus GmbH & Co. KG, Germany
 */

import QtTest 1.10

TestCase {
	name: "ModuleLoadingStyle"
	id: parent

	function test_load_NpaBusyIndicatorStyle() {
		var item = createTemporaryQmlObject("
			import Governikus.Style 1.0;
			NpaBusyIndicatorStyle {}
			", parent);
		item.destroy();
	}

	function test_load_Style() {
		var item = createTemporaryQmlObject("
			import QtQuick 2.0;
			import Governikus.Style 1.0;
			Item {}
			", parent);
		item.destroy();
	}
}
