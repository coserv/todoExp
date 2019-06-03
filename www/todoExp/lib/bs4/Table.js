/**
 * 
 * @param {*} opts 
 *      + header:
 *      + rows: data rows
 *      + theme: additonal table rows
 *      + entries:
 *      + pageSize:
 *      + pageOpt:
 */
exports.create = function(opts)  {
    if (!opts.header || !Array.isArray(opts.header))
        throw  'Table header configuration is missing or is not an array.';

    if (!opts.rows || !Array.isArray(opts.rows))
        throw  'Table data rows are missing or is not assembled in an array.';

    let  tableClass = 'table';
    if (opts.theme)
        tableClass += ' ' + opts.theme;

    let  thead = xs.html('thead'),
         tbody = xs.html('tbody'),
         root = xs.html('table', {class: tableClass}, [thead, tbody]);

    let  keys = [],
         tdAlign = {},      // alignment specification of TDs
         tr = xs.html('tr');
    thead.add( tr );

    opts.header.forEach( h => {
        // if not a specific key is given, fall back to column name as the key
        let  key = h.key || h.name;
        keys.push( key );

        let  prop = {scope: 'col'};
        if (h.width)
            prop.width = h.width;
        if (h.align)  {
            let  a = h.align.split('/');
            if (a[0])
                prop.style = 'text-align: ' + a[0] + ';';
            if (a.length > 1)
                tdAlign[key] = a[1];
        }
        if (h.class)
			prop.class = h.class;
			
        tr.add('th', prop, h.name );
    });

	// build table rows...
	for (let index = 0; index < opts.rows.length; index++) {
		let  r = opts.rows[index];
		let  trProp = {"data-index": index};
        if (r._theme)
            trProp.class = r._theme;

        let  tr = xs.html('tr', trProp);
        tbody.add( tr );

        keys.forEach(k => {
            let  value = r[k],
                 align = tdAlign[k],
                 prop = null;

            if (!xs.isJSONH(value) && (typeof value !== 'string'))
                value = value + '';

            if (align)
                prop = {style: 'text-align:' + align + ';'};

            tr.add('td', prop, value);
        });
	}

    if (opts.entries && opts.pageSize)
        return  {
            table: root,
            pagination: exports.pagination(opts.entries, opts.pageSize, opts.pageOpt)
        };
    else
        return  root;
}


/**
 * 
 * @param {*} entries total number of entires (rows)
 * @param {*} pageSize number of rows of each page
 * @param {*} options configuration option
 *          + size: 'sm', 'lg' for small or large pagination
 *          + align: center, start, end, etc to align the pagination
 *          + idx: the current active page. default to 1.
 *          + pageHandler: the callback function when click on a page number.
 */
exports.pagination = function(entries, pageSize, options)  {
    options = options || {};

    let  pageIdx = options.idx || 1,
         ul,
         root = xs.html('nav')
                  .add( ul = xs.html('ul', {class: 'pagination'} ));

    if (options.size)
        ul.addClass('pagination-' + options.size);
    if (options.align)
        ul.addClass('justify-content-' + options.align);

    let  pa, na,
         prev = xs.html('li', {class: 'page-item'})
                  .add( pa = xs.html('a', {class: 'page-link', href: '#', 'data-idx': (pageIdx-1), 'aria-label': 'Previous'})
                               .addIf(options.prevIcon, options.prevIcon)
                               .addIf(!options.prevIcon, 'span', {'aria-hidden': true}, '&laquo;')
                               .add('span', {class: 'sr-only'}, 'Previous')
                  ),
         next = xs.html('li', {class: 'page-item'})
                  .add( na = xs.html('a', {class: 'page-link', href: '#', 'data-idx': (pageIdx+1), 'aria-label': 'Next'})
                               .addIf(options.nextIcon, options.nextIcon)
                               .addIf(!options.nextIcon, 'span', {'aria-hidden': true}, '&raquo;')
                               .add('span', {class: 'sr-only'}, 'Next')
                  ),
         pageCount = Math.ceil(entries / pageSize);

    if (pageIdx === 1)
        prev.addClass('disabled');
    if (pageIdx === pageCount)
        next.addClass('disabled');

    if (options.pageHandler)  {
        pa.on('click', options.pageHandler);
        na.on('click', options.pageHandler);
    }

    if (options.startIcon)  {
        let  a,
             fst = xs.html('li', {class: 'page-item'})
                     .add( a = xs.html('a', {class: 'page-link', href: '#', 'data-idx': 1, 'aria-label': 'First'})
                                 .add(options.startIcon)
                                 .add('span', {class: 'sr-only'}, 'First Page')
                     );
        
        if (pageIdx === 1)
            fst.addClass('disabled');
        ul.add( fst );
        if (options.pageHandler)
            a.on('click', options.pageHandler);
    }

    ul.add( prev );
    for (let i = 1; i <= pageCount; i++)  {
        if (pageIdx === i)
            ul.nest('li', {class: 'page-item active'})
              .nest('span', {class: 'page-link'})
              .addText(i + '')
              .add('span', {class: 'sr-only'}, '(current)');
        else  {
            let  a;
            ul.nest('li', {class: 'page-item'})
              .add( a = xs.html('a', {class: 'page-link', href: '#', 'data-idx': i}, i + '') );

            if (options.pageHandler)
                a.on('click', options.pageHandler);
        }
    }
    ul.add( next );

    if (options.endIcon)  {
        let  a,
             lst = xs.html('li', {class: 'page-item'})
                     .add( a = xs.html('a', {class: 'page-link', href: '#', 'data-idx': pageCount, 'aria-label': 'Last'})
                                 .add(options.endIcon)
                                 .add('span', {class: 'sr-only'}, 'Last Page')
                     );
        if (pageIdx === pageCount)
            lst.addClass('disabled');
        ul.add( lst );
        if (options.pageHandler)
            a.on('click', options.pageHandler);
    }

    return  root;
}