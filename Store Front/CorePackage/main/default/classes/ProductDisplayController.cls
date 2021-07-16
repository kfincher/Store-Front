public class ProductDisplayController {
	@AuraEnabled
    public static List<Item__c> search(String filter){
        List<Item__c> pro = new List<Item__c>();
        switch on filter{
            when 'All' {
                pro = [SELECT Id, Price__c, Name, DisplayURL__c, IsActive__c FROM Item__c WHERE IsActive__c=true];
            }
            when else{
                pro = [SELECT Id, Price__c, Name, DisplayURL__c, IsActive__c, Item_Type__c FROM Item__c WHERE IsActive__c=true AND Item_Type__c includes (:filter)];
            }
        }
        
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
    public static void removeSingleItem(Id item){
		//Item__c itemName = [SELECT Id, Name FROM Item__c WHERE id=:item];
        Cart__c cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId()];
        if(cart!=null){
			Cart_Item__c CI = [SELECT Item__r.Name, Cart__r.id, Item__r.id FROM Cart_Item__c WHERE Cart__r.id=:cart.id AND Item__r.id=:item LIMIT 1];
            System.debug('Debugging: ');
            System.debug(CI);
        	delete CI;
        }
    }
    @AuraEnabled
    public static void removeItemsFromCart(Id item){
		Item__c itemName = [SELECT Id, Name FROM Item__c WHERE id=:item];
        Cart__c cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId()];
        List<Cart_item__c> itemToRemove = [SELECT Item__c, Cart__c FROM Cart_Item__c Where Item__c = :itemName.Id AND Cart__c = :cart.Id];
        delete itemToRemove;
    }
    @AuraEnabled
    public static List<Cart_Item__c> returnCart(){
        Id userID = UserInfo.getUserId();
        return [SELECT Item__r.Name, Item__r.Price__c, Cart__r.UserID__c FROM Cart_Item__c WHERE Cart__r.UserID__c = :userID ORDER BY Item__r.Name];
    }
    @AuraEnabled
    public static Item__c returnItem(Id item){
        return [SELECT Name, Price__c, DisplayURL__C, Item_Type__c, Description__c FROM Item__c WHERE ID = :item];
    }
}