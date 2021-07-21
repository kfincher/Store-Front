public class ContactCart {
    public static void createCart(Id userName){
        List<Cart__c> cartCheck = [SELECT UserID__c From Cart__c WHERE UserID__c = :userName AND IsActive__c = true];
        if(cartCheck.size()==0){
            Cart__c cart = new Cart__c(UserID__c = userName, User_Name__c = userName, IsActive__c = true);
            insert cart;
        }
    }
}