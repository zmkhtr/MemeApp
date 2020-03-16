//
//  PreviewImageController.swift
//  MemeApp
//
//  Created by Azam Mukhtar on 16/03/20.
//  Copyright © 2020 Azam Mukhtar. All rights reserved.
//

import UIKit

class PreviewImageController: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    
    var imgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setMeme()
        
        previewImage.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(sender:)))
        previewImage.addGestureRecognizer(pinchGesture)
        
    }
    

    @objc func pinchGesture(sender:UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
      func setMeme() {
        let url = URL(string: imgUrl)!

         DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
             DispatchQueue.main.async {
                 self.previewImage.image = UIImage(data: data!)
             }
         }
     }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImage
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
