const  bsform = importUIC('bs4/components/form');

/**
 * The data model is coming from the input to this palet.
 * We'll use the Horizontal form UIC to display the TODO item.
 */
exports.view = function(model) {
    let  item = model.data,
         formItems = [
            {
                label: 'Task',
                type: 'text',
                name: 'title',
                value: item.title
            },
            {
                label: 'Start Time',
                type: 'text',
                name: 'start',
                value: item.start || ''
            },
            {
                label: 'Done Time',
                type: 'text',
                name: 'end',
                value: item.end || ''
            },
            {
                label: 'Done',
                notes: 'is done',
                name: 'checked',
                type: 'checkbox',
                checked: item.checked || false
            }
         ];

    return  xs.uic()
              // use the bootstrap horizontal form to show the todo item
              .add('div', null, bsform.create('Horizontal', 'mbody', {items: formItems} ));
}


exports.control = function(p, model)  {

    /**
     * Return the index number of the current TODO item.
     */
    p.getIndex = function()  {
        return  model.index
    }

    /**
     * Return the TODO item "after modification".
     */
    p.getItem = function()  {
        let  fdata = p.find('form').serializeArray(),
             itemData = {}

        for (let i = 0, len = fdata.length; i < len; i++)  {
            let  item = fdata[i]
            itemData[item.name] = item.value
        }

        return  itemData
    }
}