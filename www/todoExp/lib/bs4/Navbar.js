/**
 * 
 * @param {*} opts
 * 		+ brand
 * 		+ position
 * 		+ theme 
 *      + items: 
 * 			- title
 * 			- link
 * 			- action
 * 			- dropdown
 * 			- disabled
 * 		+ hasSearch
 * 		+ active
 */
exports.create = function(opts)  {
    if (!opts.items || !Array.isArray(opts.items))
		throw  'Navbar items configuration is missing or is not an array.';
		
	// -1 代表沒選取任何一個 link
	let active = opts.active || -1;
	// 建立網頁連結
	let navbarUl = xs.html("ul" , {class:"navbar-nav mr-auto"});
	let len = opts.items.length;
	for (let index = 0; index < len; index++) {
		let item = opts.items[index];
		navbarUl.add(parseLink(active == index, item));
	}
	let content = [
		navbarUl
	];
	if (opts.hasSearch == true) {
		// 是否需要簡易搜尋的表單
		content.push(getForm());
	}
	else if (xs.isJSONH(opts.hasSearch)) {
		// 如果是 xs 的物件，就直接加入
		content.push(opts.hasSearch);
	}

	let theme = "navbar navbar-expand " + (opts.theme ? opts.theme : "navbar-light bg-light") + " " + (opts.position || "");
	return xs.html("nav" , {class: theme})
			 .addIf( opts.brand != null , "a" , {class:"navbar-brand" , href:"/"} , opts.brand )
			 .add(getTogglerBtn())
			 .add("div" , {class:"collapse navbar-collapse" , id: "navbarSupportedContent"} , content);
};


/**
 * 取得再行動裝置下 navbar 才會顯示的 button (觸發 drawer 的 button)
 */
function getTogglerBtn() {
	let prop = "class=\"navbar-toggler\" type=\"button\" data-toggle=\"collapse\" data-target=\"#navbarText\" aria-controls=\"navbarText\" aria-expanded=\"false\" aria-label=\"Toggle navigation\"";
	let btn = xs.html("button" , prop , xs.html("span" , {class:"navbar-toggler-icon"}));
	return btn;
};


/**
 * 解析建立 nav-item 的參數
 * @param {boolean}isActive 指定某個 nav-item 加上 active 的 CSS class
 * @param {object} item   要生出 nav-item 的參數
 */
function parseLink(isActive , item) {
	// 檢查 items.title 是否存在
	if (!item.title) 
		throw 'title 為必要參數。';

	let prop = {class:"nav-item" + (isActive ? " active" : "")};	
	// 判別出連結的型態
	let link = null;
	if (item.disabled) {
		// 被禁用的連結
		link = xs.html("a" , {class:"nav-link disabled" , href: "javascript: void(0);"} , item.title);
	}
	else if (item.dropdown && Array.isArray(item.dropdown) && item.dropdown.length > 0) { 
		// 下拉選單
		prop.class += " dropdown";
		link = getDropdown(item.title , item.dropdown);
	}
	else if (item.link) {
		// 直接連線的連結
		link = xs.html("a" , {class:"nav-link" , href: item.link} , item.title);
	}
	else if (item.action) {
		// 綁住事件的連結
		link = xs.html("a" , {class:"nav-link" , href: "javascript: void(0);", 'data-action': item.action} , item.title)
				 .on('click' , 'this.clickNavItem');
	}
	else {
		// 沒任何參數就只顯示一般文字
		link = item.title;
	}

	return xs.html("li" , prop , link);
};


/**
 * 在 navbar 中 nav-item 有可能會有下拉選單，且結構還跟一般的下拉選單不一樣，所以只好在此建立
 * @param {string} title 下拉選單的標題
 * @param {array}  list  下拉選單的 Item
 */
function getDropdown(title , list) {
	let len = list.length,
		uiList = [];

	for (let index = 0; index < len; index++) {
		let item = list[index];
		let link = null;
		// 檢查 items.title 是否存在
		if (!item.title) 
			throw 'dropdown.title 為必要參數。';
		
		if (item.link) {
			// 直接連線的連結
			link = xs.html("a" , {class:"nav-link" , href: item.link} , item.title);
		}
		else if (item.action) {
			// 綁住事件的連結
			link = xs.html("a" , {class:"nav-link" , href: "javascript: void(0);"} , item.title)
					 .on('click' , 'this.clickDropItem');
		}
		else {
			// 沒任何參數就只顯示一般文字
			link = item.title;
		}
		// 是否需要分隔線
		if (item.hasDivider) {
			uiList.push(xs.html("div" , {class:"dropdown-divider"}));
		}
		uiList.push(link);
	}

	let link = xs.html("a" , {class:"nav-link dropdown-toggle" , href:"#" , id:"navbarDropdown" , role:"button" , "data-toggle":"dropdown", "aria-haspopup":"true", "aria-expanded":"false"} , title);
	let menu = xs.html("div" , {class:"dropdown-menu" , "aria-labelledby":"navbarDropdown"} , uiList);

	return [link , menu];
};


function getForm() {
	return xs.html("form" , {class:"form-inline my-2 my-lg-0"} , [
			xs.html("input" , {class:"form-control mr-sm-2", type:"search" , placeholder:"Search", "aria-label":"Search"}),
			xs.html("button", {class:"btn btn-outline-success my-2 my-sm-0" , type:"submit"} , "Search")
		]);
};