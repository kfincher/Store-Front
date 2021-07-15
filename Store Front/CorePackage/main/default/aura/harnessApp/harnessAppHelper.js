({
	ReturnEvent : function(component, event) {
        console.log(event.getParam("Component"));
		component.set("v.ComponentDisplay",event.getParam("Component"));
	}
})