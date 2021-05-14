//
//  TomatoClockViewController.swift
//  Reborn
//
//  Created by Christian Liu on 31/3/21.
//

import UIKit



class TomatoClockViewController: UIViewController {
    
    @IBOutlet weak var tomatoView: UIView!
    @IBOutlet weak var triangleImageView: UIImageView!
    @IBOutlet weak var startWorkingButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var guidingLabel: UILabel!
    @IBOutlet weak var clockTypeSegmentedControl: UISegmentedControl!
    
    var timePicker: UIPickerView!
    var times: Array<CustomData> = []
    
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    let pickerViewHeight: CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        timerLabel.isHidden = true
        startWorkingButton.setCornerRadius()
        triangleImageView.layoutIfNeeded()
        triangleImageView.transform = CGAffineTransform(rotationAngle: 180  * (.pi/180))
        timePicker = UIPickerView()
        timePicker.dataSource = self
        timePicker.delegate = self
        
        tomatoView.addSubview(timePicker)
        tomatoView.layoutIfNeeded()
        view.layoutIfNeeded()
        timePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.centerXAnchor.constraint(equalTo: tomatoView.centerXAnchor, constant: 5).isActive = true
        timePicker.centerYAnchor.constraint(equalTo: tomatoView.centerYAnchor, constant: 50).isActive = true
        timePicker.widthAnchor.constraint(equalToConstant: pickerViewHeight).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant:  tomatoView.frame.width + 100 ).isActive = true
//        timePicker.frame = CGRect(x: -50, y: triangleImageView.frame.maxY, width: tomatoView.frame.width, height: pickerViewHeight)

        updateUI()
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.updateUI()
//    }
    
    override func viewDidLayoutSubviews() {
        updateStartWorkingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //updateUI()
    }
    
    @IBAction func startWorkingButtonPressed(_ sender: Any) {
        
        
        Vibrator.vibrate(withImpactLevel: .medium)
        CustomTimer.state == .idle ? startTimer() : stopTimer()
        
    }
    
    @IBAction func clockTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        Vibrator.vibrate(withImpactLevel: .light)
        updateUI()
    }
    
    func startTimer() {

        let miniuts: TimeInterval = TimeInterval(self.times[self.timePicker.selectedRow(inComponent: 0)].data!)
        let seconds: TimeInterval = TimeInterval(miniuts * 60)
        
        CustomTimer.createNew(timer: seconds, update: {
            self.updateTimerLabel()
        }) { 
            self.updateUI()
        }
        
        if clockTypeSegmentedControl.selectedSegmentIndex == 0 {
            AppEngine.shared.scheduleTemporaryNotification(title: "\(Int(miniuts))分钟的番茄时钟结束", body: "现在休息一下, 来设置一个休息时钟", after: seconds, identifier: "TomatoClock")
        } else {
            AppEngine.shared.scheduleTemporaryNotification(title: "\(Int(miniuts))分钟休息时间到", body: "现在来设置一个番茄时钟继续工作", after: seconds, identifier: "TomatoClock")
        }
        
        updateUI()
        
    }
    
    func stopTimer() {
        CustomTimer.killTimer()
        AppEngine.shared.removeTemporaryNotification(withIdenifier: "TomatoClock")
        updateUI()
    }
    
    func updateNavigationBar() {
        self.setNavigationBarAppearance()
    }
    
    func updateStartWorkingButton() {
       
        self.startWorkingButton.setSmartColor()
        if self.clockTypeSegmentedControl.selectedSegmentIndex == 0 {
            
            self.startWorkingButton.setTitle(CustomTimer.state == .running ? "停止时钟" : "开始工作", for: .normal)
        } else {

            self.startWorkingButton.setTitle(CustomTimer.state == .running ? "停止时钟" : "开始休息", for: .normal)
        }
    
    }
    
    func updatePotato() {

        if CustomTimer.state == .running {
            guidingLabel.text = self.clockTypeSegmentedControl.selectedSegmentIndex == 0 ? "现在将设备锁屏开始工作\n此时您不应该再打开屏幕" : "休息的时候尽量起身活动一下\n或者闭上眼睛以缓解疲劳"
            timePicker.isHidden = true
            timerLabel.isHidden = false
            clockTypeSegmentedControl.isHidden = true
            timerLabel.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
            })
        } else {
            guidingLabel.text = "滑动刻度表来选定时间"
            timerLabel.isHidden = true
            timePicker.isHidden = false
            clockTypeSegmentedControl.isHidden = false
            timePicker.alpha = 0
            clockTypeSegmentedControl.alpha = 1
            
            UIView.animate(withDuration: 0.5, animations: {
                self.timePicker.alpha = 1
                //self.clockTypeSegmentedControl.alpha = 1
            })
        }
    }
    
    func updateTimerLabel() {
        if CustomTimer.state == .running {
            self.timerLabel.text = "\( CustomTimer.minutes < 10 ? "0" : "")\(CustomTimer.minutes):\(CustomTimer.seconds < 10 ? "0" : "")\(CustomTimer.seconds)"
        }

    }
    
    func continueTimer() {
        CustomTimer.update = updateTimerLabel
    }
    
    func updateTimePicker() {
        
        if self.clockTypeSegmentedControl.selectedSegmentIndex == 0 {
            
            self.times = PickerViewData.tomatoClockTimes
        } else {
            self.times = PickerViewData.tomatoClockBreakTimes
            
        }
        self.timePicker.reloadAllComponents()
        self.timePicker.selectRow(0, inComponent: 0, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timePicker.selectRow(self.clockTypeSegmentedControl.selectedSegmentIndex == 0 ? 1 : 1, inComponent: 0, animated: true)
        }
    }
    
    func updateSegmentedControl() {

        self.clockTypeSegmentedControl.selectedSegmentTintColor = AppEngine.shared.userSetting.themeColor.uiColor
        
        let whiteText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedText = [NSAttributedString.Key.foregroundColor: AppEngine.shared.userSetting.smartLabelColor]
        self.clockTypeSegmentedControl.setTitleTextAttributes(whiteText, for: .normal)
        self.clockTypeSegmentedControl.setTitleTextAttributes(selectedText, for: .selected)
        

    }
    

}

