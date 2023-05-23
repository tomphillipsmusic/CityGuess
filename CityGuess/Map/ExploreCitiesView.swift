//
//  ExploreCitiesView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/23/23.
//

import SwiftUI
import MapKit

struct GeoNamesCity: Codable, Identifiable, City {
    let country: String
    let name: String
    let lat: String
    let lng: String

    var id: String {
        country + name + lat + lng
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
    }
}

struct ExploreCitiesView: View {
    @State private var region = MKCoordinateRegion()
    @State private var cities: [GeoNamesCity] = []
    
    @Binding var currentScreen: Router.Screen
    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: cities) { city in
                MapAnnotation(coordinate: city.coordinate) {
                    Text(city.name)
                }
            }
                .navigationTitle("Explore")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back \(cities.count)") {
                            currentScreen = .menu
                        }
                    }
                }
                .task {
                    do {
                        cities = try Bundle.main.decode([GeoNamesCity].self, from: "bigcities.json")
                        
                        let localCities: [TeleportCity] = try await LocalCityService().loadCities()
                        let localCityNames = localCities.map { $0.name }
                        
                        cities = cities.filter({ localCityNames.contains($0.name) })
                        
                       
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        
                        if let dumbJson = try? encoder.encode(cities) {
                            print(String(data: dumbJson, encoding: .utf8)!.replacingOccurrences(of: "\\", with: ""))

                        }
                    } catch {
                        print("Error reading cities from json: \(error)")
                    }
                }
        }
    }
}

struct ExploreCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCitiesView(currentScreen: .constant(.explore))
    }
}
