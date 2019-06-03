/*!
 * Last updated: 04/03/2019
 */

const ITEM_PREFIX = '_bs4_Form';
const _ = require("lodash");

var  _itemIdx = 1;

/**
 * put the label and input control in the same row.
 * @param {*} ctrl an object created by exports.makeControl()
 * @param {*} col1 bootstrap column count of the first column (1 ~ 11)
 * @param {*} col2 bootstrap column count of the second column (1 ~ 11)
 */
exports.makeARow = function(ctrl, col1, col2)  {
    col2 = col2 || (12 - col1);

    let  row = xs.e('div', {class: 'form-group row'})
                 .add( ctrl.label.addClass('col-sm-' + col1 + ' col-form-label') );
            //   .add('div', {class: 'col-sm-' + col2}, ctrl.input);

    if (ctrl.help)
        row.add('div', {class: 'col-sm-' + col2}, [ctrl.input, ctrl.help]);
    else
        row.add('div', {class: 'col-sm-' + col2}, ctrl.input);

    return  row;
}


/**
 * Put checkbox (or radio button) and its label in a row.
 */
exports.makeACheckboxRow = function(ctrl)  {
    return  xs.html('div', {class: 'form-check'})
              .add( ctrl.input )
              .add( ctrl.label );
}


/**
 * Generate form input, including label, control and help.
 * @param {*} item 
 */
exports.makeControl = function(item)  {
    let  itemID = ITEM_PREFIX + _itemIdx++,
         labelProp,
         result = {};

    switch(item.type)  {
        case 'tel':
        case 'text':
        case 'email':
        case 'password':
        case 'number':
            labelProp = {
                class: 'bmd-label-floating',
                for: itemID
            };
            result.label = xs.e('label', labelProp, item.label);

            let  inputProp = {
                    id: itemID,
                    class: 'form-control',
                    type: item.type
                 };
            if (item.name)
                inputProp.name = item.name;
            if (item.value)
                inputProp.value = item.value;
            if (item.placeHolder)
                inputProp.placeHolder = item.placeHolder;
            if (item.maxLength)
                inputProp.maxlength = item.maxLength;
            if (item.required)
                inputProp.required = true;
            if (item.disabled)
                inputProp.disabled = true;
			if (item.onkeypress)
				inputProp.onkeypress = item.onkeypress;
			if (item.onkeydown)
				inputProp.onkeydown = item.onkeydown;

            result.input = xs.e('input', inputProp);

            if (item.help)
                 result.help = xs.e('small', {class: 'form-text text-muted'}, item.help);
            break;

        case 'textarea':
            labelProp = {
                class: 'col-form-label',
                for: itemID
            };
            result.label = xs.e('label', labelProp, item.label);

            let  taProp = {
                    id: itemID,
                    class: 'form-control'
                 };
            if (item.name)
                taProp.name = item.name;
            if (item.placeHolder)
                taProp.placeHolder = item.placeHolder;
            if (item.maxLength)
                taProp.maxlength = item.maxLength;
            if (item.required)
                taProp.required = true;
            if (item.disabled)
                taProp.disabled = true;

            result.input = xs.e('textarea', taProp, item.value || '');

            if (item.help)
                 result.help = xs.e('small', {class: 'form-text text-muted'}, item.help);
            break;

        case 'checkbox':
            labelProp = {
                class: 'form-check-label',
                for: itemID
            };
            result.label = xs.e('label', labelProp, item.label);

            let  ckboxProp = {
                    id: itemID,
                    class: 'form-check-input',
                    type: 'checkbox',
                    value: item.hasOwnProperty('value')  ?  item.value : 'yes'
                 };

            if (item.name)
                ckboxProp.name = item.name;

            if (item.checked)
                ckboxProp.checked = null;

            if (item.disabled)
                ckboxProp.disabled = true;

            result.input = xs.e('input', ckboxProp);
            break;

        case 'radio':
            let  input = [],
                 isDisabled = item.disabled  ?  true : false;

            item.radios.forEach( rdoItem => {
                input.push( makeRadio(rdoItem, isDisabled) );
            });

            result.label = xs.e('legend', {class: 'col-form-label pt-0'}, item.label);
            result.input = input;
            break;
    }
    if (item.help)
        result.help = xs.e('small', {class: 'form-text text-muted'}, item.help);

    return  result;
}


/**
 * make radio form control
 * @param rdoItem 
 */
function  makeRadio(rdoItem, isDisabled)  {
    let  itemID = ITEM_PREFIX + _itemIdx++,
         inputProp = {
            id: itemID,
            class: 'form-check-input',
            type: 'radio',
            name: 'gridRadios'
         },
         labelProp = {
             class: 'form-check-label',
             for: itemID
         };

    if (rdoItem.name)
        inputProp.name = rdoItem.name;

    if (rdoItem.hasOwnProperty('value'))
        inputProp.value = rdoItem.value;

    if (rdoItem.checked)
        inputProp.checked = true;

    if (isDisabled)
         inputProp.disabled = true;

    let  rdo = xs.e('div', {class: 'form-check'})
                 .add('input', inputProp)
                 .add('label', labelProp, rdoItem.label);

    return  rdo;
};

exports.getCalendarGrp = function(id , title , timeVal , opt) {
	
	let prop = {type:"text" , class:"form-control" , placeholder:"請輸入" + title , value: timeVal || "" , id:id};
	if (opt != null)
		prop = _.defaults( prop , opt);
		
	// 製作時間的輸入框以及 calendar 的 icon
	let input = xs.e("div" , {class:"input-group mb-0"})
                    .add("input" , prop)
                    .add("div" , {class:"input-group-prepend" , style:"margin-left:-1rem;"} , 
                        xs.e("span" , {class:"input-group-text"})
                            .add("i" , {class:"fa fa-calendar"})
                    );
	return input;
};