/**
 * This is a faceless palet so there will be no view() function.
 */
const  todoModel = require('/lib/TodoModel')

exports.model = function(inData, ctx, cb)  {
    let  idx = ctx.endpID
    todoModel.update(idx, inData)

    cb({
        code: 0,
        message: 'Ok'
    })
}