//
//  AddItemViewController.swift
//  Reborn
//
//  Created by Christian Liu on 27/12/20.
//

import UIKit

enum AddItemViewState {
    case adding
    case editing
}

class NewItemViewController: UIViewController {
    @IBOutlet weak var horizentalScrollView: UIScrollView!
    @IBOutlet weak var horizentalContentView: UIView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    //ItemName
    @IBOutlet weak var itemNameTextfield: UITextField!
    //Icon picker
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var unfoldButton: UIButton!
    //Item Type
    @IBOutlet weak var persistingTypeButton: UIButton!
    @IBOutlet weak var quittingTypeButton: UIButton!
    //Item Target
    @IBOutlet weak var sevenDaysButton: UIButton!
    @IBOutlet weak var thirtyDaysButton: UIButton!
    @IBOutlet weak var oneHundredDaysButton: UIButton!
    @IBOutlet weak var customTargetDaysButton: UIButton!
    //Item Frequency
    @IBOutlet weak var everydayFrequencyButton: UIButton!
    @IBOutlet weak var everyWeekFreqencyButton: UIButton!
    @IBOutlet weak var everyMonthFrequencyButton: UIButton!
    @IBOutlet weak var customFrequencyButton: UIButton!
    @IBOutlet weak var turnOffNotificationButton: UIButton!
    @IBOutlet weak var customNotificationButton: UIButton!
    
    @IBOutlet weak var firstInstructionLabel: UILabel!
    @IBOutlet weak var secondInstructionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verticalScrollViewContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var iconCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet var promptTextView: UIView!
    @IBOutlet var promptLabel: UILabel!
    
    
    @IBOutlet var typeButtons: [UIButton]!
    @IBOutlet var targetButtons: [UIButton]!
    @IBOutlet var frequencyButtons: [UIButton]!
    @IBOutlet var notificationButtons: [UIButton]!
    
    var originalItemForRecovery: Item!
    
    let engine: AppEngine = AppEngine.shared
    let setting: SystemSetting = SystemSetting.shared
    var frequency: CustomData? = nil
    var previewItemCardTag: Int? = nil
    var selectedTypeButton: UIButton? = nil
    var selectedTargetDaysButton: UIButton? = nil
    var selectedFrequencyButton: UIButton? = nil
    var selectedNotificationButton: UIButton? = nil
    //var lastSelectedButton: UIButton? = nil
    var item: Item = Item(ID: AppEngine.shared.currentUser.getLargestItemID() + 1, name: "一件事", days: 1, frequency: EveryDay(), creationDate: CustomDate.current, type: .undefined, icon: Icon.defaultIcon1, notificationTimes: [CustomTime]())
    var preViewItemCard: UIView = UIView()
    var strategy: NewItemViewStrategy? = nil
    var lastViewController: UIViewController? = nil
    var selectedIconIndex: IndexPath? {
        if let row = self.engine.getItemCardIconIndex(by: item.icon.name) {
            return IndexPath(row: row, section: 0)
        } else if let firstCell = self.iconCollectionView.visibleCells.first {
            return self.iconCollectionView.indexPath(for: firstCell)
        } else {
            return nil
        }
            
    }
    var userDidSaveChange: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalItemForRecovery = Item(ID: item.ID, name: item.name, days: item.targetDays, frequency: item.newFrequency, creationDate: item.creationDate, type: item.type, icon: self.item.icon, notificationTimes: item.notificationTimes)

        originalItemForRecovery.energy = item.energy
        originalItemForRecovery.state = item.state
        
        engine.add(observer: self)
        persistingTypeButton.setTitle("坚持", for: .normal)
        quittingTypeButton.setTitle("戒除", for: .normal)
        
