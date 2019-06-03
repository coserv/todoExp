"use strict"

class ModalManager {
	constructor(modalID , _class) {
		this.modalID = modalID;
		this.modalClass = _class;
		this.headTitle = null;
		this.bodyXS = null;
		this.footXS = null;
	};
	setHeaderTtile(title) {
		this.headTitle = title;
		return this;
	};
	setBodyXS(bodyXS) {
		this.bodyXS = bodyXS;
		return this;
	};
	setFooterXS(footXS) {
		this.footXS = footXS;
		return this;
	};
	build() {
		let div = xs.html('div', {
			"class": "modal fade",
			"id": this.modalID,
			"role": "dialog"
		});
		let div1 = xs.html('div', {
			"class": "modal-content"
		});
		if (this.headTitle != null ) {
			div1.nest('div', {
				"class": "modal-header"
			})
			.add('h4' , {
				class : "modal-title"
			},this.headTitle)
			.add('button' , {
				"type" : "button" ,
				"class" : "close" ,
				"data-dismiss" : "modal" ,
				"aria-label" : "Close"
			}, xs.html('span' , {
				"aria-hidden" : "true"
			},'&times;')); 
		}
		if ( this.bodyXS != null)
			div1.add('div', { "class": "modal-body" } , this.bodyXS);
				
		if ( this.footXS != null)
			div1.add('div', { "class": "modal-footer" } , this.footXS);

		div.nest('div', {
				"class": "modal-dialog " + (this.modalClass == null ? "" : this.modalClass),
				"role": "document"
			})
			.add(div1);

		return div;
	};
};

module.exports = ModalManager;