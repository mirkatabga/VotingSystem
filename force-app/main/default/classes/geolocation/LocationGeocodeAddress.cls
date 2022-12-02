public with sharing class LocationGeocodeAddress {
    private static Boolean geocodingCalled = false;
    public static void DoAddressGeocode(id locationId) {
        if (geocodingCalled || System.isFuture()) {
            return;
        }
        geocodingCalled = true;
        geocodeAddress(locationId);
    }

    @future(callout=true)
    static private void geocodeAddress(id locationId) {
        // Key for Google Maps Geocoding API
        String geocodingKey = '[Key for Geocoding API]';

        Location__c geoLocation = [
            SELECT Name, Address__c
            FROM Location__c
            WHERE id = :locationId
            Limit 1
        ];

        if ((geoLocation.Address__c == null)) {
            return;
        }

        String geoAddress = geoLocation.Address__c;
        
        geoAddress = EncodingUtil.urlEncode(geoAddress, 'UTF-8');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + geoAddress + '&key=' + geocodingKey + '&sensor=false');
        request.setMethod('GET');
        request.setTimeout(60000);
        try {
            HttpResponse response = http.send(request);
            System.debug(response.getBody());
            JSONParser responseParser = JSON.createParser(response.getBody());
            double latitude = null;
            double longitude = null;
            while (responseParser.nextToken() != null) {
                if ((responseParser.getCurrentToken() == JSONToken.FIELD_NAME) && (responseParser.getText() == 'location')) {
                    responseParser.nextToken();
                    while (responseParser.nextToken() != JSONToken.END_OBJECT) {
                        String locationText = responseParser.getText();

                        responseParser.nextToken();
                        if (locationText == 'lat'){
                            latitude = responseParser.getDoubleValue();
                        }
                        else if (locationText == 'lng')
                            longitude = responseParser.getDoubleValue();
                    }
                }
            }
            if (latitude != null) {
                geoLocation.Postion__Latitude__s = latitude;
                geoLocation.Postion__Longitude__s = longitude;
                update geoLocation;
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error Geocoding Address - ' + e.getMessage());
        }
    }
}
