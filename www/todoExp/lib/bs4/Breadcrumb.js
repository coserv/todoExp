/**
 * 
 * @param {*} opts 
 *      + items: 
 * 			- title
 * 			- link
 * 			- action
 */
exports.create = function(opts)  {
    if (!opts.items || !Array.isArray(opts.items))
		throw  'Table items configuration is missing or is not an array.';
	
	let breadcrumb = xs.html('ol' , {class:"breadcrumb"});
	let len = opts.items.length;
	for (let index = 0; index < len; index++) {
		let item = opts.items[index];
		// 檢查 items.title 是否存在
		if (!item.title) 
			throw 'title 為必要參數。';

		if (index == len - 1) {
			// 如為最後一筆，則顯示不同 style
			breadcrumb.add("li" , {class:"breadcrumb-item active"} , item.title);
		}
		else {
			let link = xs.html("a" , null , item.title)
			if (item.link) 
				link.attr("href" , item.link);
			else if (item.action) {
				link.attr("href" , "javascript: void(0);");
				link.on('click' , 'this.clickItem');
			}
			else 
				throw 'link 或 action 參數需擇一給予。';

			breadcrumb.add("li" , {class:"breadcrumb-item"} , link);
		}
	}
	return breadcrumb;
};