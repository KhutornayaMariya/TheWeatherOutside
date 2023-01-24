//
//  GeoCodeResponse.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import CoreLocation

struct GeoCodeResponse: Decodable {
    let response: Response
}

extension GeoCodeResponse {
    struct Response: Decodable {
        let object: GeoObjectCollection
        
        enum CodingKeys: String, CodingKey {
            case object = "GeoObjectCollection"
        }
    }
}

extension GeoCodeResponse.Response {
    struct GeoObjectCollection: Decodable {
        let member: [FeatureMember]
        
        enum CodingKeys: String, CodingKey {
            case member = "featureMember"
        }
    }
}

extension GeoCodeResponse.Response.GeoObjectCollection {
    struct FeatureMember: Decodable {
        let geoObject: GeoObject
        
        enum CodingKeys: String, CodingKey {
            case geoObject = "GeoObject"
        }
    }
}

extension GeoCodeResponse.Response.GeoObjectCollection.FeatureMember {
    struct GeoObject: Decodable {
        let point: Point
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case point = "Point"
            case name
        }
    }
}

extension GeoCodeResponse.Response.GeoObjectCollection.FeatureMember.GeoObject {
    struct Point: Decodable {
        let pos: String
        let lat: String
        let lon: String
        
        enum CodingKeys: String, CodingKey {
            case pos
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            pos = try values.decode(String.self, forKey: .pos)
            let points =  pos.split(separator: " ").map(String.init)
            lat = points[1]
            lon = points[0]
        }
    }
}

extension GeoCodeResponse {
    
    func coordinates() -> CLLocationCoordinate2D? {
        guard let member = response.object.member.first,
              let lat = CLLocationDegrees(member.geoObject.point.lat),
              let lon = CLLocationDegrees(member.geoObject.point.lon)
        else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func name() -> String? {
        guard let member = response.object.member.first else { return nil }
        return member.geoObject.name
    }
}
