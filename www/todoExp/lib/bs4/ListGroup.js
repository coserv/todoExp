exports.create = function(opts)  {
    let  ul = xs.html('ul', {class: 'list-group'}),
         cb = opts.callback;

    if (opts.itemList)
        opts.itemList.forEach(item => {
            let  itemCB = cb || item.callback,
                 list = xs.html('button', {type: 'button', class: 'border list-group-item list-group-item-action'}, item.title);

            if (item.active)
                list.attr('class', list.attr('class') + ' active');

            if (item.data)
                Object.getOwnPropertyNames(item.data).forEach(key => {
                    list.attr('data-' + key, item.data[key]);
                });

            if (cb)
                list.on('click', itemCB);

            ul.add( list );
        });

    return  ul;
}