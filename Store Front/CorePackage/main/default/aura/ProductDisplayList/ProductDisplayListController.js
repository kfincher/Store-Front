({
	init : function(component, event, helper) {
		helper.init(component,event);
	},
    addItem : function(component, event, helper){
    	helper.addItem(component, event);
	},
    keyCheck : function(component, event, helper){
        let i = component.get("v.InputPartOne") + 1;
        component.set("v.InputPartOne",i)
        
        console.log(i)
        setTimeout(function(){
            if(component.get("v.InputPartOne")==i){
        		helper.init(component, event);
                component.set("v.InputPartOne",0);
            	console.log(i)
            }
        }, 1000);
        if (event.which == 13){
        	helper.init(component, event);
            component.set("v.InputPartOne",0);
    	}    
    },
    individualItem : function(component, event, helper){
    	helper.individualItem(component, event, event.currentTarget.dataset.id);
	},
    gotoCart : function(component, event, helper){
        helper.gotoComponent(component, event, "Cart");
    }
})