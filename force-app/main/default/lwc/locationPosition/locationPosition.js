import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const LATITUDE = 'Location__c.Postion__Latitude__s'
const LONGITUDE = 'Location__c.Postion__Longitude__s'


export default class LocationPosition extends LightningElement {
    @api recordId;
    error;
    mapMarkers = [];
    zoomLevel = 15;

    @wire(getRecord, { recordId: '$recordId', fields: [LATITUDE, LONGITUDE] })
    wiredLocation({ error, data }) {
        if(data){
            let tempMarkers = [];
            let marker = {
                location: {
                    Latitude: data.fields.Postion__Latitude__s.value,
                    Longitude: data.fields.Postion__Longitude__s.value
                },
            };
            tempMarkers.push(marker);
            this.mapMarkers = tempMarkers;
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }
}