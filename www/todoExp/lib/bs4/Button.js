exports.create = function(config, text)  {
    if (text == undefined)  {
        text = config;
        config = null;
    }

    let  claz = 'btn',
         prop = {
             type: 'button'
         };

    if (config)
        config.split('/').forEach(s => claz += ' btn-' + s);
    else
        claz += ' btn-primary';
    prop.class = claz;
    
    return  xs.html('button', prop, text);
}


exports.createToggle = function(config, text, isActive)  {
    let  btn = exports.create( config, text );
    btn.attr('data-toggle', 'button');

    if (isActive)
        btn.addClass('active')
           .attr('aria-pressed', 'true');

    return  btn;
}


exports.createGroup = function(buttons)  {
    let  prop = {
            class: 'btn-group',
            role: 'group'
         },
         g = xs.html('div', prop);

    buttons.forEach( b => g.add( b ) );
    return  g;
}


exports.createToggleGroup = function(config, items, handler)  {
    if (items == undefined)  {
        items = config;
        config = null;
    }

    let  prop = {
            class: 'btn-group btn-group-toggle',
            'data-toggle': 'buttons'
         },
         g = xs.html('div', prop);

    items.forEach( item => {
        g.add( toggleInput(config, item.name, item.value, item.text, item.isActive, handler) );
    })

    return  g;
}


function  toggleInput(config, name, value, text, isActive, handler)  {
    let  claz = 'btn',
         inProp = {
             type: 'radio',
             autocomplete: 'off'
         };
    if (name)
        inProp.name = name;
    if (value)
        inProp.value = value;

    if (config)
        config.split('/').forEach(s => claz += ' btn-' + s);
    else
        claz += ' btn-primary';

    if (isActive)  {
         claz += ' active';
         inProp.checked = true;
    }

    let  radio = xs.html('input', inProp);
    if (handler)
        radio.on('change', handler);
    
    return  xs.html('label', {class: claz})
              .add(radio)
              .addText( text );
}


exports.createToolbar = function(items)  {
    let  prop = {
            class: 'btn-toolbar',
            role: 'toolbar'
         },
         bar = xs.html('div', prop);

    items.forEach( b => bar.add( b ) );
    return  bar;
}