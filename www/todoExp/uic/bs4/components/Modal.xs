/*!
 * Last modified: 04/17/2019
 */

exports.checkIn = {
    title: {
        '@type': 'string',
        '@error': 'The [title] parameter should be a string.'
    },
    body: {
        '@default': xs.html('div', 'Hello...')
    },
    primaryBtn: {
        '@type': 'string'
    },
    dismissBtn: {
        '@type': 'string'
    },
    closeBtn: {
        '@type': 'bool'
    },
    backdrop: {
        '@explain': 'The backgrop option set to a bootstrap modal'
    }
};


exports.view = function(params)  {
    let  modalProp = {
            id: 'bs4_modal',
            class: 'modal fade', 
            tabindex: '-1', 
            role: 'dialog'
         };

    if (params.hasOwnProperty('backdrop'))
        modalProp['data-backdrop'] = params.backdrop;

    let  modal = xs.uic('div', modalProp, null);

    let  pane = modal.nest('div', {class: 'modal-dialog', role: 'document'})
                     .nest('div', {class: 'modal-content'});
         
    if (params.title)  {
        let  header = pane.nest('div', {class: 'modal-header'});

        header.add('h5', {class: 'modal-title'}, params.title);
        if (params.closeBtn)
            header.nest('button', {type: 'button', class: 'close', 'data-dismiss': 'modal', 'arial-label': 'Close'})
                .nest('span', {'aria-hidden': 'true'}).addText('&times;');
    }
    

    let  body = pane.nest('div', {class: 'modal-body'});
    body.add( params.body );
    
    if (params.dismissBtn || params.primaryBtn)  {
        let  footer = pane.nest('div', {class: 'modal-footer'});
        
        // dealing with the dismiss button
        if (params.dismissBtn)
            footer.add( xs.e('button', {type: 'button', class: 'btn btn-secondary', 'data-dismiss': 'modal'}, params.dismissBtn)
                          .on('click', 'this.clickCancel')
                      );
        
        // dealing with the primary button
        if (params.primaryBtn)  {
            let  p = {
                    type: 'button',
                    class: 'btn btn-primary'
                 },
                 btn = xs.html('button', p, params.primaryBtn)
                         .on('click', 'this.clickPrimary');

            footer.add(btn);
        }
    }

    return  modal;
}


exports.control = function(c)  {
    c.on = function(evName, func)  {
        if (evName == 'clickPrimary' || evName == 'clickCancel')
            // customized events go here...
            Object.getPrototypeOf(c).on.call(c, evName, func );
        else
            c.find('#bs4_modal').on( evName, func );
    }

    c.setOptions = function(options)  {
        c.find('#bs4_modal').modal( options );
    }

    c.setBody = function(body)  {
        c.find('.modal-body').html( body );
    }

    // c.setBodyUIC = function(url, args, cb)  {
    //     c.embed('.modal-body', url, args, cb);
    // }

    c.setBodyPalet = function(id, url, args, cb)  {
        c.embed(c.find('.modal-body'), id, url, args, cb);
    }

    c.clickPrimary = function()  {
        c.notify('clickPrimary');
    }

    c.clickCancel = function()  {
        c.notify('clickCancel');
    }
}