const FormLIB = require("/lib/bs4/Form.js");

exports.view = function (value , ctx) {
	let from = FormLIB.getCalendarGrp("from-input" , "起始時間");
	let to = FormLIB.getCalendarGrp("to-input" , "結束時間");

	let root = xs.uic("div" , {class:"form-inline"})
				 .add(from)
				 .add("div" , "&nbsp;～&nbsp;")
				 .add(to);
	return root;
};

exports.control = function (ctrl , value , ctx) {

	ctrl.startup = function() {

		initTimePicker("from-input");
		initTimePicker("to-input");
	};

	function initTimePicker(inputID) {
		ctrl.find("#" + inputID).datetimepicker({
			format:'Y-m-d H:i:s'
		});
	};
};