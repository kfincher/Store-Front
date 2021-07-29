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
        if(helper.timer!=null){
        	clearTimeout(helper.timer);
        }
        
        helper.timer = setTimeout(
            $A.getCallback(function(){
                if(component.get("v.InputPartOne")==i){
                    helper.updateView(component, event);
                    component.set("v.InputPartOne",0);
                }
            }
                          ), 750);
        
        // Meant to prevent too many server calls while also refreshing results once the input is cleared
        if((component.get("v.SearchValue")==""||component.get("v.SearchValue")==null)&&!helper.alreadyCleared){
            helper.alreadyCleared = true;
            helper.updateView(component, event);
        }else if(helper.alreadyCleared&&(component.get("v.SearchValue")!=""&&component.get("v.SearchValue")!=null)){
            helper.alreadyCleared = false;   
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