const ListGroup = require('/lib/bs4/ListGroup');

exports.view = function(model)  {
    let  root = xs.uic('div')
                  .add( ListGroup.create(model) );

    return  root;
}


exports.control = function(u)  {

    u.startup = function()  {
        // yup. jQuery does cache events even we've refreshed the DOM tree
        u.find('.list-group-item').off('click');
        u.find('.list-group-item').on('click', u.click);
    }

    u.click = function()  {
        u.find('.list-group-item').removeClass('active');
        $(this).addClass('active');

        u.notify('selected', this );
    }
}