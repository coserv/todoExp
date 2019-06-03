/*!
 * Last modified: 03/28/2019
 */
const  counter = require('./Counter');

exports.checkIn = {
    items: {
        '@type': [{
            src: {
                '@type': 'string'
            },
            body: {
                '@type': {}
            },
            alt: {
                '@type': 'string'
            },
            active: {
                '@type': 'bool'
            },
            caption: {
                '@type': 'string'
            }
        }],
        '@required': true,
        '@explain': "An array of slides. Each slide could have the following properties: 'src', 'alt', 'active' and 'caption'."
    },
    width: {
        '@default': '100%',
        '@explain': 'The width of each slide.'
    },
    control: {
        '@type': 'bool',
        '@default': false
    },
    indicator: {
        '@type': 'bool',
        '@default': false
    },
    effect: {
        '@type': 'string'
    },
    interval: {
        '@explain': 'The interval option to a carousel'
    }
};

exports.view = function(model)  {
    let  _carousel_id = '_carousel' + counter.getCarouselIndex(),
         rootp = {
            id: _carousel_id,
            class: 'carousel ', 
            'data-ride': 'carousel'
         };

    if (model.effect == 'fade')
        rootp.class += 'carousel-fade';
    else
        rootp.class += 'slide'; 

    if (model.hasOwnProperty('interval'))
        rootp['data-interval'] = model.interval;

    let  root = xs.uic('div', rootp);

    if (model.indicator)  {
        // adding indicator...
        let  ind = xs.html('ol', {class: 'carousel-indicators'});
        model.items.forEach( (item, idx) => {
            let  p = {
                    'data-target': '#' + _carousel_id,
                    'data-slide': idx
                 };
            if (idx === 0)
                 p.class = 'active';

            ind.add('li', p);
        });

        root.add( ind );
    }

    // inner
    let  inner = xs.html('div', {class: 'carousel-inner'}),
         activeIdx = 0;

    for (let i = 0, len = model.items.length; i < len; i++)
        if (model.items[i].active)  {
            activeIdx = i;
            break;
        }

    model.items.forEach( (item, idx) => {
        let  div = xs.html('div', {class: 'carousel-item'});
        if (item.src)  {
            let  imgProp = {
                    class: 'd-block',
                    src: item.src,
                    width: model.width
                 };

            if (item.alt)
                impProp.alt = item.alt;

            div.add('img', imgProp);
        }
        else  if (item.body)
            div.add( item.body );

        // set the start up slide
        if (idx === activeIdx)
            div.attr('class', div.attr('class') + ' active');

        if (item.caption)  {
            let  cap = xs.html('div', {class: 'carousel-caption d-done d-md-block'}, item.caption);
            div.add( cap );
        }

        inner.add( div );
    });
    root.add( inner );

    if (model.control)  {
        // adding slide controller
        let  prev = xs.html('a', {class: 'carousel-control-prev', href: '#' + _carousel_id, role: 'button', 'data-slide': 'prev'})
                      .add('span', {class: 'carousel-control-prev-icon', 'aria-hidden': true})
                      .add('span', {class: 'sr-only'}, 'Previous'),
             next = xs.html('a', {class: 'carousel-control-next', href: '#' + _carousel_id, role: 'button', 'data-slide': 'next'})
                      .add('span', {class: 'carousel-control-next-icon', 'aria-hidden': true})
                      .add('span', {class: 'sr-only'}, 'Next');

        root.add( prev ).add( next );
    }

    return  root;
}


exports.control = function(c)  {

    c.on = function(evName, func)  {
        // no custom events. simply relay to the Carousel component
        c.find('.carousel').on( evName, func );
    }

    c.setOption = function(options)  {
        c.find('.carousel').carousel( options );
    }

    c.getSlide = function(number)  {
        return  c.find('.carousel-item:eq(' + number + ')');
    }

    c.getActiveSlide = function()  {
        return  c.find('active');
    }
}