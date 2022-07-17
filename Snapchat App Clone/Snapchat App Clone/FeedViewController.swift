//
//  FeedViewController.swift
//  Snapchat App Clone
//
//  Created by Yavuz Güner on 15.07.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var choosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getSnapsFormFirebase()
        getUserInfo()
    }
    
    func getSnapsFormFirebase() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot,error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if difference >= 24 {
                                            //24 saati geçtiyse firebase'ten silecez.
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                            }
                                        }else {
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(),timeDifferance: 24 - difference)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData() //for döngüsünden sonra yazarız.
                }
            }
        }
    }
    
    
    //Kullanıcı adı ile işlem yapacağız.Veri çekmek için yazıyoruz.
    func getUserInfo(){
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot,error)  in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
    }
    func makeAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].username
        //SDWebImage'i import ettik. Bunun içindeki ilk item'ı alsın diye 0 seçtik. veya .last yapıp sonuncuyu alırız.
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapViewController
            destinationVC.selectedSnap = choosenSnap
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }


}
