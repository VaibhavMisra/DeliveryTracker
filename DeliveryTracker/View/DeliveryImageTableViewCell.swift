//
//  DeliveryImageTableViewCell.swift
//  DeliveryTracker
//
//  Created by Vaibhav Misra on 18/09/18.
//  Copyright © 2018 Vaibhav Misra. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class DeliveryImageTableViewCell: UITableViewCell {

    let delImageView = UIImageView()
    let descLabel = UILabel()
    var imageURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        delImageView.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(delImageView)
        contentView.addSubview(descLabel)
        
        delImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0).isActive = true
        delImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0).isActive = true
        delImageView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        delImageView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        descLabel.topAnchor.constraint(equalTo: delImageView.topAnchor).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: delImageView.trailingAnchor, constant: 5.0).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: delImageView.bottomAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0).isActive = true
        
        descLabel.numberOfLines = 0
        delImageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    public func configure(desc: String, url:String) {
        self.descLabel.text = desc
        self.loadImageFrom(url: url,
                           placeHolder: UIImage(named: "DeliveryPlaceholder"))
        self.accessoryType = .disclosureIndicator
    }
    
    //MARK: - Private helper methods
    fileprivate func loadImageFrom(url urlString: String, placeHolder: UIImage?) {
        
        self.imageURL = urlString
        self.delImageView.image = placeHolder
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.delImageView.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: config)
        session.dataTask(with: url,
                         completionHandler: { (data, response, error) in

            if error != nil {
                print("ERROR LOADING IMAGES FROM URL: \(error!)")
                DispatchQueue.main.async {
                    self.delImageView.image = placeHolder
                }
                return
            }
            DispatchQueue.main.async {
                if let data = data, let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage,
                                         forKey: NSString(string: urlString))
                    if(self.imageURL == urlString) {
                        self.delImageView.image = downloadedImage
                    }
                }
            }
        }).resume()
    }
    
}
