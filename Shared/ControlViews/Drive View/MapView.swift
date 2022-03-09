//
//  MapView.swift
//  Drive (iOS)
//
//  Created by Nick Molargik on 8/14/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @EnvironmentObject var connection: TeslaComponents
    let mapView = MKMapView()
    var locationManager = CLLocationManager()
    
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
            setupManager()
            let mapView = MKMapView(frame: UIScreen.main.bounds)
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
            let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            let location = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
            let coordinateRegion = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(coordinateRegion, animated: true)
        mapView.camera.heading = locationManager.heading?.magneticHeading ?? CLLocationDirection()
            mapView.setCamera(mapView.camera, animated: true)
            return mapView
    }
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {

        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(TeslaComponents())
    }
}

