({
	init : function(component, event, helper) {
		console.log('made it')
	},
    gotoProducts : function(component, event, helper){
        helper.gotoComponent(component, event, "Product");
    }
})