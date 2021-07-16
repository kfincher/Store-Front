({
	init : function(component, event, helper) {
		helper.init(component,event);
	},
    addItem : function(component, event, helper){
    	helper.addItem(component, event);
	},
    individualItem : function(component, event, helper){
    	helper.individualItem(component, event, event.currentTarget.dataset.id);
	},
    gotoCart : function(component, event, helper){
        helper.gotoComponent(component, event, "Cart");
    }
})