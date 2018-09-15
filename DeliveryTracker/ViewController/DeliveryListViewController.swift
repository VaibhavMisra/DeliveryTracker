//
//  DeliveryListViewController.swift
//  DeliveryTracker
//
//  Created by Vaibhav Misra on 15/09/18.
//  Copyright © 2018 Vaibhav Misra. All rights reserved.
//

import UIKit

class DeliveryListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getDeliveryList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getDeliveryList() {
        guard let url = URL(string: "http://localhost:8080/deliveries?limit=10&offset=0") else {
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        print(url)
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil, let json = data else {
                print(error.debugDescription)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let deliveries = try decoder.decode([DeliveryDetail].self, from: json)
                print(deliveries)
            } catch let err {
                print(err)
            }
            
        }.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
