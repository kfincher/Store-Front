({
	gotoComponent : function(component, event, cmpName){
        var cmpEvent  = component.getEvent("cmpReturnEvent");
        cmpEvent.setParam("Component",cmpName);
        cmpEvent.fire();
    },
    individualItem : function(component, event, Id){
        console.log('Here '+Id);
        var cmpEvent  = component.getEvent("IdReturnEvent");
        cmpEvent.setParam("RecordId",Id);
        cmpEvent.fire();
        this.gotoComponent(component, event, "IndividualItem")
    },
})