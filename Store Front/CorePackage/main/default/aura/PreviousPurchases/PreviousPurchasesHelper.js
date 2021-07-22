({
	init : function(component, event) {
		var action = component.get("c.PreviousPurchases");
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                console.log('yea')
                var rows = data.getReturnValue();
                for(let i = 0; i<rows.length;i++){
                    console.log(rows[i])
                    rows[i].Purchase.Date_Completed__c = this.FormatDate(rows[i].Purchase.Date_Completed__c);
                    rows[i].Cart.Total__c = rows[i].Cart.Total__c.toFixed(2);
                    if(rows[i].Purchase.Carts__r!=undefined&&rows[i].Purchase.Carts__r!=null){
                        
                        rows[i].Purchase.Carts__r = rows[i].Purchase.Carts__r[0]
                        let items = []
                        for(let j = 0;j<rows[i].Items.length;j++){
                            items.push(rows[i].Items[j]);
                        }
                        rows[i].Items = items;
                        console.log(rows[i].Items)
                    }
                }
                component.set("v.Purchases",data.getReturnValue());
            }
        })
        
        $A.enqueueAction(action);
	},
    FormatDate : function(date){
        date = date.split('-');
        let year = date[0];
        let month = date[1];
        let day = date[2].split('T')[0];
		
        var d = new Date();
        let hh = date[2].split('T')[1].split(':')[0] - (d.getTimezoneOffset()/60);
        
        let pm = hh > 11 ? "pm" : "am";
        hh += hh>12 ? 1 : 0 ;
        hh %= 13;
		let mm = date[2].split('T')[1].split(':')[1];  
        
        date = month+"-"+day+"-"+year+" "+hh+":"+mm+pm;
        return date;
    }
})