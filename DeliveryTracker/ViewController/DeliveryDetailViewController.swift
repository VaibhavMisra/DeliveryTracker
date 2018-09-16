//
//  DeliveryDetailViewController.swift
//  DeliveryTracker
//
//  Created by Vaibhav Misra on 16/09/18.
//  Copyright © 2018 Vaibhav Misra. All rights reserved.
//

import UIKit

class DeliveryDetailViewController: UIViewController {
    
    var delivery: DeliveryDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Delivery Details"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
