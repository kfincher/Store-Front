({
	init : function(component, event) {
		var action = component.get("c.returnItem");
        
        action.setParams({
            item: component.get("v.RecordId")
        })
        
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                component.set("v.Product",data.getReturnValue());
            }
        })
        
        $A.enqueueAction(action);
	}
})