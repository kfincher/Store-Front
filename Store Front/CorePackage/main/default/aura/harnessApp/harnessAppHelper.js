({
	ReturnEvent : function(component, event) {
        console.log(event.getParam("Component"));
		component.set("v.ComponentDisplay",event.getParam("Component"));
	},
    IdReturnEvent : function(component, event) {
        console.log(event.getParam("RecordId"));
		component.set("v.RecordId",event.getParam("RecordId"));
	},
})