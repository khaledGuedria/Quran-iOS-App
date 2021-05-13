//
//  MasterViewController.swift
//  QuranApp
//
//  Created by Khaled Guedria on 5/9/21.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import UIKit
import CoreData
import Alamofire


extension UIViewController {

    func hideKeyboardWhenTappedAround() {

        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {

        view.endEditing(true)

    }

}

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //var
    var surahs = [Surah]()
    var filteredSurahs = [Surah]()
    var isFiltering = false
    
    //widgets
    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return isFiltering == true ? filteredSurahs.count : surahs.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let cv = cell?.contentView
        
        let titleLabel = cv?.viewWithTag(1) as! UILabel
        let indexLabel = cv?.viewWithTag(2) as! UILabel
        let countLabel = cv?.viewWithTag(3) as! UILabel
        let audioButton = cv?.viewWithTag(4) as! UIButton
        
        let currentSurah = isFiltering == true ? filteredSurahs[indexPath.row] : surahs[indexPath.row]
        
        titleLabel.text = currentSurah.titleAr
        indexLabel.text = "." + String(Int(currentSurah.index)!)
        audioButton.accessibilityValue = String(Int(currentSurah.index)!)
        audioButton.addTarget(self, action: #selector(self.playSurahAudioAction(_:)), for: .touchUpInside)

        
        if surahs[indexPath.row].count < 11 {
            
            countLabel.text = String(currentSurah.count) + " آية"
        }else {
            
            countLabel.text = String(currentSurah.count) + " آيات"
        }
        
        return cell!
    }
    
    //SEGUE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toSurahDetails", sender: indexPath)
        
    }
    //..
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSurahDetails" {
            
            let indexPath = sender as! IndexPath
            let currentSurah = isFiltering == true ? filteredSurahs[indexPath.row] : surahs[indexPath.row]
            
            let destination = segue.destination as! DetailsViewController
            destination.surahTitle = currentSurah.titleAr
            destination.surahIndex = Int(currentSurah.index)
            destination.surahCount = currentSurah.count
            
        }else if segue.identifier == "toAudioSegue" {
            
            let surahUrl = sender as! String
            
            let destination = segue.destination as! AudioWebViewController
            destination.webURL = surahUrl
            
            
        }
        
        
        
    }
    
    
    
    //FUNCTIONS
    func fetchSurahs() {
        
    DispatchQueue.main.async {
      // 1
        let request = AF.request(Statics.fetchAllUrl)
      // 2
      request.validate()
      request.responseJSON { (response) in
        //print(data)
        switch (response.result) {

            case .success( _):

            do {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.surahs = try JSONDecoder().decode([Surah].self, from: response.data!)
                self.TV.reloadData()

            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }

             case .failure(let error):
                print("Request error: \(error.localizedDescription)")
         }
      }
    }
}
    
    //Open audio website
    @objc func playSurahAudioAction(_ sender: UIButton) {
        
        let Surah_URL = "https://read.quranexplorer.com/" + sender.accessibilityValue!
        performSegue(withIdentifier: "toAudioSegue", sender: Surah_URL)
    }
    
    
    //FILTER TV ..
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if (searchText.count>0) {
                isFiltering = true
                filteredSurahs = surahs.filter {
                    $0.titleAr.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                print(filteredSurahs)
            }
            else
            {
                isFiltering = false
                filteredSurahs = surahs
            }
        
            self.TV.reloadData()
    }
    
    
    //LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.activityIndicator.startAnimating()
        self.fetchSurahs()
        self.searchBar.delegate = self
        
    }
    
    
    //IBACtions

    
   

}

