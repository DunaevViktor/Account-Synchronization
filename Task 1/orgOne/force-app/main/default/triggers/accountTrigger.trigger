trigger accountTrigger on Account (after insert, after update, before delete) {

    TriggerHelper helper = new TriggerHelper();

    if(Trigger.isInsert){
        helper.syncInsertAccount(Trigger.New);
    }
    if(Trigger.isUpdate){
        helper.syncUpdateAccount(Trigger.oldMap, Trigger.newMap);
    }
    if(Trigger.isDelete){
        helper.syncDeleteAccount(Trigger.old);
    }
}