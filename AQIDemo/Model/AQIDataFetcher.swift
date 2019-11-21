//
//  AQIDataFetcher.swift
//  AQIDemo
//
//  Created by WellKu on 2019/6/6.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
// API: https://opendata.epa.gov.tw/ws/Data/AQI/?$format=json
enum AQIDataFetcher {
    static func updateAQIs() -> Promise<Aqi> {
        return Promise { seal in
            let utilQueue = DispatchQueue(label: "back.fetch", qos: .utility);
            let url = "https://opendata.epa.gov.tw/ws/Data/AQI/?$format=json"
            var request = URLRequest(url: URL(string: url)!)
            request.timeoutInterval = 60
            
            AF.request(request).responseJSON(queue: utilQueue) { (response) in
                    
                    switch response.result {
                    case .success(_):
                        guard let d = response.data,
                            let aqis = try? Aqi(data: d) else {
                            return seal.reject(AFError.responseValidationFailed(reason: .dataFileNil))
                        }
                        seal.fulfill(aqis)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}
