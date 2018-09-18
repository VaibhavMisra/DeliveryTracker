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
        tableView.register(DeliveryImageTableViewCell.self, forCellReuseIdentifier: "delCell")
        self.view.addSubview(tableView!)
    }
    
    //MARK: - Tableview Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveries == nil ? 0 : deliveries!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "delCell", for: indexPath) as! DeliveryImageTableViewCell
        let delivery = deliveries![indexPath.row]
        
        cell.descLabel.text = delivery.description
        cell.loadImageFrom(url: delivery.imageUrl, placeHolder: UIImage(named: "DeliveryPlaceholder"))
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DeliveryDetailViewController()
        if let del = deliveries?[indexPath.row] {
            detailVC.delivery = del
            detailVC.image = imageCache.object(forKey: NSString(string: del.imageUrl))
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: - API method
    private func getDeliveryList() {
        guard let url = URL(string: "https://mock-api-mobile.dev.lalamove.com/deliveries?limit=20&offset=0") else {
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
                self.deliveries = deliveries.sorted(by: { $0.id < $1.id })
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
