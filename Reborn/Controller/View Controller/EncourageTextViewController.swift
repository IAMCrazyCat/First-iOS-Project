//
//  EncourageTextViewController.swift
//  Reborn
//
//  Created by Christian Liu on 4/7/21.
//

import UIKit

class EncourageTextViewController: UIViewController {
    
    public enum State {
        case normal
        case editing
    }
    
    @IBOutlet weak var floatingFiledView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eiditingButton: UIBarButtonItem!
    public var state: State = .normal
    let offset: CGFloat = 20
    let engine: AppEngine = AppEngine.shared
    var textViews: [EncourageTextView] = []
    var keyboardFrame: CGRect? = nil
    var strategy: VIPStrategy!
    override func viewDidLoad() {
        super.viewDidLoad()
        strategy = EncourageTextStrategy(encourageTextViewController: self)
        scrollView.delegate = self
        title = "激励语"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(keyboardShowNotification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        engine.add(observer: self)
        addEncorageTextViews()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for textView in textViews {
            textView.stopAnimation = true
        }
    }
    
    @objc
    func keyboardWillShow(keyboardShowNotification notification: Notification) {
        
        print("KeyboardWillShow")
        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.contentViewBottomConstraint.constant = -keyboardFrame.height
            self.keyboardFrame = keyboardFrame
        }
        
        
    }
    
    @objc
    func keyboardDidHide(keyboardShowNotification notification: Notification) {
        print("KeyboardDidHide")
        self.keyboardFrame = nil
        
       
    }
    
    private func addEncorageTextViews() {
        self.contentView.layoutIfNeeded()
        let horizentalGap: CGFloat = 40
        let verticalGap: CGFloat = 40
        let originalCordinateX: CGFloat = horizentalGap
        let originalCordinateY: CGFloat = verticalGap
        let maxmumNumberOfViewsInOneRow: Int = 2
        var cordinateX: CGFloat = originalCordinateX
        var cordinateY: CGFloat = originalCordinateY
        let textViewWidth: CGFloat = (self.contentView.frame.width - CGFloat(maxmumNumberOfViewsInOneRow + 1) * horizentalGap) / CGFloat(maxmumNumberOfViewsInOneRow)
        let textViewHeight: CGFloat = textViewWidth / 1.5
        let textViewSize: CGSize = CGSize(width: textViewWidth, height: textViewHeight)
        var currentNumberOfViewsInOneRow: Int = 1
        
        for text in engine.userSetting.encourageText {
           
            let textView = EncourageTextView(text: text, frame: CGRect(x: cordinateX, y: cordinateY, width: textViewSize.width, height: textViewSize.height), movingField: CGSize(width: self.floatingFiledView.frame.size.width, height: self.floatingFiledView.frame.size.height - 100), delegate: self)
            self.contentView.addSubview(textView)
            self.textViews.append(textView)
            
            if currentNumberOfViewsInOneRow > maxmumNumberOfViewsInOneRow - 1 {
                cordinateX = originalCordinateX
                cordinateY += textView.frame.height + verticalGap
                currentNumberOfViewsInOneRow = 1
            } else {
                cordinateX += textView.frame.width + horizentalGap
                currentNumberOfViewsInOneRow += 1
            }
            
    
            if textView.frame.maxY > self.contentView.frame.height {
                contentViewHeightConstraint.constant = textView.frame.maxY - self.contentView.frame.height
            }
            
            //scrollView.contentSize.height = textView.frame.maxY
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        Vibrator.vibrate(withImpactLevel: .light)
        self.strategy.performStrategy()
    }
    
    private func excuteMovingBackAnimation() {
        for textView in textViews {
            textView.moveBack()
        }
    }
    
    private func excuteFloatingFieldAnimation() {
        for textView in textViews {
            textView.move()
        }
    }
    
    private func updateLayout() {
        if self.state == .normal {
            self.saveEditing()
            self.scrollView.isUserInteractionEnabled = false
            self.eiditingButton.title = "编辑"
            excuteFloatingFieldAnimation()
            
            
        } else if self.state == .editing {
            self.scrollView.isUserInteractionEnabled = true
            self.eiditingButton.title = "完成"
            excuteMovingBackAnimation()
        }
    }
    
    private func saveEditing() {
        var encourageText: [String] = []
        for textView in self.textViews {
            
            encourageText.append(textView.textView.text)
        }
        self.engine.userSetting.encourageText = encourageText
        self.engine.saveSetting()
    }
    

}

extension EncourageTextViewController: UIObserver {
    func updateUI() {
        updateLayout()
    }
}

extension EncourageTextViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
                textView.resignFirstResponder()
                return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.scrollView.scrollToTop(animated: true)
        
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("TextViewDidBeginEditing")
        Vibrator.vibrate(withImpactLevel: .light)
        if let encourageTextView = textView.superview as? EncourageTextView, let keyboardHeight = keyboardFrame?.height  {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: encourageTextView.frame.origin.y - encourageTextView.frame.height), animated: true)
        }

       

    }
}

extension EncourageTextViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")

    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("ScrollViewDidScrollToTop")
        self.contentViewBottomConstraint.constant = 0
    }
}
