//
//  TimezoneAPI.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import Foundation

class TimezoneAPI {
    
    // Properties
    private let baseURL = "http://localhost:5000/api/timezone/"
    private let session = URLSession.shared
    
    // Singletone reference
    static let shared = TimezoneAPI()
    
    private init() {
        // Add any additional initial confirguration here as needed.
    }
    
    func getTimezone(zipcode:String,_ result: @escaping (LocationData?) -> Void) {
        
        // Combine baseURL and zip code to create URL
        guard let url = URL(string:baseURL + zipcode) else {
            return
        }
        
        var request = URLRequest(url: url)
        // Add api key to header
        request.setValue("b064b6d2-8fbd-48b0-ac29-1a88237ce022", forHTTPHeaderField: "X-Application-Key")
        
        // make API Request with given URL and URLRequest
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, requestError: Error?) in
            
            // Log any network errors
            if let error = requestError {
                print("[TimezoneAPI] Request error: ",error.localizedDescription)
                result(nil)
                return
            }
            
            // Validate that the correct response is being received
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    // incorrect status code in response
                    print("[TimezoneAPI] Request returned unexpected status code (",response.statusCode,")")
                    result(nil)
                    return
                }
            }
            
            // Decode json data into LocationData and return via completion handler
            if let data = data {
                let decoder = JSONDecoder()
                // API uses snake case i.e. some_name
                // Our data model uses camel case, i.e. someName
                // Set the convertion strategy to match
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let locationData = try decoder.decode(LocationData.self, from: data)
                    result(locationData)
                } catch  {
                    // Log any issue decoding to json data
                    print("[TimezoneAPI] Json Decoding failed with:", error)
                    result(nil)
                }
            }
            
        }.resume()
    }
}
