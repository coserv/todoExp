/**
 * In this example, we simply use an array to store the TODO list.
 */
var  _list = [
        {
            title: 'Car maintenance',
            start: '2018-03-15 08:23:15'
        },
        {
            title: 'Buy toys for kids.',
            start: '2018-03-18 10:13:55',
            end: '2018-03-22 18:10:20',
            checked: true
        }
    ]

/**
 * Return the whole TODO list
 */
exports.list = function()  {
    return  _list
}


/**
 * create a new TODO item
 */
exports.create = function(data)  {
    _list.push( data )
}


/**
 * update an existing TODO item.
 */
exports.update = function(index, data)  {
    _list[index] = data
}