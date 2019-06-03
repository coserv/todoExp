const  counter = require('./Counter');

exports.checkIn = {
    label: {
        '@required': true,
        '@type': 'string',
        '@error': 'The dropdown button should be given a label'
    },
    items: {
        '@required': true,
        '@type': 'string',
        '@error': 'The menu items should be contained in an array, with each item having a title and value'
    },
    buttonStyle: {
        '@default': 'btn-secondary',
        '@type': 'string',
        '@message': 'The button style should be a string like "btn-secondary"'
    },
    size: {
        '@default': 'medium',
        '@type': 'string',
        '@message': "The button size should be 'large', 'medium' or 'small'"
    },
    direction: {
        '@default': 'dropdowm',
        '@type': 'string',
        '@message': "The direction should be 'dropdown', 'dropup', 'dropleft', 'dropright"
    },
    menuAlignment: {
        '@default': 'left',
        '@type': 'string',
        '@message': "The menu item alignment can be set to 'left' or 'right'"
    }
}

exports.view = function(model)  {
    let  id = '_xs_dd' + counter.getDropdownIndex(),
         menuAlign = model.menuAlignment == 'right'  ?  ' dropdown-menu-right' : '',
         menu = xs.html('div', {class: 'dropdown-menu' + menuAlign, 'aria-labelledby': id});

    model.items.forEach(item => {
        menu.add( createItem(item.isDivider, item.title, item.value) );
    });

    let  prop = {
            class: 'btn ' + model.buttonStyle + toButtonSize(model.size) + ' dropdown-toggle',
            type: 'button',
            id: id,
            'data-toggle': 'dropdown',
            'aria-haspopup': 'true',
            'aria-expanded': 'false'
         };

    let  root = xs.uic('div', {class: 'btn-group' + toDirection(model.direction)})
                  .add('button', prop, model.label)
                  .add( menu );
    return  root;
}


function  createItem(isDivider, label, value)  {
    let  n;

    if (isDivider)
        n = xs.html('div', {class: 'dropdown-divider'});
    else
        n = xs.html('button', {class: 'dropdown-item', type: 'button', 'data-value': value}, label);
    return  n;
}


function  toButtonSize(size)  {
    let  claz = '';

    switch (size)  {
        case 'large':
            claz = ' btn-lg';
            break;

        case 'small':
            claz = ' btn-sm';
            break;
    }

    return  claz;
}


function  toDirection(direct)  {
    let  claz = ' dropdown';

    switch (direct)  {
        case 'dropup':
        case 'dropleft':
        case 'dropright':
            claz = ' ' + direct;
    }

    return  claz;
}


exports.control = function(b , model)  {
	const ITEMS = model.items || [];

    b.startup = function()  {
        b.find('.dropdown-menu button').off('click').on('click', function()  {
            b.curValue = $(this).data('value');
        });
    }

    b.setLabel = function(label)  {
        b.find('.btn-group > button').text( label );
    }

    b.getCurrentValue = function()  {
        return  b.curValue;
    }

    b.setCurrentValue = function(value)  {
		for (let index = 0; index < ITEMS.length; index++) {
			let item = ITEMS[index];
			
			if (item.value == value) {
				b.setLabel(item.title);
				b.curValue = item.value;
				break;
			}
		}
    }

    b.on = function(evtName, handler) {
        if (evtName == 'itemClicked')
            b.find('.dropdown-menu button').on('click', handler);
        else
            b.find('.dropdown-toggle').on( evtName, handler );
    }
}