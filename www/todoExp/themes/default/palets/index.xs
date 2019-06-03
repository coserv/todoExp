/**
 * The default home page
 */
exports.view = function()  {
    let  n = xs.root(css())
               .add('h1', 'Welcome to coServ!')
               .add('div', ['image', {src: '/img/xs.png'}])

    return  n;
}


function  css()  {
    return  {
        '.': {
            'text-align': 'center',
            'margin': '20pt'
        },
        h1: {
            color: '#396',
            'font-family': 'Arial, Helvetica, sans-serif'
        }
    }
}