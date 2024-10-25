import { LightningElement, track } from 'lwc';

export default class NewMap extends LightningElement {
    ShowDetail = false;
    latitude;
    longitude;
    temp;
    selectedMarkerValue;
    markerIndex;
    
    @track
    mapMarkers = [
        {
            location: {
                Latitude: '35.7796',
                Longitude: '10.7073'
            },
            title: 'Roma',
            description: 'Via Roma, 1, 00184 Roma, Italy',
            icon: 'utility:frozen',
            value: 'marker0'
        }
    ]

    async getCoord(city, country) {
        try {
            const response = await fetch(`https://api.opencagedata.com/geocode/v1/json?q=${city}%2C+${country}&key=c8ec8303f76045f78484989e399342fe`);
            const data = await response.json();
            console.log('Response data:', data);
            if (data.results.length > 0) {
                this.latitude = data.results[0].geometry.lat;
                this.longitude = data.results[0].geometry.lng;
                //
                return { lat: this.latitude, lng: this.longitude };
            } else {
                throw new Error('No results found');
            }
        } catch (error) {
            console.error('Error fetching coordinates:', error);
            return null;
        }
    }
    async getWeather(lat,lng) {
        try{
            const response = await fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lng}&appid=b426444f10e7e2e2b5b064b59c46c60d&units=metric`);
            const data = await response.json();
            console.log('Response data:', data);
            if(data.main){
                this.temp = data.main.temp;
                return this.temp;
            }
        }
        catch(error){
            console.error('Error fetching weather:', error);
        }
    }

    async getIcon(weather){
        if(weather <= 20 && weather >= 5){
            return 'custom:custom97';
        }
        else if(weather > 20){
            return 'custom:custom3';
        }
        else{
            return 'utility:frozen';
        }
    }

    handleMarkerSelect(event) {
        this.ShowDetail = true;
        this.selectedMarkerValue = event.detail.selectedMarkerValue;
        console.log('Selected Marker Value:', event.detail);
        const selectedMarker = this.mapMarkers.find(marker => marker.value === this.selectedMarkerValue);
        console.log('Selected :', this.mapMarkers);
        if (selectedMarker) {
            console.log('Selected Marker:', selectedMarker);
            const lat = selectedMarker.location.Latitude;
            const lng = selectedMarker.location.Longitude;
            this.getWeather(lat, lng);
        } else {
            console.error('Selected marker not found in mapMarkers array');
        }
    }
 
    handleClose() {
        this.ShowDetail = false;
    }

    handleClick() {
        // Increment the marker index
        this.markerIndex++;
    
        // Collect input values
        const country = this.template.querySelector('lightning-input[data-id="Country"]').value;
        const city = this.template.querySelector('lightning-input[data-id="City"]').value;
        const address = this.template.querySelector('lightning-input[data-id="Address"]').value;
        const postalCode = this.template.querySelector('lightning-input[data-id="PostalCode"]').value;
        const title = this.template.querySelector('lightning-input[data-id="Title"]').value;
    
        // Fetch coordinates and add the new marker
        this.getCoord(city, country).then(coords => {
            if (coords) {
                const newMarker = {
                    location: {
                        Latitude: coords.lat,
                        Longitude: coords.lng
                    },
                    title: title || 'New Location',
                    description: `${address}, ${city}, ${postalCode}, ${country}`,
                    icon: 'utility:location',
                    value: `marker${this.markerIndex}` // Assign a unique value
                };
    
                // Add the new marker to the mapMarkers array
                this.mapMarkers = [...this.mapMarkers, newMarker];
            }
        });
    }
}