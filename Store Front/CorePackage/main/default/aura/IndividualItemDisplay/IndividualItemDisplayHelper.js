({
	init : function(component, event) {
		var action = component.get("c.returnItem");
        
        action.setParams({
            item: component.get("v.RecordId")
        })
        
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                if(data.getReturnValue().DisplayURL__c==null)
                        data.getReturnValue().DisplayURL__c = "https://www.kwizineenstock.ca/assets/img/frontend/none.png";	
                   
                component.set("v.Product",data.getReturnValue());
            }
        })
        
        $A.enqueueAction(action);
	}
})