({
	init : function(component, event, helper) {
		helper.init(component,event);
	},
    addItem : function(component, event, helper){
    	helper.addItem(component, event);
	},
    handleChange : function(component, event, helper){
		component.set("v.SortValue",event.getParam("value"));
        helper.updateView(component, event);
    },
    changeSort : function(component, event, helper){
      	let arrow = component.get("v.SortOrder");  
        arrow = (arrow=='↑') ? '↓' : '↑';
        component.set("v.SortOrder",arrow);
        helper.updateView(component, event);
    },
    keyCheck : function(component, event, helper){
        let i = component.get("v.InputPartOne") + 1;
        component.set("v.InputPartOne",i)
        if(timerRun!=null)
        	clearTimeout(timerRun);
        console.log(event.which);
        var timerRun = setTimeout(function(){
            if(component.get("v.InputPartOne")==i){
                console.log(i+' '+component.get("v.SearchValue"))
        		helper.updateView(component, event);
                component.set("v.InputPartOne",0);
            	
            }
        }, 1000);
        
        if(component.get("v.SearchValue")==""||component.get("v.SearchValue")==null){
            helper.updateView(component, event);
        }
        if (event.which == 13){
        	helper.updateView(component, event);
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