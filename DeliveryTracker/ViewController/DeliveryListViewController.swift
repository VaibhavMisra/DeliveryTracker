//
//  DeliveryListViewController.swift
//  DeliveryTracker
//
//  Created by Vaibhav Misra on 15/09/18.
//  Copyright © 2018 Vaibhav Misra. All rights reserved.
//

import UIKit

class DeliveryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var deliveries: [DeliveryDetail]?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getDeliveryList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        self.title = "Things to Deliver"
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView.rowHeight = 100.0
        self.view.addSubview(tableView!)
    }
    
    //MARK: - Tableview Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveries == nil ? 0 : deliveries!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        let leadingContraintImageView = NSLayoutConstraint(item: cell.imageView!, attribute: .leading, relatedBy: .equal, toItem: cell.imageView?.superview!, attribute: .leadingMargin, multiplier: 1.0, constant: 8.0)
        let widthConstraint = NSLayoutConstraint(item: cell.imageView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 88.0)
        let aspectRationConstraint = NSLayoutConstraint(item: cell.imageView!, attribute: .width, relatedBy:.equal , toItem: cell.imageView!, attribute: .height, multiplier: 1.0, constant: 0)
        let leadingContraint = NSLayoutConstraint(item: cell.textLabel!, attribute: .left, relatedBy: .equal, toItem: cell.imageView!, attribute: .right, multiplier: 1.0, constant: 8.0)
        let horizontalAlignmentConstraint = NSLayoutConstraint(item: cell.textLabel!, attribute: .centerY, relatedBy: .equal, toItem: cell.imageView!, attribute: .centerY, multiplier: 1.0, constant: 0)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.addConstraint(aspectRationConstraint)
        NSLayoutConstraint.activate([leadingContraintImageView, widthConstraint,aspectRationConstraint, leadingContraint, horizontalAlignmentConstraint])
        cell.textLabel!.numberOfLines = 0
        cell.imageView?.layoutIfNeeded()
        
        let delivery = deliveries![indexPath.row]
        cell.textLabel!.text = delivery.description
        cell.imageView?.imageFromServerURL(delivery.imageUrl, placeHolder: UIImage(named: "DeliveryPlaceholder"))
        return cell
    }
    
    //MARK: - API method
    private func getDeliveryList() {
        guard let url = URL(string: "http://localhost:8080/deliveries?limit=100&offset=0") else {
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
                self.deliveries = deliveries
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(deliveries)
            } catch let err {
                print(err)
            }
        }.resume()
    }

}
