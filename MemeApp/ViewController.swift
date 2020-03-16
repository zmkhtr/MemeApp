//
//  ViewController.swift
//  MemeApp
//
//  Created by Azam Mukhtar on 08/03/20.
//  Copyright © 2020 Azam Mukhtar. All rights reserved.
//

import UIKit
import ShimmerSwift


class ViewController: UIViewController {

    var memeObject : MemeObjectResponse?
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var imageMeme: UIImageView!
    
    @IBOutlet weak var labelSource: UILabel!
    
    @IBOutlet weak var imagePlaceHolder: UIView!
    
    var mUrl = ""
    
    var notLoading = true
    
    let shimmerView = ShimmeringView(frame: CGRect(x: 20, y: 208, width: 374, height: 530))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateRandomMeme()
    }
    
    func setSourceClickable(url : String){
        labelSource.isUserInteractionEnabled = true
        labelSource.halfTextColorChange(fullText: labelSource.text!, changeText: url, withColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
               labelSource.isUserInteractionEnabled = true
               labelSource.addGestureRecognizer(tap)
         mUrl = url
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
            if let requestUrl = NSURL(string: mUrl) {UIApplication.shared.open(requestUrl as URL)}
    }
    
    func showShimmer(){
        self.view.addSubview(shimmerView)
        
        shimmerView.contentView = imagePlaceHolder
        imageMeme.visibility = .invisible
//
        imagePlaceHolder.visibility = .visible
        shimmerView.isShimmering = true
        shimmerView.shimmerSpeed = 200
        shimmerView.shimmerPauseDuration = 0.0
    }
    
    func hideShimmer(){
        imagePlaceHolder.visibility = .gone
        shimmerView.isShimmering = false
        imageMeme.visibility = .visible
    }
    
    func generateRandomMeme() {
        showShimmer()
        notLoading = false
              let session = URLSession.shared
              let url = URL(string: "https://meme-api.herokuapp.com/gimme")!
              let task = session.dataTask(with: url, completionHandler: { data, response, error in
                              if error != nil {
                                  print(error!)
                                  return
                              }
                  
                              do {
                                  let json = try JSONDecoder().decode(MemeObjectResponse.self, from: data! )
                                self.setMeme(memeObject: json)
                                  print(json)
                                self.notLoading = true
                              } catch {
                                  print("Error during JSON serialization: \(error.localizedDescription)")
                              }
              })
              task.resume()
    }

    func setMeme(memeObject : MemeObjectResponse) {
        let url = URL(string: memeObject.url)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.hideShimmer()
                self.imageMeme.image = UIImage(data: data!)
                self.labelTitle.text = memeObject.title
                self.labelSource.text = "Source : \(memeObject.postLink)"
                self.setSourceClickable(url: memeObject.postLink)
            }
        }
    }
    
    @IBAction func giveMeMeme(_ sender: UIButton) {
        if (notLoading) {
            generateRandomMeme()
        }
    }
    
 
}


