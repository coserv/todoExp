const  todoModel = require('/lib/TodoModel'),
       bscomp = importUIC('/bs4/components')

exports.model = function(inData, ctx, cb)  {
    // let's hand-made some data here
    let  list = todoModel.list()

    cb({
        code: 0,
        message: 'Ok',
        value: {list: list}
    });
}


exports.view = function(model) {
    let  ul = xs.html('div', {class: 'list-group', role: 'tablist'});
    
    model.list.forEach( (item, idx) => {
        ul.add( showItem( idx, item ) );
    })

    // prepare input data for the modal dialog
    let  modalData = {
            title: 'My TODO Item',
            body: xs.e('h5', 'Will display a TODO item here...'),
            primaryBtn: 'Confirm',
            closeBtn: true
         }

    let  root = xs.root(css())
                .add('h5', 'My TODO List')
                .add( ul )
                .add( bscomp.create('Modal', 'todoModal', modalData)
                            .on('clickPrimary', 'this.confirmDialog') )

    return  root;
}


exports.control = function(p, model)  {

    // 'itemView' will store the palet instance of '/todo/view'
    var  itemView

    p.click = function(event)  {
        let  li = $(event.currentTarget),
             idx = li.data('index'),
             data = {
                 index: idx,
                 data: model.list[idx]
             }
        li.tab('show')

        _todoModal.setBodyPalet('itemView', '/todo/view', data, (subp) => {
            itemView = subp;
            _todoModal.setOptions('show')
        })
    }

    p.confirmDialog = function()  {
        const  index = itemView.getIndex(),
               todoItem = itemView.getItem()

        // call the "faceless" palet /todo/updateItem to update a TODO list
        $.post('/todo/updateItem/' + index, todoItem, function(result)  {
            if (result.code)
                // any non-zero return code indicates an error
                alert('Failed to update the TODO item.')
            else
                // ok. everything is fine. let's refresh the list
                window.location = '/todo/list'
        })
    }
}


function  showItem(idx, item)  {
    let  prop = {
            class: 'list-group-item list-group-item-action',
            role: 'tab',
            'data-index': idx,
            'data-toggle': 'list'
         },
         icon = item.checked  ?  'far fa-check-circle' : 'far fa-circle';
    
    let  tag = xs.e('div', prop)
                 .add('i', {class: icon})
                 .addText('&nbsp')
                 .on('click', 'this.click');

    if (item.checked)
        tag.add('del', item.title );
    else
        tag.addText( item.title );
    return  tag;
}


function  css()  {
    return  {
        '.': {
            'max-width': '650px',
            margin: '0px auto',
            'font-size': '1.3rem'
        }
    }
}