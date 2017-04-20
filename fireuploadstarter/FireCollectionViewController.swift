//
//  FireCollectionViewController.swift
//  FireUploadStarter
//
//  Created by Kuan L. Chen on 07/03/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class FireCollectionViewController: UICollectionViewController {

    var fireUploadDic: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let databaseRef = FIRDatabase.database().reference().child("AppCodaFireUpload")
        
        databaseRef.observe(.value, with: { [weak self] (snapshot) in
            
            if let uploadDataDic = snapshot.value as? [String:Any] {
                
                self?.fireUploadDic = uploadDataDic
                self?.collectionView!.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataDic = fireUploadDic {
            
            return dataDic.count
        }
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FireCollectionViewCell
    
        // Configure the cell
        if let dataDic = fireUploadDic {
            let keyArray = Array(dataDic.keys)
            if let imageUrlString = dataDic[keyArray[indexPath.row]] as? String {
                if let imageUrl = URL(string: imageUrlString) {
                    
                    URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            
                            print("Download Image Task Fail: \(error!.localizedDescription)")
                        }
                        else if let imageData = data {
                            
                            DispatchQueue.main.async {
                                
                                cell.fireImageView.image = UIImage(data: imageData)
                            }
                        }
                        
                    }).resume()
                }
            }
        }
    
        return cell
    }

}
