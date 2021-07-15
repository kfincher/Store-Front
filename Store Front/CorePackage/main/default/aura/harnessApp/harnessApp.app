<!--

	Name: harnessApp	
	Author: Kameron Fincher
	Description: Is a harness app

-->
<aura:application extends="force:slds">
    <aura:attribute name="ComponentDisplay" type="String" default="Product"/>
    <aura:handler name="cmpReturnEvent" event="c:ChangeDisplayComponent" action="{!c.ReturnEvent}" />
    
    <aura:if isTrue="{!v.ComponentDisplay=='Product'}"><c:ProductDisplayList/></aura:if>
    <aura:if isTrue="{!v.ComponentDisplay=='Cart'}"><c:DisplayCart/></aura:if>
    
</aura:application>