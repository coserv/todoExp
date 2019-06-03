exports.create = function(header, body, footer)  {
    let  card = xs.html('div', {class: 'card'});
    if (header)
        card.add(header);

    if (body)
        card.add(body);

    if (footer)
        card.add(footer);

    return  card;
}


exports.createHeader = function()  {
    return  xs.html('div', {class: 'card-header'});
}


exports.createBody = function()  {
    return  xs.html('div', {class: 'card-body'});
}


exports.createFooter = function()  {
    return  xs.html('div', {class: 'card-footer'});
}