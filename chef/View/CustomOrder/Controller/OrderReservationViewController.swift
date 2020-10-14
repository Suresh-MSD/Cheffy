//
//  OrderReservationViewController.swift
//  chef
//
//  Created by Eddie Ha on 21/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import KDCalendar

protocol OrderReservationDelegate {
    func setDate(selectDate: Date, fromTime: String?, toTime: String?, isAllDay: Bool)
}

class OrderReservationViewController: BaseViewController {

    //MARK: Properties
    public let CLASS_NAME = OrderReservationViewController.self.description()
    public var delegate: OrderReservationDelegate?
    private var fromTimePicker = UIPickerView()
    private var toTimePicker = UIPickerView()
    private var pickerIsInvalid = true
    private var fromIsSelected = true
    private let timeArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" ]
    private let PMAMArray = ["am", "pm"]
    private var fromTimeText = "6"
    private var fromPMAMText = "am"
    private var toTimeText = "6"
    private var toPMAMText = "pm"
    private var selectedDate: Date?
    
    //MARK: Outlets
    @IBOutlet weak var calenderView: CalendarView!
    @IBOutlet weak var swAllDay: UISwitch!
    @IBOutlet weak var btnReservationOrder: UIButton!
    @IBOutlet weak var fromTimeField: UITextField!
    @IBOutlet weak var toTimeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()
        initCalenderView()
        initPickerAndField(pickerView: fromTimePicker, textField: fromTimeField, tag: 1)
        initPickerAndField(pickerView: toTimePicker, textField: toTimeField, tag: 2)

    }
    

    //MARK: Actions
    //when tap on back button
    @IBAction func onTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onTapReservationOrderRequest(_ sender: UIButton) {

        guard let selectedDate = selectedDate else {
            self.showMessageWith("", "Please select date", .warning)
            return
        }

        let isAllDay = swAllDay.isOn
        if
            let fromDate = fromTimeField.text,
            let toDate = toTimeField.text,
            !isAllDay {

            delegate?.setDate(selectDate: selectedDate, fromTime: fromDate, toTime: toDate, isAllDay: isAllDay)
        } else {
            delegate?.setDate(selectDate: selectedDate, fromTime: nil, toTime: nil, isAllDay: isAllDay)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Instance Method
    //initialize
    private func initialize() -> Void{
        //shadows of buttons
        btnReservationOrder.elevate(elevation: 10, cornerRadius: 0, color: UIColor.red)
        swAllDay.transform = CGAffineTransform(scaleX: 0.70, y: 0.63)
        fromTimeField.text = fromTimeText + fromPMAMText
        toTimeField.text = toTimeText + toPMAMText
    }
    
    //init calender view
    private func initCalenderView() -> Void {
        calenderView.direction = .horizontal
        calenderView.dataSource = self
        calenderView.delegate = self
        
        //        CalendarView.Style.cellShape                = .bevel(8.0)
        //        CalendarView.Style.cellColorDefault         = UIColor.clear
        //        CalendarView.Style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        //        CalendarView.Style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        //        CalendarView.Style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        //        CalendarView.Style.headerTextColor          = UIColor.white
        //        CalendarView.Style.cellTextColorDefault     = UIColor.white
        //        CalendarView.Style.cellTextColorToday       = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        //
        //        CalendarView.Style.cellTextColorWeekend = UIColor.red
        //        calenderView.marksWeekends = true
        //        CalendarView.Style.cellColorOutOfRange = UIColor(white: 0.0, alpha: 0.5)
        //        CalendarView.Style.firstWeekday = .sunday
        //
        //        CalendarView.Style.locale = Locale(identifier: "en_US")
        //
        //        self.calenderView.loadEvents()
        
        
        
        let today = Date()
        self.calenderView.setDisplayDate(today, animated: false)
        self.calenderView.selectDate(today)
    }
    
    private func initPickerAndField(pickerView: UIPickerView, textField: UITextField, tag: Int) {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        textField.tag = tag
        textField.delegate = self
        textField.inputView = pickerView
        textField.inputView = pickerView
        let width = self.view.frame.width
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 1, width: width, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.tappedDone))
        toolbar.setItems([doneItem], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func tappedDone() {
        fromTimeField.endEditing(true)
        toTimeField.endEditing(true)
    }
}


//MARKS: Extensions
//KDCalenderView datasource
extension OrderReservationViewController:CalendarViewDataSource{
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 3
        let today = Date()
        let threeMonthsLater = self.calenderView.calendar.date(byAdding: dateComponents, to: today)
        return threeMonthsLater!
    }
    
    func headerString(_ date: Date) -> String? {
        return "Date"
    }
    
    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let today = Date()
        let threeMonthsAgo = self.calenderView.calendar.date(byAdding: dateComponents, to: today)
        return threeMonthsAgo!
    }
}

extension OrderReservationViewController: CalendarViewDelegate {

    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        // do not anything
    }

    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {

        if let lastSelectedDate = selectedDate {
            calendar.deselectDate(lastSelectedDate)
        }
        selectedDate = date
    }

    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return date > Date().zeroclock
    }

    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        // do not anything
        selectedDate = nil
    }

    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        // do not anything
    }
}

extension OrderReservationViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return timeArray.count
        case 1: return PMAMArray.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return timeArray[row]
        case 1: return PMAMArray[row]
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if fromIsSelected {
            switch component {
            case 0: fromTimeText = timeArray[row]
            case 1: fromPMAMText = PMAMArray[row]
            default: return
            }
            fromTimeField.text = fromTimeText + fromPMAMText
        }else {
            switch component {
            case 0: toTimeText = timeArray[row]
            case 1: toPMAMText = PMAMArray[row]
            default: return
            }
            toTimeField.text = toTimeText + toPMAMText
        }
    }
    
    //picker start by selected row
    func pickerReload(timeText: String, PMAMText: String, Picker: UIPickerView) {
        let selectedTimeIndex = timeArray.firstIndex(of: timeText)
        let selectedPMAMIndex = PMAMArray.firstIndex(of: PMAMText)
        guard let timeIndex = selectedTimeIndex,
            let PMAMIndex = selectedPMAMIndex else {
            return
        }
        Picker.selectRow(timeIndex, inComponent: 0, animated: true)
        Picker.selectRow(PMAMIndex, inComponent: 1, animated: true)
        Picker.reloadAllComponents()
    }
}

extension OrderReservationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            fromIsSelected = true
            pickerReload(timeText: fromTimeText, PMAMText: fromPMAMText, Picker: fromTimePicker)
        }else {
            pickerReload(timeText: toTimeText, PMAMText: toPMAMText, Picker: toTimePicker)
            fromIsSelected = false
        }
    }
}
