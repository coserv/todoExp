exports.include = [
    {
        href: 'https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css',
        integrity: 'sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB'
    },
    {
        src: 'https://code.jquery.com/jquery-3.3.1.js',
        integrity: 'sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60='
    },
    {
        src: 'https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.bundle.min.js',
        integrity: 'sha384-u/bQvRA/1bobcXlcEYpsEdFVK/vJs3+T+nXLsBYJthmdBuavHvAW6UsmqO2Gd/F9'
    },
    {
        href: 'https://use.fontawesome.com/releases/v5.2.0/css/all.css',
		integrity: 'sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ',
		crossorigin: 'anonymous'
    }
]

exports.view = function(model, ctx)  {
    /** This section will be the default for all layouts. **/
    let  head = xs.e('head')
                  .add('title', ctx.title)
                  .add('meta', 'http-equiv="X-UA-Compatible" content="IE=edge"')
                  .add('meta', 'http-equiv="Content-Type" content="text/html; charset=UTF-8"');
    if (ctx.description)
        head.add('meta', {name: 'description', content: ctx.description});

    // add include files
    if (model.include)
        model.include.forEach( inc => head.add( inc ) );
    /****** End of the default section ******/

    let  root = xs.root('html')
                  .add( head )
                  .add('body', [
                        ['div', {id: 'pgBody'}, model.body]
                  ]);

    return  root;
}