        itemNameTextfield.delegate = self
        verticalScrollView.delegate = self
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        iconCollectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        iconCollectionView.scrollToItem(at: selectedIconIndex ?? IndexPath(row: 0, section: 0), at: .left, animated: true)
        originalCollectionViewHeight = iconCollectionViewHeightConstraint.constant
        //selectedIcon = item.icon
        
       
        customFrequencyButton.setTitle(setting.customButtonTitle, for: .normal)
        customTargetDaysButton.setTitle(setting.customButtonTitle, for: .normal)
        customTargetDaysButton.tag = setting.customTargetDaysButtonTag
        customFrequencyButton.tag = setting.customFrequencyButtonTag
        customFrequencyButton.isHidden = true // Hide
        selectedNotificationButton = turnOffNotificationButton
        itemNameTextfield.setPadding()
        itemNameTextfield.tintColor = engine.userSetting.themeColor.uiColor
        itemNameTextfield.addTarget(self, action: #selector(textfieldTextChanged(_:)), for: .editingChanged)
        itemNameTextfield.layer.cornerRadius = setting.textFieldCornerRadius
        setButtonsAppearance()
        view.layoutIfNeeded()
        verticalScrollViewContentViewHeightConstraint.constant = secondInstructionLabel.frame.origin.y + 40
        
        
        self.strategy?.initializeUI()
        self.updateUI()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 14.0, *) {
            self.updateUI()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !userDidSaveChange {
            if let originalItem = self.originalItemForRecovery {
                self.item.icon = originalItem.icon
                self.item.name = originalItem.name
                self.item.targetDays = originalItem.targetDays
                self.item.newFrequency = originalItem.newFrequency
                self.item.type = originalItem.type
                self.item.energy = originalItem.energy
                self.item.state = originalItem.state
                self.item.notificationTimes = originalItem.notificationTimes
            }
            
        }
    }
    

    
    @objc func textfieldTextChanged(_ sender: UITextField!) {
        self.item.name = sender.text ?? ""
        self.updateUI()

    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        
        self.selectedTypeButton = sender
        if sender.tag == 1 {
            self.item.type = .persisting
        }
        
        if sender.tag == 2 {
            self.item.type = .quitting
            self.selectedFrequencyButton = everydayFrequencyButton
            self.item.newFrequency = EveryDay()
        }
        
        self.updateUI()
    }
    
    
    @IBAction func targetDaysButtonPressed(_ sender: UIButton) {
        self.selectedTargetDaysButton = sender
        if sender.tag == self.setting.customTargetDaysButtonTag {
            
            self.strategy?.show(.customTargetDaysPopUp)
            
        } else {
            self.customTargetDaysButton.setTitle("自定义", for: .normal)
            self.item.targetDays = sender.getData() ?? 1
        }
        self.item.updateState()
        self.updateUI()
    }
    
    @IBAction func frequencyButtonPressed(_ sender: UIButton) {
        self.selectedFrequencyButton = sender
        
        switch sender.tag {
        case 1: self.item.newFrequency = EveryDay()
        case 2: self.present(.everyWeekFreqencyPopUp, newFrequency: self.item.newFrequency)
        case 3: self.present(.everyMonthFreqencyPopUp, newFrequency: self.item.newFrequency)
        default: break
        }
        self.item.updateState()
        self.updateUI()
    }
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        self.selectedNotificationButton = sender
        
