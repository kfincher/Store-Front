public class ProductDisplayController {
	@AuraEnabled
    public static List<Item__c> search(String filter){
        List<Item__c> pro =[SELECT Id, Name, DisplayURL__c, IsActive__c FROM Item__c WHERE IsActive__c=true];
        System.debug(pro.size());
        return pro;
    }
    @AuraEnabled
    public static void addItemToCart(Id item){
		Item__c itemName = [SELECT Id, Name FROM Item__c WHERE id=:item];
        Cart__c cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId()];
        if(cart!=null){
			Cart_Item__c CI = new Cart_Item__c(Item__c = itemName.id, Cart__c=cart.id);
        	insert CI;
        }
    }
    @AuraEnabled
    public static List<Cart_Item__c> returnCart(){
        Id userID = UserInfo.getUserId();
        return [SELECT Item__r.Name, Cart__r.UserID__c FROM Cart_Item__c WHERE Cart__r.UserID__c = :userID];
    }
}