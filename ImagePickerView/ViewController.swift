//
//  ViewController.swift
//  ImagePickerView
//
//  Created by Meenal Kewat on 5/22/19.
//  Copyright © 2019 Meenal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        let person = people[indexPath.item]
        cell.lbl.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.img.image = UIImage(contentsOfFile: path.path)
//        cell.img.layer.borderColor = UIColor.red.cgColor
//        cell.img.layer.borderWidth = 2
//        cell.img.layer.cornerRadius = 3
//        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let alertVC = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        alertVC.addTextField()
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertVC.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak alertVC] _ in
                
                guard let newName = alertVC?.textFields?[0].text else {
                    return
                }
                person.name = newName
                self?.collectiionView.reloadData()
            })
        
      present(alertVC, animated: true)
    }
    
    
    
//    func addTextField(){
//
//    }
    
    

    @IBOutlet weak var collectiionView: UICollectionView!
    
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    @objc func addNewPerson(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectiionView.reloadData()
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}

extension ViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bound = collectiionView.bounds
        return CGSize(width: bound.width/2 - 20, height: 210)
    }
}

