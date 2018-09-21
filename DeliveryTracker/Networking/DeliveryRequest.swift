//
//  DeliveryRequest.swift
//  DeliveryTracker
//
//  Created by Vaibhav Misra on 21/09/18.
//  Copyright © 2018 Vaibhav Misra. All rights reserved.
//

import Foundation

typealias DeliveryResponseHandler = ([DeliveryDetail]?) -> Void

let baseUrl = "https://mock-api-mobile.dev.lalamove.com/"

class DeliveryRequest {
    let pageSize = 20
    var offset = 0
    var isProcessing = false
    var isComplete = false
    var urlString: String {
        return "\(baseUrl)deliveries?limit=\(pageSize)&offset=\(offset)"
    }
    
    //MARK: - Public methods
    func getNextDeliveries(completion:@escaping DeliveryResponseHandler) {
        guard let url = URL(string: urlString),
            isProcessing == false,
            isComplete == false else {
            completion(nil)
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(url)
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        isProcessing = true
        session.dataTask(with: url) { (data, response, error) in
            self.isProcessing = false
            guard error == nil, let json = data else {
                print(error.debugDescription)
                completion(nil)
                return
            }
            
            do {
                let deliveries = try JSONDecoder().decode([DeliveryDetail].self,
                                                          from: json)
                self.isComplete = deliveries.count == 0 ? true : false
                self.offset += deliveries.count == 0 ? 0 : self.pageSize
                print(deliveries)
                completion(deliveries)
            } catch let err {
                print(err)
                completion(nil)
            }
        }.resume()
    }
    
}
