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
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
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
        let delivery = deliveries![indexPath.row]
        cell.textLabel!.text = delivery.description
//        DispatchQueue.global(qos: .userInitiated).async {
//            let url = URL(string: delivery.imageUrl)
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//            session.dataTask(with: url!, completionHandler: { (data, response, error) in
//                guard let data = data else {return}
//                let image = UIImage(data: data)
//                DispatchQueue.main.async {
//                    cell.imageView?.image = image
//                }
//            }).resume()
//        }
        return cell
    }
    
    //MARK: - API method
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
