const  counter = require('./Counter');

exports.checkIn = {
    tabs: {
        '@required': true,
        //'@type': checkTabParameter,
        '@error': 'The [tabs] parameter is required and should be an array.'
    },
    tabStyle: {
        '@default': 'tab'
    }
}


function  checkTabParameter(tabs)  {
    let  msg = null;

    tabs.some( t => {
        if (!t.title)
            msg = 'Every tab should have the [title] parameter.';
        if (!t.body)
            msg = 'Every tab should have the [body] parameter.';

        return  msg != null;
    });
    return  msg;
}


exports.view = function(params)  {
    let  css = {
            '.tab-pane': {
                overflow: 'scroll'
            }
         };

    // now the build process...
    let  tabStyle = params.tabStyle === 'pill'  ?  'nav nav-pills' : 'nav nav-tabs',
         ul = xs.html('ul', {class: tabStyle, role: 'tablist'}, null);

    // Nav tabs
    params.tabs.forEach( t => {
        let  tabID = '_xs_tab' + counter.getTabIndex(),
             aProp = {
                class: 'nav-link',
                href: '#' + tabID,
                'aria-controls': tabID, 
                role: 'tab', 
                'data-toggle': params.tabStyle
             };
        t.id = tabID;
        if (t.isActive)
             aProp.class = 'nav-link active';

        ul.nest('li', {class: 'nav-item'})
          .add('a', aProp, t.title);
    });

    // Tab panes
    let  panes = xs.html('div', {class: 'tab-content'});
    activeProp = {role: 'tabpanel', class: 'tab-pane active'},
    normalProp = {role: 'tabpanel', class: 'tab-pane'};

    params.tabs.forEach( t => {
        let  pProp = {role: 'tabpanel'};
        pProp.class = t.isActive  ?  'tab-pane active' : 'tab-pane';
        pProp.id = t.id;

        panes.nest('div', pProp)
             .add( t.body );
    });

    let  tab = xs.uic('div', null, [ul, panes], css);
    return  tab;
}


exports.control = function(b, params)  {

    b.on = function(evName, func)  {
        this.find('a[data-toggle="tab"]').on( evName, func );
    }

    b.show = function(tabID)  {
        this.find('#' + tabID).tab('show');
    }


    b.activeTab = function()  {
        return  this.find('a[class~="active"]').text();
    }
}