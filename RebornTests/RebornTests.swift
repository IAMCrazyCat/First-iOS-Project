//
//  RebornTests.swift
//  RebornTests
//
//  Created by Christian Liu on 16/12/20.
//

import XCTest
@testable import Reborn

class RebornTests: XCTestCase {
    
    var engine: AppEngine!
    var user: User!

    override func setUpWithError() throws {
        print("-------------------------------------------------------------------------------------------------------------------------------------------------------------------")
        super.setUp()
        engine = AppEngine.shared
        user = User(name: "测试用户", gender: .male, avatar: #imageLiteral(resourceName: "Test"), energy: 2, items: [Item](), isVip: false)
        user.items.append(Item(ID: 1, name: "测试1", days: 100, frequency: .everyday, creationDate: CustomDate.current, type: .persisting))
        engine.currentUser = user
        let date = Date()
        let currentYear: Int = Calendar.current.component(.year, from: date)
        let currentMonth: Int = Calendar.current.component(.month, from: date)
        let currentDay: Int = Calendar.current.component(.day, from: date)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func reset() {
        do {
            try setUpWithError()
        } catch {
            print(error)
        }
    }
    
    func testChangeCurrentDate() {
        reset()
        let today = CustomDate.current
        XCTAssertTrue(CustomDate.current == CustomDate(year: today.year, month: today.month, day: today.day + 1))
        
        let testItem = engine.currentUser.items[0]
        for i in 1 ... 10 {
            let nextDay = DateCalculator.calculateDate(withDayDifference: i, originalDate: today)
            self.engine.currentUser.updateItem(withID: 0)
        }
        
        XCTAssertTrue(self.engine.currentUser.items.first!.finishedDays == 0)
        XCTAssertTrue(self.engine.currentUser.items.first!.finishedDays == 10)
    }

    
    func testEnergyCharging() {
        let targetNumberOfEnergy = 1
        for i in 1 ... engine.currentUser.energyChargingEfficiencyDays * targetNumberOfEnergy{
            let nextDate = DateCalculator.calculateDate(withDayDifference: 1, originalDate: CustomDate.current)
            engine.currentUser.updateItem(withID: 0)

        }
        
        XCTAssertTrue(user.energy == 2 + targetNumberOfEnergy)
        print("Expected value: \(2 + targetNumberOfEnergy), Real value: \(user.energy)")
    }
    
    func testVipEnergyCharging() {
        reset()
        engine.currentUser.isVip = true
        let targetNumberOfEnergy = 10
        let originalDate = CustomDate.current
        for i in 1 ... engine.currentUser.energyChargingEfficiencyDays * targetNumberOfEnergy{
            
            let nextDate = DateCalculator.calculateDate(withDayDifference: i, originalDate: originalDate)
            engine.currentUser.updateItem(withID: 0)
        }
        
        XCTAssertTrue(user.energy == 2 + targetNumberOfEnergy)
        print("Expected value: \(2 + targetNumberOfEnergy), Real value: \(user.energy)")
    }
    
    func testRedoPunchInEnergyChanging() {
        reset()
        let targetNumberOfEnergy = 1
        let testItem = engine.currentUser.items[0]
        
        for i in 1 ... engine.currentUser.energyChargingEfficiencyDays * targetNumberOfEnergy{
            let nextDate = DateCalculator.calculateDate(withDayDifference: 1, originalDate: CustomDate.current)
            engine.currentUser.updateItem(withID: 0)
        }
        engine.currentUser.updateItem(withID: 0)
        engine.currentUser.updateItem(withID: 0)
        engine.currentUser.updateItem(withID: 0)
        engine.currentUser.updateItem(withID: 0)
        
        XCTAssertTrue(user.energy == 2 + targetNumberOfEnergy)
        
        print("Expected value: \(2 + targetNumberOfEnergy), Real value: \(user.energy)")
    }
    
    func testTimeMachineNotAffectEnergy() {
        reset()
        let testItem = engine.currentUser.items[0]
        var punchInDatesToAdd: [CustomDate] = []
        for _ in 1 ... 100 {
            punchInDatesToAdd.append(CustomDate(year: Int.random(in: 1000 ... 3000), month: Int.random(in: 1 ... 12), day: Int.random(in: 1 ... 30)))
        }
        
        for date in punchInDatesToAdd {
            testItem.add(punchInDate: date)
        }
        
        engine.currentUser.updateEnergy(by: testItem)
        XCTAssertTrue(user.energy == 2)
        
    }
    
    
    
    func testItemFrequencyChange() {
        let testItem = Item(ID: 1, name: "TEST", days: 3, frequency: .everyday, creationDate: CustomDate.current, type: .persisting)
        var targetScheduleDates: [CustomDate] {
            return [CustomDate(year: CustomDate.current.year, month: CustomDate.current.month, day: CustomDate.current.day),
                    DateCalculator.calculateDate(withDayDifference: testItem.frequency.dataModel.data! * 1, originalDate:  CustomDate.current),
                    DateCalculator.calculateDate(withDayDifference: testItem.frequency.dataModel.data! * 2, originalDate:  CustomDate.current)]
        }
        XCTAssertTrue(testItem.scheduleDates == targetScheduleDates)
        testItem.frequency = .everyTwoDays
        print(targetScheduleDates)
        print(testItem.scheduleDates)
        XCTAssertTrue(testItem.scheduleDates == targetScheduleDates)
        testItem.punchIn()
        XCTAssertTrue(testItem.scheduleDates == targetScheduleDates)
        testItem.frequency = .everyday
        testItem.punchIn()
        XCTAssertTrue(testItem.scheduleDates == targetScheduleDates)
        testItem.frequency = .everyThreeDays
        XCTAssertTrue(testItem.scheduleDates == targetScheduleDates)
        testItem.revokePunchIn()
        testItem.frequency = .everySixDays
        testItem.frequency = .everyWeek
        XCTAssertTrue(testItem.scheduleDates == targetScheduleDates)
        XCTAssertTrue(testItem.state == .inProgress)
        
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

}
