const  BsForm = require('/lib/bs4/Form');

exports.checkIn = {
    items: {
        '@required': true,
        '@type': [],
        '@error': 'The [items] parameter is required and should be an array'
    },
    labelColCount: {
        '@type': 'integer',
        '@default': 2,
        '@error': 'The [labelColCount] parameter should be an integer between 1 and 10.'
    },
    controlColCount: {
        '@type': 'integer',
        '@default': 10,
        '@error': 'The [controlColCount] parameter should be an integer between 2 and 11.'
    }
}

exports.view = function(params)  {
    let  root = xs.uic('form'),
         labelCol = params.labelColCount,
         ctrlCol = params.controlColCount;

    params.items.forEach( item => {
        if (item.type == 'hr')
            roor.add('hr');
        else
            root.add( makeControl(item, labelCol, ctrlCol) );
    });

    return  root;
}


exports.control = function(ctrl)  {

    ctrl.getFormData = function()  {
        let  fdata = this.find('form').serializeArray(),
             fsData = {};

        for (let i = 0, len = fdata.length; i < len; i++)  {
            let  item = fdata[i];
            fsData[item.name] = item.value;
        }

        return  fsData;
    }

    ctrl.clearForm = function()  {
        ctrl.find('input').val('');
    }
}


/**
 * Form control generator
 * @param item 
 */
function  makeControl(item, labelCol, ctrlCol)  {
    let  row,
         itemUI = BsForm.makeControl( item ),
         labelColClass = 'col-sm-' + labelCol,
         ctrlColClass = ctrlCol > 0  ?  ('col-sm-' + ctrlCol) : 'col-sm';

    switch(item.type)  {
        case 'text':
        case 'tel':
        case 'email':
        case 'password':
        case 'textarea':
            row = xs.html('div', {class: 'form-group'});

            row.add( itemUI.label)
            //    .nest('div', {class: ctrlColClass})
               .add( itemUI.input)
               .addIf(item.help, itemUI.help);

            break;

        case 'checkbox':
            row = xs.html('div', {class: 'form-group'});

            row.add('div', {class: labelColClass}, item.label)
               .nest('div', {class: ctrlColClass})
               .nest('div', {class: 'form-check'})
               .add( itemUI.input )
               .add( itemUI.label );
            break;

        case 'radio':
            let  divRdo = xs.html('div', {class: ctrlColClass});

            itemUI.input.forEach( rdoItem => divRdo.add( rdoItem ) );

            let  divRow = xs.html('div', {class: 'row'})
                            .add( itemUI.label.addClass(labelColClass) )
                            .add( divRdo );

            row = xs.html('fieldset', {class: 'form-group'}, divRow);
            break;
    }

    return  row;
}