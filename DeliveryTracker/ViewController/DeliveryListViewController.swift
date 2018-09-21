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
    var deliveries = [DeliveryDetail]()
    let request = DeliveryRequest()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getNextDeliveryList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UI
    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView.register(DeliveryImageTableViewCell.self, forCellReuseIdentifier: "delCell")
        self.view.addSubview(tableView!)
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        self.title = "Things to Deliver"
        self.navigationItem.backBarButtonItem?.title = ""
        setupTableView()
    }
    
    //MARK: - Tableview Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "delCell",
                                                 for: indexPath) as! DeliveryImageTableViewCell
        let delivery = deliveries[indexPath.row]
        
        cell.descLabel.text = delivery.description
        cell.loadImageFrom(url: delivery.imageUrl,
                           placeHolder: UIImage(named: "DeliveryPlaceholder"))
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DeliveryDetailViewController()
        let del = deliveries[indexPath.row]
        detailVC.delivery = del
        detailVC.image = imageCache.object(forKey: NSString(string: del.imageUrl))
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard deliveries.count > 0, indexPath.row == (deliveries.count - 1)
            else { return }
        getNextDeliveryList()
    }
    
    //MARK: - Helper methods
    fileprivate func loadSavedDeliveries() {
        if let deliveriesEncoded = UserDefaults.standard.object(forKey: "Deliveries") as? Data {
            if let deliveries = try? JSONDecoder().decode([DeliveryDetail].self,
                                                          from: deliveriesEncoded) {
                self.deliveries = deliveries
                self.request.offset = deliveries.count
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func getNewIndexPaths(start: Int, count: Int) -> [IndexPath]? {
        guard start >= 0, count > 0 else { return nil }
        var newIndexPaths = [IndexPath]()
        for row in start...(start + count-1) {
            newIndexPaths.append(IndexPath(row: row, section: 0))
        }
        return newIndexPaths
    }
    
    //MARK: - API method
    fileprivate func getNextDeliveryList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        request.getNextDeliveries { (deliveries) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let deliveries = deliveries{
                let sorted = deliveries.sorted(by: { $0.id < $1.id })
                let startRow = self.deliveries.count
                let newRowCount = sorted.count
                self.deliveries.append(contentsOf: sorted)
                if let newRows = self.getNewIndexPaths(start: startRow,
                                                       count: newRowCount) {
                    DispatchQueue.main.async {
                        self.tableView.insertRows(at: newRows, with: .top)
                        self.tableView.scrollToRow(at: newRows.first!,
                                                   at: .middle, animated: true)
                    }
                }
                let deliveriesData = try? JSONEncoder().encode(self.deliveries)
                UserDefaults.standard.set(deliveriesData, forKey: "Deliveries")
            }
            else {
                if self.deliveries.count == 0 {
                    self.loadSavedDeliveries()
                }
            }
        }
    }

}