        switch sender.tag {
        case 1:
            self.item.notificationTimes.removeAll()
            self.customNotificationButton.setTitle("自定义", for: .normal)
        case 2: self.present(.itemNotificationTimePopUp, item: self.item)
        default: break
        }
        self.updateUI()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        userDidSaveChange = false
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if self.selectedNotificationButton == self.turnOffNotificationButton {
            self.item.notificationTimes.removeAll()
            self.customNotificationButton.setTitle("自定义", for: .normal)
        }
        userDidSaveChange = true
        self.strategy?.doneButtonPressed(sender)
    }
    
    
    
    var unfolded: Bool = true
    var originalCollectionViewHeight: CGFloat!
    
    @IBAction func unfoldButtonPressed(_ sender: Any) {
        Vibrator.vibrate(withImpactLevel: .light)
        foldAndUnfoldCollectionView()
    }
    
    @objc func deleteItemButtonPressed(_ sender: UIButton) {
        showAlert()
    }
    
    func foldAndUnfoldCollectionView() {
        let layout = iconCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection  = self.unfolded ? .vertical : .horizontal
        self.iconCollectionViewHeightConstraint.constant = unfolded ? 200 : originalCollectionViewHeight
        
        self.selectedIconIndex?.row ?? IndexPath(row: 0, section: 0).row > 5 ? self.iconCollectionView.scrollToTop(animated: false) : self.iconCollectionView.scrollToTop(animated: true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.unfoldButton.transform = CGAffineTransform(rotationAngle: self.unfolded ? .pi : 0)
            self.verticalContentView.layoutIfNeeded()
        }) { _ in
            self.verticalScrollViewContentViewHeightConstraint.constant += self.unfolded ? -200 : 200
        }
        self.iconCollectionView.scrollToItem(at: self.selectedIconIndex ?? IndexPath(row: 0, section: 0), at: self.unfolded ? .centeredVertically : .centeredHorizontally, animated: true)
        
        

        
        unfolded = !unfolded
    }
    
    
    private func showAlert() {
        let alert = UIAlertController(title: "你真的想删除该项目吗", message: "该项目所有的数据将会被删除，且不能恢复", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
            self.deleteItemWithAnimation()
            NotificationManager.shared.removeAllNotification(of: self.item)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        

        self.present(alert, animated: true)
    }
    
    private func deleteItemWithAnimation() {
        
        
        UIView.animate(withDuration: 1, animations: {
            self.preViewItemCard.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }) { _ in
            
            self.engine.currentUser.delete(item: self.item)
            self.engine.saveUser()
            UIManager.shared.updateUIAfterItemWasDeleted()
            self.dismiss(animated: true) {
  
                if let parentViewController = self.lastViewController as? ItemDetailViewController {
                    parentViewController.goBackToParentView()
                }
            }
        }
        
    }
    
    func updateInstructionLabels() {
        
        if self.item.type == .quitting {
            self.firstInstructionLabel.isHidden = true
            self.secondInstructionLabel.text = "戒除项目需要您坚持每天打卡"
        } else {
            self.firstInstructionLabel.text = "提醒会在您设置的频率内和时间向您发送通知"
            self.secondInstructionLabel.text = "默认设为关闭，但不会影响固定提醒的通知推送"
            self.firstInstructionLabel.isHidden = false
        }
    }
    
    func updateFrequencyButtons() {
        
        
        if self.item.type == .quitting {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.everyWeekFreqencyButton.alpha = 0
                self.everyMonthFrequencyButton.alpha = 0
                
            }) { _ in

                self.everyWeekFreqencyButton.isHidden = true
                self.everyMonthFrequencyButton.isHidden = true
            }
            
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {

                self.everyWeekFreqencyButton.isHidden = false
                self.everyMonthFrequencyButton.isHidden = false
                self.everyWeekFreqencyButton.alpha = 1
                self.everyMonthFrequencyButton.alpha = 1
               
            })
        }
   
    }
    
    func removeOldPreviewItemCard() {
        if self.previewItemCardTag != nil {
            
            for subview in self.view.viewWithTag(2)!.subviews {
                if subview.tag == self.previewItemCardTag {
                    subview.removeFromSuperview() // remove old card
                }
            }
        }
    }
    
    func updatePreViewItemCard() {
        self.view.layoutIfNeeded()
        self.horizentalContentView.renderItemCard(by: self.item)
        self.previewItemCardTag = self.preViewItemCard.tag
        self.preViewItemCard = self.horizentalContentView.subviews.first!
        Vibrator.vibrate(withImpactLevel: .light)
    }
    
    func excuteItemCardAimation() {
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                self.preViewItemCard.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.4, animations: {
                self.preViewItemCard.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.2, animations: {
                self.preViewItemCard.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
            
        }) { _ in
            
        }
       
    }
    
    func setButtonsAppearance() {
        doneButton.setTitleColor(self.engine.userSetting.smartVisibleThemeColor, for: .normal)
        
        for button in self.optionButtons {
            button.proportionallySetSizeWithScreen()
            button.setCornerRadius()
            button.setShadow(style: .button)
            button.setBackgroundColor(self.engine.userSetting.themeColor.uiColor, for: .selected)
            button.setTitleColor(self.engine.userSetting.smartLabelColor, for: .selected)
        }
    }
    
    func updatePromptLabel() {
        if selectedTypeButton != nil && selectedFrequencyButton != nil && selectedTargetDaysButton != nil && itemNameTextfield.text != "" {
            promptLabel.isHidden = true
        }
    }
    
    func updatePromptTextView() {
        
        if let sublayers = promptTextView.layer.sublayers {
            for layer in sublayers {
                if layer.name == "Gradient" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        promptTextView.layoutIfNeeded()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [AppEngine.shared.userSetting.whiteAndBlackBackground.cgColor, AppEngine.shared.userSetting.whiteAndBlackBackground.withAlphaComponent(0).cgColor]
        //gradient.locations = [0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = promptTextView.bounds
        gradient.name = "Gradient"
        self.promptTextView.layer.insertSublayer(gradient, at: 0)
    }
    
    func updateIconCollectionView() {
       
        iconCollectionView.reloadData()
        
    }
    
    func updateButtonSelections() {
        for button in optionButtons {
            button.isSelected = false
        }
        selectedTypeButton?.isSelected = true
        selectedTargetDaysButton?.isSelected = true
        selectedFrequencyButton?.isSelected = true
        selectedNotificationButton?.isSelected = true
    }
    
}

extension NewItemViewController: UIObserver {
    func updateUI() {
        updateFrequencyButtons()
        updateInstructionLabels()
        removeOldPreviewItemCard()
        //excuteItemCardAimation()
        updatePreViewItemCard()
        updatePromptLabel()
        updatePromptTextView()
        updateIconCollectionView()
        updateButtonSelections()
    }
}

extension NewItemViewController: PopUpViewDelegate { // Delegate extension
 
    func didDismissPopUpViewWithoutSave(_ type: PopUpType) {
        
        switch type {
        case .everyWeekFreqencyPopUp, .everyMonthFreqencyPopUp:
            switch self.item.newFrequency.type {
            case .everyDay: self.selectedFrequencyButton = self.everydayFrequencyButton
            case .everyWeek, .everyWeekdays: self.selectedFrequencyButton = self.everyWeekFreqencyButton
            case .everyMonth: self.selectedFrequencyButton = self.everyMonthFrequencyButton
            }
            
        case .customTargetDaysPopUp:
            self.selectedTargetDaysButton = nil
            self.customTargetDaysButton.setTitle("自定义", for: .normal)
            switch self.item.targetDays {
            case 7:
                self.sevenDaysButton.isSelected = true
                self.selectedTargetDaysButton = self.sevenDaysButton
            case 30:
                self.thirtyDaysButton.isSelected = true
                self.selectedTargetDaysButton = self.thirtyDaysButton
            case 100:
                self.oneHundredDaysButton.isSelected = true
                self.selectedTargetDaysButton = self.oneHundredDaysButton
            default:
                self.customTargetDaysButton.isSelected = true
                self.selectedTargetDaysButton = self.customTargetDaysButton
                
            }
        case .itemNotificationTimePopUp:
            
            if let notificationTime = self.item.notificationTimes.first {
                self.selectedNotificationButton = self.customNotificationButton
                self.customNotificationButton.setTitle("\(notificationTime.getTimeString())", for: .normal)
            } else {
                self.selectedNotificationButton = self.turnOffNotificationButton
                self.customNotificationButton.setTitle("自定义", for: .normal)
            }
            
        default: break
        }

        
        updateUI()
    }
    
    func didSaveAndDismiss(_ type: PopUpType) {
        
        switch type {
        case .customTargetDaysPopUp:
            
            guard let selectedData = (self.engine.getStoredDataFromPopUpView() as? CustomData) else { return }
            self.selectedTargetDaysButton?.setTitle(selectedData.title, for: .normal)
            self.item.targetDays = selectedData.data ?? 1
            
        case .everyWeekFreqencyPopUp:
            
            if let weekdays = (self.engine.getStoredDataFromPopUpView() as? Array<WeekDay>) {
                
                switch weekdays.count {
                case 0:
                    self.selectedFrequencyButton = nil
                case 1 ... 6:
                    self.item.newFrequency = EveryWeekdays(weekDays: weekdays)
                case 7:
                    self.selectedFrequencyButton = everydayFrequencyButton
                    self.item.newFrequency = EveryDay()
                default: break
                }

            } else if let days = (self.engine.getStoredDataFromPopUpView() as? Int) {
                
                switch days {
                case 1 ... 6:
                    self.item.newFrequency = EveryWeek(days: days)
                case 7:
                    self.selectedFrequencyButton = everydayFrequencyButton
                    self.item.newFrequency = EveryDay()
                default: break
                }
            }
            
        case .everyMonthFreqencyPopUp:
            if let days = (self.engine.getStoredDataFromPopUpView() as? Int) {
                self.item.newFrequency = EveryMonth(days: days)
            }
        case .itemNotificationTimePopUp:
            if let notificationTime = (self.engine.getStoredDataFromPopUpView() as? [CustomTime])?.first {
                self.customNotificationButton.setTitle("\(notificationTime.getTimeString())", for: .normal)
                self.item.notificationTimes.removeAll()
                self.item.notificationTimes.append(notificationTime)
            }
        default: break
        }
        self.updateUI()
    }
    
}

extension NewItemViewController: UIScrollViewDelegate, UITextFieldDelegate {
    // scrollView delegate function
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.itemNameTextfield.resignFirstResponder()
    }
    
    // keyboard delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.itemNameTextfield.resignFirstResponder()
        return true
    }
}

extension NewItemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    @objc func cellButtonPressed(_ sender: UIButton) {
        if let iconName = sender.accessibilityIdentifier {
            self.item.icon = self.engine.getItemCardIcon(by: iconName) ?? (self.item.type == .quitting ? Icon.defaultIcon2 : Icon.defaultIcon1)
            //self.selectedIcon = self.engine.getItemCardIcon(by: iconName)
        }
        
        self.updateUI()

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.engine.getItemCardIcons().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath) as! IconCell
        cell.iconButton.addTarget(self, action: #selector(self.cellButtonPressed(_:)), for: .touchUpInside)
        cell.updateUI(withIcon: self.engine.getItemCardIcons()[indexPath.row], selectedIcon: self.item.icon)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    
}
