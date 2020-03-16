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
//    @IBOutlet weak var imagePlaceHolder: UIView!
    @IBOutlet weak var imageContainer: UIView!
    var mUrl = ""
    
    var notLoading = true
    
    let shimmerView = ShimmeringView(frame: CGRect(x: 0, y: 154, width: 414, height: 564))
    
    let listMemeSource = ["memes":"https://meme-api.herokuapp.com/gimme/memes/100",
                      "dank":"https://meme-api.herokuapp.com/gimme/dankmemes/100",
                      "trending":"https://meme-api.herokuapp.com/gimme/PewdiepieSubmissions/100"]
    
    var listMemeImage = [Meme]()
    
    var memeUrl : String? = "https://meme-api.herokuapp.com/gimme/memes/100"
    
    var imgUrlShow = ""

    @IBOutlet weak var segmentedControlMemeCategory: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateRandomMeme()
        setSegmentedControl()
        
        if (imgUrlShow != ""){
            setImageClickAble()
        }
    }
    
    func setImageClickAble(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(tapGestureRecognizer:)))
                 imageContainer.isUserInteractionEnabled = true
                imageContainer.addGestureRecognizer(tapGestureRecognizer)
        
        print("SETT")
    }
    
    @IBAction func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        _ = tapGestureRecognizer.view as! UIImageView
        print("LOHE")
        performSegue(withIdentifier: "viewDetailSegue", sender: self)
        print("CLICK")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destination = segue.destination as? PreviewImageController {
            destination.imgUrl = imgUrlShow
           }
    }
    
    func setSegmentedControl(){
        segmentedControlMemeCategory.insertSegment(withTitle: "Trending Meme", at: 2, animated: true)
    }
    
    @IBAction func categoryControl(_ sender: UISegmentedControl){
           switch sender.selectedSegmentIndex {
             case 0:
                memeUrl = listMemeSource["memes"]
            generateRandomMeme()
             case 1:
                memeUrl = listMemeSource["dank"]
                generateRandomMeme()
             case 2:
                memeUrl = listMemeSource["trending"]
                generateRandomMeme()
             default:
                memeUrl = listMemeSource["memes"]
                generateRandomMeme()
             }
    }
    func setSourceClickable(url : String){
//        labelSource.isUserInteractionEnabled = true
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
        
        shimmerView.contentView = imageContainer
        
        imageMeme.isHidden = true
//        imageContainer.isHidden = true
        imageContainer.isHidden = false
        
        shimmerView.isShimmering = true
        shimmerView.shimmerSpeed = 200
        shimmerView.shimmerPauseDuration = 0.0
    }
    
    func hideShimmer(){
        
//        imageContainer.isHidden = true
        imageContainer.isHidden = false
        imageMeme.isHidden = false
        
        shimmerView.isShimmering = false
    }
    
    func generateRandomMeme() {
        showShimmer()
        notLoading = false
              let session = URLSession.shared
              let url = URL(string: memeUrl!)!
              let task = session.dataTask(with: url, completionHandler: { data, response, error in
                              if error != nil {
                                  print(error!)
                                  return
                              }
                  
                              do {
                                  let json = try JSONDecoder().decode(MemeObjectResponse.self, from: data! )
//                                self.setMeme(memeObject: json)
                                self.fetchImageList(memeObject: json.memes)
                                  print(json)
                                self.notLoading = true
                              } catch {
                                  print("Error during JSON serialization: \(error.localizedDescription)")
                              }
              })
              task.resume()
    }
    
    func fetchImageList(memeObject : [Meme]){
        listMemeImage.append(contentsOf: memeObject)
        setMeme(memeObject: memeObject[Int.random(in: 0...memeObject.count-1)])
    }

    func setMeme(memeObject : Meme) {
        let url = URL(string: memeObject.url)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.imgUrlShow = memeObject.url
                self.hideShimmer()
                self.imageMeme.image = UIImage(data: data!)
                self.labelTitle.text = memeObject.title
                self.labelSource.text = "Source : \(memeObject.postLink)"
                self.setSourceClickable(url: memeObject.postLink)
                self.setImageClickAble()
            }
        }
    }
    
    @IBAction func giveMeMeme(_ sender: UIButton) {
        if (notLoading) {
            setMeme(memeObject: listMemeImage[Int.random(in: 0...listMemeImage.count-1)])
        }
    }
    
 
}


