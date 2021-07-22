trigger Cart_Item on Cart_Item__c (after insert, after update, after delete) {
    if(Trigger.isAfter){
        CartTriggerHelper.updateSubtotal(trigger.new);
    }
}