//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Kevin Largo on 12/12/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

// Regift constants
let frameCount = 32;
let delayTime: Float = 0.2
let loopCount = 0;

extension UIViewController: UINavigationControllerDelegate {
    
    @IBAction func presentVideoOptions(_ sender: Any) {
        if(!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            launchCamera();
        } else {
            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: .actionSheet);
            
            let recordVideo: UIAlertAction = UIAlertAction(title: "Record a Video", style: .default, handler: { action in
                self.launchCamera();
            });
            
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .default, handler: { action in
                self.launchPhotoLibrary();
            });
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
            
            newGifActionSheet.addAction(recordVideo);
            newGifActionSheet.addAction(chooseFromExisting);
            newGifActionSheet.addAction(cancel);
            
            present(newGifActionSheet, animated: true, completion: nil);
            newGifActionSheet.view.tintColor = UIColor(displayP3Red: 255/255, green: 65/255, blue: 112/255, alpha: 1);
        }
    }
    
    func launchCamera() {
        present(pickerController(with: .camera), animated: true, completion: nil);
    }
    
    func launchPhotoLibrary() {
        present(pickerController(with: .photoLibrary), animated: true, completion: nil);
    }

    func pickerController(with source: UIImagePickerControllerSourceType) -> UIImagePickerController {
        
        let picker: UIImagePickerController = UIImagePickerController();
        picker.sourceType = source;
        picker.mediaTypes = [kUTTypeMovie as String];
        picker.allowsEditing = false;
        picker.delegate = self;
        
        return picker;
    }
}

extension UIViewController: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil);
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String;
        
        if(mediaType == kUTTypeMovie as String) {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL;
            //UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path!, nil, nil, nil);
            dismiss(animated: true, completion: nil);
            convertVideoToGIF(videoURL: videoURL);
        }
    }
    
    func convertVideoToGIF(videoURL: NSURL) {
        let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime);
        let gifURL = regift.createGif();
    }
}
