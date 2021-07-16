<!--

 Name: harnessApp	
 Author: Kameron Fincher
 Description: Is a harness app

-->
<aura:application extends="force:slds">
    <aura:attribute name="ComponentDisplay" type="String" default="Product"/>
    <aura:attribute name="productFilter" type="String" default="All"/>
    <aura:attribute name="RecordId" type="String"/>
    
    <aura:handler name="cmpReturnEvent" event="c:ChangeDisplayComponent" action="{!c.ReturnEvent}" />
    <aura:handler name="IdReturnEvent" event="c:PassRecordId" action="{!c.IdReturnEvent}" />
    <div id="mainBodyStyle">
        <aura:if isTrue="{!v.ComponentDisplay=='Product'}"><c:ProductDisplayList productFilter="{!v.productFilter}"/></aura:if>
        <aura:if isTrue="{!v.ComponentDisplay=='Cart'}"><c:DisplayCart/></aura:if>
        <aura:if isTrue="{!v.ComponentDisplay=='Checkout'}"><c:Checkout/></aura:if>
        <aura:if isTrue="{!v.ComponentDisplay=='IndividualItem'}"><c:IndividualItemDisplay RecordId="{!v.RecordId}"/></aura:if>
        
    </div>
</aura:application>