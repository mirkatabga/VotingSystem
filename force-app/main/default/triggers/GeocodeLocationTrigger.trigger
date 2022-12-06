trigger GeocodeLocationTrigger on Location__c(after insert, after update) {
    for (Location__c loc : Trigger.new) {
        Boolean addressChangedFlag = false;
        if (Trigger.isUpdate) {
            Location__c oldLocation = Trigger.oldMap.get(loc.Id);
            if (loc.Address__c != oldLocation.Address__c) {
                addressChangedFlag = true;
            }
        }
        if ((loc.Postion__Latitude__s == null) || (addressChangedFlag == true)) {
            LocationGeocodeAddress.DoAddressGeocode(loc.id);
        }
    }
}
