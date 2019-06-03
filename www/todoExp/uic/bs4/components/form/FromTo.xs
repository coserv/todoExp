const FormLIB = require("/lib/bs4/Form.js");
const FOREVER_TIME = "9999-12-31 23:59:59";

exports.view = function (value , ctx) {
	let validFrom = value.validFrom,
		validTo = (value.validTo == FOREVER_TIME) ? "" : value.validTo;

	let root = xs.uic("div")
				 .add(getCalendarGroup("起始時間" , "fromGrp" , "現在" , "fromTime-input" , validFrom, value.disabled))
				 .add(getCalendarGroup("結束時間" , "toGrp" , "永久" , "toTime-input" , validTo, value.disabled));

	return root;
};

function getCalendarGroup(title , name , defaultTitle , id , time, disabled) {
	let opt = {};
	if (!time || disabled) 
		opt.disabled = "disabled";

	let input = FormLIB.getCalendarGrp(id , title , time , opt);

	let radioProp0 = {type:"radio" , name:name , value:0 , id:"gridRadios0" + id},
		radoiProp1 = {type:"radio" , name:name , value:1 , id:"gridRadios1" + id};

	if (disabled) {
		radioProp0.disabled = "disabled";
		radoiProp1.disabled = "disabled";
	}
	
	let input0 = xs.html("input", radioProp0);
	let input1 = xs.html("input", radoiProp1);
			
	// 判別 radio button 要勾哪個選項
	!time ? input0.attr("checked" , "checked") : input1.attr("checked" , "checked");
	
	return xs.html("div", {class:"form-inline w-100"})
			 .add("span"  , {class:"mt-4 mr-2"} , title + "：")
			 .add("label" , {class:"radio-inline mt-5"} , [
				input0,
				xs.html("span" , {class:"text-dark" , style:"margin-top:-1.5rem;"} , defaultTitle)
			 ])
			 .add("label" , {class:"radio-inline mt-5 ml-4"} , input1)
			 .add(input);
};

exports.control = function (ctrl , value , ctx) {

	ctrl.startup = function() {

		initTimePicker("fromTime-input");
		initTimePicker("toTime-input");

		initTimeGrp("from");
		initTimeGrp("to");
	};

	function initTimePicker(inputID) {
		ctrl.find("#" + inputID).datetimepicker({
			format:'Y-m-d H:i:s'
		});
	};

	function initTimeGrp(fromOrTo) {
		ctrl.find('input[type=radio][name=' + fromOrTo + 'Grp]').change(function() {
			let $ele = ctrl.find(this);
			ctrl.find("#" + fromOrTo + "Time-input").prop("disabled" , parseInt($ele.val()) != 1);

			if (parseInt($ele.val()) == 1)
				ctrl.find("#" + fromOrTo + "Time-input").focus();
		});
	};

	ctrl.getFromTo = function() {
		let $fromTimeInput = ctrl.find("#fromTime-input");
		let $toTimeInput = ctrl.find("#toTime-input");
		let params = {};
		
		// fromTime 的取得
		let checkFrom = parseInt(ctrl.find('input[type=radio][name=fromGrp]:checked').val());
		let fromTime = $fromTimeInput.val();
		if (checkFrom == 1) {
			if (!fromTime) {
				$fromTimeInput.focus();
				return {code: 1 , message: "尚未輸入折扣的起始時間"};
			}
			params.fromTime = fromTime;
		}
		
		// toTime 的取得
		let checkTo = parseInt(ctrl.find('input[type=radio][name=toGrp]:checked').val());
		let toTime = $toTimeInput.val();
		if (checkTo == 1) {
			if (!toTime) {
				$toTimeInput.focus();
				return {code: 2 , message: "尚未輸入折扣的結束時間"};
			}
			params.toTime = toTime;
		}

		return {code:0 , message: "ok" , value: params};
	};
};