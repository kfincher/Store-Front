({
	init : function(component, event, helper) {
		helper.init(component, event, helper);
	},
    gotoProducts : function(component, event, helper){
        helper.gotoComponent(component, event, "Product");
    },
    gotoCheckout : function(component, event, helper){
        helper.gotoComponent(component, event, "Checkout");
    },
    gotoPrevious : function(component, event, helper){
        helper.gotoComponent(component, event, "PreviousPurchases")
    },
    addItem : function(component, event, helper){
    	helper.addItem(component, event, helper);
	},
    removeSingleItems :function(component, event, helper){
      	helper.removeSingleItems(component, event, helper);  
    },
    removeItem : function(component, event, helper){
        helper.removeItem(component, event, helper);
    }
})