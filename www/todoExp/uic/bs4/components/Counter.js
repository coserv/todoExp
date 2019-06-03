var  _tabIdx = 1,
     _ddIdx = 1,
     _carouselIdx = 1;

exports.getTabIndex = function()  {
    return  _tabIdx++;
}

exports.getCarouselIndex = function()  {
    return  _carouselIdx++;
}

exports.getDropdownIndex = function()  {
    return  _ddIdx++;
}