({
	init : function(component, event, helper) {
		helper.init(component, event);
	},
    gotoProducts : function(component, event, helper){
        helper.gotoComponent(component, event, "Product");
    },
})