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
    var isInitialLoadDone = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getNextDeliveryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UI
    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView.register(DeliveryImageTableViewCell.self, forCellReuseIdentifier: "delCell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.0
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        self.title = "Things to Deliver"
        self.navigationItem.backBarButtonItem?.title = ""
        setupTableView()
    }
    
    fileprivate func getEmptyLabel() -> UILabel {
        let msgLabel = UILabel(frame: view.frame)
        msgLabel.text = ""
        msgLabel.textAlignment = .center
        msgLabel.text = "Could not load data.."
        return msgLabel
    }
    
    //MARK: - Tableview Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = deliveries.count == 0 && isInitialLoadDone ? getEmptyLabel() : nil
        return deliveries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "delCell",
                                                 for: indexPath) as! DeliveryImageTableViewCell
        let delivery = deliveries[indexPath.row]
        cell.configure(desc: delivery.description, url: delivery.imageUrl)
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
        if let deliveriesEncoded = UserDefaults.standard.object(forKey: "Deliveries") as? Data,
            let deliveries = try? JSONDecoder().decode([DeliveryDetail].self,
                                                          from: deliveriesEncoded) {
            self.deliveries = deliveries
            self.request.offset = deliveries.count
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func getNewIndexPaths(start: Int, new: Int) -> [IndexPath]? {
        guard new > 0 else { return nil }
        var newIndexPaths = [IndexPath]()
        for row in start...(start + new-1) {
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
            if self.isInitialLoadDone == false {
                self.isInitialLoadDone = true
            }
            if let newDeliveries = deliveries?.sorted(by: { $0.id < $1.id }),
                let newRows = self.getNewIndexPaths(start: self.deliveries.count,
                                                    new: newDeliveries.count) {
                
                self.deliveries.append(contentsOf: newDeliveries)
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: newRows, with: .top)
                    self.tableView.scrollToRow(at: newRows.first!,
                                               at: .bottom, animated: true)
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
