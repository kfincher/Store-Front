({
	init : function(component, event, helper) {
		helper.init(component,event);
	},
    addItem : function(component, event, helper){
    	helper.addItem(component, event);
	},
    keyCheck : function(component, event, helper){
        if (event.which == 13){
        	helper.init(component, event);
    	}    
    },
    individualItem : function(component, event, helper){
    	helper.individualItem(component, event, event.currentTarget.dataset.id);
	},
    gotoCart : function(component, event, helper){
        helper.gotoComponent(component, event, "Cart");
    }
})