//
//  DetailsViewController.swift
//  QuranApp
//
//  Created by Khaled Guedria on 5/11/21.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class DetailsViewController: UIViewController {
    
    //var
    var surahTitle:String?
    var surahIndex:Int?
    var surahCount:Int?
    
    var surah:SurahDetails?
    
    
    //widgets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versesCountLabel: UILabel!
    @IBOutlet weak var VersesContentText: UITextView!
    
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //..
        activityIndicator.startAnimating()
        //..
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 35
        style.alignment = NSTextAlignment(rawValue: 2)!
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        VersesContentText.attributedText = NSAttributedString(string: " ", attributes: attributes)
        //..
        titleLabel.text = surahTitle
        
        fetchSurahVerses(index: surahIndex!)
        if surahCount! < 11 {
            
            versesCountLabel.text = String(surahCount!) + " آيات"
        }else {
            
            versesCountLabel.text = String(surahCount!) + " آية"
        }
    }
    
    //Functions
    func fetchSurahVerses(index: Int) {
        
        DispatchQueue.main.async {
          // 1
            let request = AF.request(Statics.getSurahByIndex + "/surah_" + String(index) + ".json")
          // 2
          request.validate()
          request.responseJSON { (response) in
            //print(data)
            switch (response.result) {

                case .success( _):

                do {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                    self.surah = try JSONDecoder().decode(SurahDetails.self, from: response.data!)

                    for (index,_) in self.surah!.verses.enumerated() {
                        
                        var key = ""
                        if self.surahIndex! == 1 {
                            
                            key = self.surah!.verses["verse_" + String(index + 1)]!
                            
                        }else {
                            
                            key = self.surah!.verses["verse_" + String(index)]!
                            
                        }
                        
                        
                        self.VersesContentText.text.append(key + " ⚜️ ")
                        
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

                 case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
             }
          }
        }
        
    }
    



}
