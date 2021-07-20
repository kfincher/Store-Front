public class CartTriggerHelper {
    public static void updateSubtotal(List<Cart_Item__c> cart){
        Cart__c crt = [SELECT Id FROM Cart__c WHERE ID = :cart[0].Cart__c];
        crt.Subtotal__c = 0.0;
        for(Cart_Item__c CI : [SELECT Item__r.Price__c, Cart__r.Id From Cart_Item__c WHERE Cart__r.Id = :crt.id]){
            if(CI.Item__r.Price__c!=null)
            	crt.Subtotal__c += CI.Item__r.Price__c;
        }
        crt.Total__c = crt.Subtotal__c*1.0825;
        update crt;
    }
}