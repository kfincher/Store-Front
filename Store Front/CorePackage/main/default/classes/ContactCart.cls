public class ContactCart {
    public static void createCart(User userName){
        List<Cart__c> cartCheck = [SELECT UserID__c From Cart__c WHERE UserID__c = :userName.id];
        if(cartCheck.size()==0){
            Cart__c cart = new Cart__c(UserID__c = userName.id, User_Name__c = userName.Name);
            insert cart;
        }
    }
}