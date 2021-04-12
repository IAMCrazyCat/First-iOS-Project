//
//  ShareViewController.swift
//  Reborn
//
//  Created by Christian Liu on 4/4/21.
//

import UIKit

class ShareViewController: UIViewController {

    
    @IBOutlet var topLineView: UIView!
    @IBOutlet var bottomLineView: UIView!
    @IBOutlet var saveToLibraryButton: UIButton!
    @IBOutlet var preview: UIView!
    @IBOutlet var previewContentView: UIView!
    @IBOutlet var preViewTopContentView: UIView!
    @IBOutlet var previewMiddleContentView: UIView!
    @IBOutlet var previewBottomContentView: UIView!
    
    @IBOutlet var previewAppInformationView: UIView!
    
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var punchInTextLabel: UILabel!
    
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemFinishedDaysLabel: UILabel!
    @IBOutlet var itemTargetDaysLabel: UILabel!
    @IBOutlet var vipButton: UIButton!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppEngine.shared.add(observer: self)
        preview.setShadow()
        avatarImageView.setCornerRadius()
        updateUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        topLineView.setCornerRadius()
        topLineView.alpha = 0
        
        bottomLineView.setCornerRadius()
        bottomLineView.alpha = 0.5
        
        let scale: CGFloat = (self.view.frame.height / self.preview.frame.height) * (1 / 1.58)// 0.65 is the ideal ratio
        print(self.view.frame.height / self.preview.frame.height)
        
        preview.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        setGradientPreviewContentViewBackgroundColor()
        addProgressView()
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.updateUI()
//    }
    
    @IBAction func saveToLibraryButtonPressed(_ sender: Any) {
        let image = self.preview.asImage()
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSavedToLibrary), nil)
    }
    
    @objc func imageSavedToLibrary(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        SystemAlert.present("保存成功", and: "您可以在系统相册里查看并分享", from: self)
    }
    
    func addProgressView() {
//        let progressView = ItemProgressViewBuilder(item: self.item, frame: previewBottomContentView.bounds).buildView()
//        progressView.backgroundColor = .clear
//        previewBottomContentView.addSubview(progressView)
        
    }
    func setGradientPreviewContentViewBackgroundColor() {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [AppEngine.shared.userSetting.themeColor.uiColor.cgColor, AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.2).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: Double.random(in: 0.3 ... 0.7), y: 0.0)
        gradient.endPoint = CGPoint(x: Double.random(in: 0.3 ... 0.7), y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.previewContentView.frame.width, height: self.previewContentView.frame.height)

        self.previewContentView.layer.insertSublayer(gradient, at: 0)
    }
    
    func updateSaveToLibraryButton() {
        self.saveToLibraryButton.setCornerRadius()
        self.saveToLibraryButton.setSmartColor()
        
    }
    
    func updatePreview() {
        if AppEngine.shared.currentUser.isVip {
            vipButton.renderVipIcon()
        } else {
            vipButton.setBackgroundColor(.clear, for: .normal)
        }
        
        avatarImageView.image = AppEngine.shared.currentUser.getAvatarImage()
        previewBottomContentView.layoutIfNeeded()
        
        previewContentView.layer.cornerRadius = 10
        previewAppInformationView.layer.cornerRadius = 10
        
    }
    
    func updateLabels() {
        userNameLabel.text = AppEngine.shared.currentUser.name
        userNameLabel.textColor = AppEngine.shared.userSetting.smartLabelColor
        punchInTextLabel.textColor = AppEngine.shared.userSetting.smartLabelColor
        itemNameLabel.text = "\(item.type.rawValue)\(item.name)"
        itemFinishedDaysLabel.text = "\(item.finishedDays)"
        itemTargetDaysLabel.text = "\(item.targetDays)"
    }
    
    

}

extension ShareViewController: UIObserver {
    func updateUI() {
        updateSaveToLibraryButton()
        updatePreview()
        updateLabels()
    }
}
