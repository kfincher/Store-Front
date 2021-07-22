({
	ReturnEvent : function(component, event) {
		component.set("v.ComponentDisplay",event.getParam("Component"));
	},
    IdReturnEvent : function(component, event) {
		component.set("v.RecordId",event.getParam("RecordId"));
	},
})