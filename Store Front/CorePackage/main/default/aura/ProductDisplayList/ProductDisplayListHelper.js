({
    init : function(component, event) {
        console.log('yea')
        component.set("v.columns",[
            {label:"Name",fieldname:"Name",type:"text"},
            {label:"image",fieldname:"DisplayUrl",type:"text"}
        ])
        this.updateView(component,event);
        
       /* var navService = cmp.find("navService");
        // Sets the route to /lightning/o/Account/home
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'home'
            }
        };
        cmp.set("v.pageReference", pageReference);
        // Set the URL on the link or use the default if there's an error
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                cmp.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                cmp.set("v.url", defaultUrl);
            }));*/
    },
    updateView : function(component, event){
        var action = component.get("c.search");
        action.setParams({filter:component.get("v.productFilter"),search:component.get("v.SearchValue")});
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                //console.log("here")
                //console.log(data.getReturnValue())
                let row = data.getReturnValue();
                for(var i=0;i<row.length;i++){
                    if(row[i].DisplayURL__c==null){
                        row[i].DisplayURL__c = "https://www.kwizineenstock.ca/assets/img/frontend/none.png";	
                    }
                }
                component.set("v.currProductList",data.getReturnValue());
            }else{
                console.log(data.getState);
            }
        })
        
        $A.enqueueAction(action);
    },
    addItem : function(component, event){
        var action = component.get("c.addItemToCart");
        action.setParams({
            item: event.getSource().get("v.value")
        })
        
        action.setCallback(this,function(data){
            if(data.getState()==="SUCCESS"){
                alert('successfully added item!');
            }
        })
        
        $A.enqueueAction(action);
    }, 
})