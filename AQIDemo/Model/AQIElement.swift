
import Foundation
import CoreLocation
// MARK: - AQIElement
struct AQIElement: Codable {
    let siteName, county, aqi: String
    let pollutant: String
    let status: String
    let so2, co: String
    let co8Hr: String
    let o3, o38Hr, pm10, pm25: String
    let no2, nOx, no, windSpeed: String
    let windDirec: String
    let publishTime: String
    let pm25_Avg, pm10Avg, so2Avg, longitude: String
    let latitude, siteID: String
    
    enum CodingKeys: String, CodingKey {
        case siteName = "SiteName"
        case county = "County"
        case aqi = "AQI"
        case pollutant = "Pollutant"
        case status = "Status"
        case so2 = "SO2"
        case co = "CO"
        case co8Hr = "CO_8hr"
        case o3 = "O3"
        case o38Hr = "O3_8hr"
        case pm10 = "PM10"
        case pm25 = "PM2.5"
        case no2 = "NO2"
        case nOx = "NOx"
        case no = "NO"
        case windSpeed = "WindSpeed"
        case windDirec = "WindDirec"
        case publishTime = "PublishTime"
        case pm25_Avg = "PM2.5_AVG"
        case pm10Avg = "PM10_AVG"
        case so2Avg = "SO2_AVG"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case siteID = "SiteId"
    }
}
extension AQIElement: CustomStringConvertible {
    var description: String {
        return "Site:\(siteName)\t\tAQI:\(aqi)\tStatus:\(status)\tCountry:\(county)"
    }
}
// MARK: AQIElement convenience initializers and mutators

extension AQIElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AQIElement.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        siteName: String? = nil,
        county: String? = nil,
        aqi: String? = nil,
        pollutant: String? = nil,
        status: String? = nil,
        so2: String? = nil,
        co: String? = nil,
        co8Hr: String? = nil,
        o3: String? = nil,
        o38Hr: String? = nil,
        pm10: String? = nil,
        pm25: String? = nil,
        no2: String? = nil,
        nOx: String? = nil,
        no: String? = nil,
        windSpeed: String? = nil,
        windDirec: String? = nil,
        publishTime: String? = nil,
        pm25_Avg: String? = nil,
        pm10Avg: String? = nil,
        so2Avg: String? = nil,
        longitude: String? = nil,
        latitude: String? = nil,
        siteID: String? = nil
        ) -> AQIElement {
        return AQIElement(
            siteName: siteName ?? self.siteName,
            county: county ?? self.county,
            aqi: aqi ?? self.aqi,
            pollutant: pollutant ?? self.pollutant,
            status: status ?? self.status,
            so2: so2 ?? self.so2,
            co: co ?? self.co,
            co8Hr: co8Hr ?? self.co8Hr,
            o3: o3 ?? self.o3,
            o38Hr: o38Hr ?? self.o38Hr,
            pm10: pm10 ?? self.pm10,
            pm25: pm25 ?? self.pm25,
            no2: no2 ?? self.no2,
            nOx: nOx ?? self.nOx,
            no: no ?? self.no,
            windSpeed: windSpeed ?? self.windSpeed,
            windDirec: windDirec ?? self.windDirec,
            publishTime: publishTime ?? self.publishTime,
            pm25_Avg: pm25_Avg ?? self.pm25_Avg,
            pm10Avg: pm10Avg ?? self.pm10Avg,
            so2Avg: so2Avg ?? self.so2Avg,
            longitude: longitude ?? self.longitude,
            latitude: latitude ?? self.latitude,
            siteID: siteID ?? self.siteID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension String {
    func publishDate() -> Date {
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd HH:mm"
        return fm.date(from: self)!
    }
}


enum Status: String, Codable {
    case 普通 = "普通"
    case 良好 = "良好"
}

typealias Aqi = [AQIElement]

extension Array where Element == Aqi.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Aqi.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    func queryWith(with lati: Double,lon:Double) -> (AQIElement?,Int) {
        let aqis:Aqi = self
        var currentDistance:Double = Double.greatestFiniteMagnitude
        var nearestSite:AQIElement? = nil
        let currentCoor = CLLocation(latitude: lati, longitude: lon)
        var targetIndex = 0
        for i in 0..<aqis.count {
            let ele = aqis[i]
            guard let aqiLat = Double(ele.latitude),
                let aqiLon = Double(ele.longitude) else { return (nil,i) }
            
            let aqiCoor = CLLocation(latitude: aqiLat, longitude: aqiLon)
            let d = currentCoor.distance(from: aqiCoor)
            if d < currentDistance {
                currentDistance = d
                nearestSite = ele
                targetIndex = i
            }
        }
        return (nearestSite,targetIndex)
    }
    
    
    
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func aqiTask(with url: URL, completionHandler: @escaping (Aqi?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
    class func fetch(completeHandler:(Error?) -> () ){
        let req = URLRequest(url: URL(string: "http://opendata.epa.gov.tw/ws/Data/AQI/?$format=json")!)
        let task = shared.dataTask(with: req) { (d, resp, err) in
            guard let _ = d,
                let ds:Aqi = try? Aqi(data: d!) else{
                    return
            }
            ds.forEach({ (e) in
                print(e)
            })
        }
        task.resume()
    }
}

