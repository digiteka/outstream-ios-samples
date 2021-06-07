//
//  DetailViewControler.swift
//  DigitekaSample
//
//  Created by Gilles SAMPIERI on 23/04/2021.
//

import Foundation
import UIKit
import DigitekaSDK

class DetailViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var outstreamView: OutstreamView!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    @IBOutlet weak var outstreamViewHeight: NSLayoutConstraint!
    
    var outstreamViewLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        // Initialize OustreamView with config
        let outstreamViewConfig = OutstreamViewConfig(urlReferer: "https://ultimedia.com",
                                                      zone: 1)
        outstreamView.initialize(config: outstreamViewConfig, delegate: self)
        
        // Override consentString
        Digiteka.shared.config.consentString = "CO9E0YNO9Yz7EAHABAFRA0CsAP_AAH_AAAAAGYtf_X9fb2vj-_5999t0eY1f9_63v-wzjgeNs-8NyZ_X_L4Xr2MyvB34pq4KmR4Eu3LBAQdlHGHcTQmQwIkVqTLsak2Mq7NKJ7JEilMbM2dYGG1vn8XTuZCY70_sf__z_3-_-___67YGXkEmGpfAQJCWMBJNmlUKIEIVxIVAOACihGFo0sNCRwU7K4CPUACABAYgIwIgQYgoxZBAAAAAElEQAkAwIBEARAIAAQArQEIACJAEFgBIGAQACoGhYARRBKBIQZHBUcogQFSLRQTzRgAA"
    }
    
    //MARK: - Actions
    @IBAction func didTapLoad(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        // Load an ad
        outstreamView.load()
    }
    
    @IBAction func didTapReload(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        outstreamView.reload()
    }
    
    @IBAction func didTapClose(_ sender: UIBarButtonItem) {
        outstreamView.close(animated: false)
    }
    
    @IBAction func didTapUpdateConsent(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter consentString",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Consent String"
        }

        let action = UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            Digiteka.shared.config.consentString = alert?.textFields?.first?.text
            self.outstreamView.load()
        })
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapShowConsent(_ sender: UIButton) {
        let alert = UIAlertController(title: "consentString", message: Digiteka.shared.config.consentString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapResetConsent(_ sender: UIButton) {
        Digiteka.shared.config.consentString = nil
        outstreamView.load()
    }
}


//MARK: - UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if outstreamView.frame.intersects(scrollView.bounds) && !outstreamViewLoaded {
            activityIndicator.startAnimating()
            outstreamView.load()
        }
        
        outstreamView.scrollViewDidScroll(scrollView)
        let intersectionFrame = scrollView.bounds.intersection(outstreamView.frame)
        let percent = (intersectionFrame.size.height*intersectionFrame.size.width)/(outstreamView.frame.width*outstreamView.frame.height)*100
        
        visibilityLabel.text = "visibility: \(percent)"
    }
}


//MARK: - OutstreamViewDelegate
extension DetailViewController: OutstreamViewDelegate {
    func didUpdateHeight(_ ad: OutstreamView, height: CGFloat) {
        print("[DIGITEKA] didUpdateHeight \(height)")
        outstreamViewHeight.constant = height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func onClose(_ ad: OutstreamView) {
        print("[DIGITEKA] onClose")
        outstreamViewHeight.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didReceiveAd(_ ad: OutstreamView) {
        print("[DIGITEKA] receiveAd: \(ad)")
        outstreamViewLoaded = true
        activityIndicator.stopAnimating()
    }
}
