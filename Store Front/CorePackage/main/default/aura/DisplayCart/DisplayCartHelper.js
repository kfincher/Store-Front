({
    init : function(component, event, helper) {
        var action = component.get("c.returnCart");
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                var rows = new Map();
                var subTotal = 0; 
                for(let i = 0;i<data.getReturnValue().length;i++){
                    //console.log(data.getReturnValue()[i].Item__r);
                    subTotal += data.getReturnValue()[i].Item__r.Price__c;
                    if(rows.has(data.getReturnValue()[i].Item__r.Name)){
                        let temp = rows.get(data.getReturnValue()[i].Item__r.Name);
                        temp.Quantity++;
                        temp.Item__r.Price__c = (data.getReturnValue()[i].Item__r.Price__c*temp.Quantity).toFixed(2);
                        rows.set(data.getReturnValue()[i].Item__r.Name,temp);
                    }else{
                        //console.log(data.getReturnValue()[i]);
                        let temp = data.getReturnValue()[i];
                        temp.Quantity = 1;
                        rows.set(temp.Item__r.Name,temp);
                    }
                }
                let returnRows = [];
                for (const [key,value] of rows){
                    returnRows.push(value);
                }
               	helper.returnTotal(component, event);
                component.set("v.CartList",returnRows);
            }else{
                console.log("failed");
            }
            
        })
        
        $A.enqueueAction(action);
    },
    addItem : function(component, event, helper){
        var action = component.get("c.addItemToCart");
        action.setParams({
            item: event.getSource().get("v.value")
        })
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                helper.init(component, event, helper);
            }
        })
        
        $A.enqueueAction(action);
    }, 
    removeSingleItems : function(component, event, helper){
        var action = component.get("c.removeSingleItem");
        action.setParams({
            item: event.getSource().get("v.value")
        })
        console.log('made it here')
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                console.log('deleted')
                helper.init(component, event, helper);
            }else{
                console.log('oh no')
            }
        })
        
        $A.enqueueAction(action);
    }, 
    removeItem : function(component, event, helper){
        //console.log(event.getSource().get("v.value"));
        var action = component.get("c.removeItemsFromCart");
        action.setParams({
            item: event.getSource().get("v.value")
        })
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                helper.init(component, event, helper);
                //alert('successfully removed item!');
            }
        })
        
        $A.enqueueAction(action);
    },
    returnTotal : function(component, event){
        //console.log(subTotal);
        var action = component.get("c.returnCartTop");
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                console.log("Here")
                console.log(data.getReturnValue().Subtotal__c)
                if(data.getReturnValue().Subtotal__c!=null){
                    data.getReturnValue().Subtotal__c = data.getReturnValue().Subtotal__c.toFixed(2);
                    data.getReturnValue().Total__c = data.getReturnValue().Total__c.toFixed(2);
                    component.set("v.Cart",data.getReturnValue());
                }
            }
        })
        
		$A.enqueueAction(action);
    }
})