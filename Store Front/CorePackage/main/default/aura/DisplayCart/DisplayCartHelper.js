({
	init : function(component, event) {
		var action = component.get("c.returnCart");
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                var rows = new Map();
                for(let i = 0;i<data.getReturnValue().length;i++){
                    if(rows.has(data.getReturnValue()[i].Item__r.Name)){
                        let temp = rows.get(data.getReturnValue()[i].Item__r.Name);
                        temp.Quantity++;
                        rows.set(data.getReturnValue()[i].Item__r.Name,temp);
                    }else{
                        console.log(data.getReturnValue()[i]);
                        let temp = data.getReturnValue()[i];
                    	temp.Quantity = 1;
                        rows.set(temp.Item__r.Name,temp);
                    }
                }
                let returnRows = [];
                for (const [key,value] of rows){
                    returnRows.push(value);
                }
                console.log(returnRows);
                component.set("v.CartList",returnRows);
            }else{
                console.log("failed");
            }
            
        })
        
        $A.enqueueAction(action);
	},
    gotoProducts : function(component, event){
        var cmpEvent  = component.getEvent("cmpReturnEvent");
        cmpEvent.setParam("Component","Product");
        cmpEvent.fire();
    },
    removeItem : function(component, event){
        console.log(event.getSource().get("v.value"));
    }
})