extension TomatoClockViewController: UIObserver {
    func updateUI() {
        updateNavigationBar()
        updateStartWorkingButton()
        updatePotato()
        updateTimerLabel()
        continueTimer()
        updateTimePicker()
        updateSegmentedControl()
    }
    
    
}

extension TomatoClockViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return times.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        timePicker.subviews[1].backgroundColor = UIColor.clear
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: pickerViewHeight, height: pickerViewHeight)
        
        let modeLabel = UILabel(frame: CGRect(x: 0, y: pickerViewHeight / 2, width: pickerViewHeight, height: pickerViewHeight / 2))
        let scale = UIImageView(frame: CGRect(x: 0, y: 0, width: pickerViewHeight, height: pickerViewHeight / 2))
        
        if row == 0 {
            scale.image = #imageLiteral(resourceName: "FirstScale") // first
        } else if row == times.count - 1 {
            scale.image = #imageLiteral(resourceName: "LastScale") // last
        } else {
            scale.image = #imageLiteral(resourceName: "NormalScale") // normal
        }
        
        
        
        modeLabel.textColor = .white
        modeLabel.text = times[row].title
        modeLabel.font = .boldSystemFont(ofSize: 17)
        modeLabel.textAlignment = .center
        modeView.addSubview(modeLabel)
        modeView.addSubview(scale)
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))

        modeView.backgroundColor = .clear
        return modeView
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return pickerViewHeight
    }
}

extension TomatoClockViewController: UIPickerViewDelegate {

}
