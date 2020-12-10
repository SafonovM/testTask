public with sharing class instanceTriggerHelper {

    public static void QuontityChange(List<Instance__c> records) {
        Map<ID,Schema.RecordTypeInfo> rt_map = Instance__c.sObjectType.getDescribe().getRecordTypeInfosById();
        Set<Id> setId = new Set<Id>();
        for (Instance__c instance : records) {
            if (rt_map.get(instance.recordTypeID).getName().containsIgnoreCase('Standard Instance')) {
                setId.add(instance.Account__r.Id);
            }         
        }  

        Map<String,Integer> accLicensesNum = new Map<String,Integer>();
        List<Instance__c> instList = [SELECT Licenses__c,Account__c FROM Instance__c WHERE Account__c IN :setId];
        for (Instance__c inst : instList) {
            if(accLicensesNum.containsKey(inst.Account__c)){
                accLicensesNum.put(inst.Account__c, (Integer)(accLicensesNum.get(inst.Account__c) + inst.Licenses__c));
                
            } else {
                accLicensesNum.put(inst.Account__c, (Integer)inst.Licenses__c);
            }
        }

        List<Account> accList = [SELECT Id, Total_Licenses__c FROM Account WHERE Id IN :setId];
        for (Account acc : accList) {
            acc.Total_Licenses__c = accLicensesNum.containsKey(acc.Id) ? accLicensesNum.get(acc.Id) : acc.Total_Licenses__c;
        }

        update accList;        
    }
    public static void CheckContact(List<Instance__c> records){  
        Map<ID,Schema.RecordTypeInfo> rt_map = Instance__c.sObjectType.getDescribe().getRecordTypeInfosById();      
        for (Instance__c inst : records) {
            if(rt_map.get(inst.recordTypeID).getName().containsIgnoreCase('Standard Instance') && inst.Account__c == null){
                throw new AccountException('Create Account');
            }
        }        
    }
}
