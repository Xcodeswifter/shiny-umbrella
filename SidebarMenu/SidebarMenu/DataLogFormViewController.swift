//
//  DataLogFormViewController.swift
//  GCTRACKV2
//  Class used for filtering the data log
//  Created by Carlos Torres on 9/8/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire



class DataLogFormViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var trackerLabel: UILabel!
    
    @IBOutlet weak var pump1: UIImageView!
    @IBOutlet weak var sw3: UISwitch!
    @IBOutlet weak var sw2: UISwitch!
    @IBOutlet weak var sw1: UISwitch!
    @IBOutlet weak var pumpLabel3: UILabel!
    @IBOutlet weak var pumpLabel2: UILabel!
    @IBOutlet weak var pumpLabel1: UILabel!
    @IBOutlet weak var pump3: UIImageView!
    @IBOutlet weak var pump2: UIImageView!
    @IBOutlet weak var event: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var ApplyFiltersButton: UIButton!
   
    @IBOutlet weak var dataLogLabel: UILabel!
    var filteredDataLog = [[String: String]]()
    var pumplog = [String]()
    
    var pickerData: [String] = [String]()
    var selectedEvent:String=""
    var params:[String:AnyObject] = [:]
    var pumpSelected1=0
    var pumpSelected2=0
    var pumpSelected3=0
    var strDate:String=""
    var endingDate:String=""
    var toolBar:UIToolbar?=nil
    var begindatePickerView:UIDatePicker? = nil
    var enddatePickerView:UIDatePicker? = nil
    var selectEventPickerView:UIPickerView? = nil
    var didIFilterData=false
    var isMapSelected = false
    var isTrackerMenuSelected = false
    
    
    
    //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        startDate.delegate=self
        endDate.delegate=self
        event.delegate=self
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        requestcheckPumps()
        setDateFromOneWeekToToday()
        setTodayDate()
        
    }
    
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true
    self.performSegue(withIdentifier: "logfiltertomap", sender: self)
    
    }
    
    
    
    func requestcheckPumps(){
        
        let prefs:UserDefaults = UserDefaults.standard
        let idtracker:Int = prefs.integer(forKey: "IDTRACKER") as Int
        
        
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/checkpump_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })
        
        
        
    }
    
    
    
    
    
    //MARK UIPickerViewMethods
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    
    
    
    
    
    
    //returns the data for the selected row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        event.text=pickerData[row]
        
    }
    
    
    
    
    //optimized
    func parseJSON(_ json: JSON) {
        
        let pump1 = json["pump01_type"].stringValue
        let pump2 = json["pump02_type"].stringValue
        let pump3 = json["pump03_type"].stringValue
        pumplog.append(pump1)
        pumplog.append(pump2)
        pumplog.append(pump3)
        
    comparePumpLogData()
        
    }
    
    
    func comparePumpLogData(){
        
        if(pumplog[0]=="0"&&pumplog[1]=="0"&&pumplog[2]=="0"){
           disableAllFilterOptions()
            
            
        }
        
        
        
        //No pumps available
        if(pumplog[0]=="0"){
            self.pumpLabel1.text="Unavailable"
            self.sw1.isEnabled=false
            
            
        }
        if(pumplog[1]=="0"){
            self.pumpLabel2.text="Unavailable"
            self.sw2.isEnabled=false
        
        
        }
        if(pumplog[2]=="0"){
            self.pumpLabel3.text="Unavailable"
            self.sw3.isEnabled=false
        
        }
        
        
        
        //First pump
        
        if(pumplog[0]=="1"){
            self.pump1.image=UIImage(named: "cuadritodiesel")
            self.pumpLabel1.text="Diesel"
            
        }
        if(pumplog[0]=="2"){
            self.pump1.image=UIImage(named: "cuadritoelectrica")
            self.pumpLabel1.text="Motor"
            
        }
        if(pumplog[0]=="3"){
            self.pump1.image=UIImage(named: "cuadritojockey")
            self.pumpLabel1.text="Jockey"
        }
        
        
        //Second pump
        if(pumplog[1]=="1"){
            self.pump2.image=UIImage(named: "cuadritodiesel")
            self.pumpLabel2.text="Diesel"
        }
        if(pumplog[1]=="2"){
            self.pump2.image=UIImage(named: "cuadritoelectrica")
            self.pumpLabel2.text="Motor"
        }
        if(pumplog[1]=="3"){
            self.pump2.image=UIImage(named: "cuadritojockey")
            self.pumpLabel2.text="Jockey"
        }
        
        
        //Third pump
        if(pumplog[2]=="1"){
            self.pump3.image=UIImage(named: "cuadritodiesel")
            self.pumpLabel3.text="Diesel"
        }
        if(pumplog[2]=="2"){
            self.pump3.image=UIImage(named: "cuadritoelectrica")
            self.pumpLabel3.text="Motor"
        }
        if(pumplog[2]=="3"){
            self.pump1.image=UIImage(named: "cuadritojockey")
            self.pumpLabel3.text="Jockey"
        }
        
        
    }
    
    
    
    
    
    /// If there is not pumps available for a tracker all buttons and options will be disabled
    // with the sole exception of back button
    func disableAllFilterOptions(){
        event.isEnabled=false
        startDate.isEnabled=false
        endDate.isEnabled=false
        ApplyFiltersButton.isEnabled=false
        
    }
    

    
    
    
    //MARK- Actions
    
    
    @IBAction func chooseEndingDate(_ sender: AnyObject) {
    }
    
    
    
    
    @IBAction func goToMain(_ sender: AnyObject) {
       
        self.performSegue(withIdentifier: "returntodatalog", sender: self)
        
    }
    
    
    
    //optimized
    
    @IBAction func selectEvent(_ sender: UITextField) {
        showSelectEventPickerView(sender)
        
    }
    
    //optimized
    
    @IBAction func selectBeginDate(_ sender: UITextField) {
        
        showBeginDatePickerView(sender)
        
        
        
        
    }
    
    
    //optimized
    
    @IBAction func selectEndDate(_ sender: UITextField) {
        
        showEndDatePickerView(sender)
        
    }
    
    
    //Optimized
    
    @IBAction func FilterData(_ sender: AnyObject) {
        compareFilters()
        if(compareStringDates(beginDate: startDate.text!, endingDate:endDate.text!)){
           didIFilterData=true
            self.performSegue(withIdentifier: "returntodatalog", sender: self)

            }
        else{
            showErrorMessage()
        }
        
    }
    
    //MARK PickerViews and Compare filters
    
    func compareFilters(){
        
        let prefs:UserDefaults = UserDefaults.standard
        let idtracker:Int = prefs.integer(forKey: "IDTRACKER") as Int
        
        
        if(sw1.isOn==true){
            pumpSelected1=1
        }else{
            pumpSelected1=0
        }
        
        if(sw2.isOn==true){
            pumpSelected2=1
        }else{
            pumpSelected2=0
        }
        
        
        if(sw3.isOn){
            pumpSelected3=1
        }
        else{
            pumpSelected3=0
        }
        
        params = [ "id_tracker": idtracker as AnyObject,"pump01":pumpSelected1 as AnyObject, "pump02":pumpSelected2 as AnyObject,"pump03":pumpSelected3 as AnyObject,"pump_status":event.text! as AnyObject,"start_date":startDate.text as AnyObject,"end_date":endDate.text as AnyObject ]
        
        
    }
    
    
    //This method compares the dates as strings not by using NSDATE extension methods found
    //in dateComparators.swift
    func compareStringDates(beginDate:String, endingDate:String)->Bool{
   

        if(beginDate<endingDate){
            return true
        }
       return false
    
    }
    
    
    
    
    func showSelectEventPickerView(_ sender:UITextField){
        
        pickerData = ["All", "Diesel Engine Running", "Diesel Non Auto Mode", "Diesel Pump Trouble", "Electric Pump Operating", "Electric Phase Failure","Electric Reversed Phase","Electric General Alarm on"]
        
        
        
        selectEventPickerView = UIPickerView()
        
        selectEventPickerView?.delegate = self
        selectEventPickerView?.dataSource = self
        
        
        sender.inputView = selectEventPickerView
        
        toolBar = UIToolbar()
        toolBar?.barStyle = UIBarStyle.default
        toolBar?.isTranslucent = true
        toolBar?.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(DataLogFormViewController.doneelectEventPicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action:#selector(DataLogFormViewController.canceleventPicker))
        
        toolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar?.isUserInteractionEnabled = true
        
        sender.inputAccessoryView = toolBar
        
        
        
        
    }
    
    
    
    
    
    
    
    func showBeginDatePickerView(_ sender:UITextField){
        begindatePickerView = UIDatePicker()
        
        begindatePickerView?.datePickerMode = UIDatePickerMode.date
        begindatePickerView?.setDate(NSCalendar.current.date(byAdding: .day, value: -7, to: Date())!, animated: true)
        

        sender.inputView = begindatePickerView
        
        toolBar = UIToolbar()
        toolBar?.barStyle = UIBarStyle.default
        toolBar?.isTranslucent = true
        toolBar?.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar?.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(DataLogFormViewController.formatSelectedDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action:#selector(DataLogFormViewController.beginDatecancelPicker))
        
        toolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar?.isUserInteractionEnabled = true
        
        sender.inputAccessoryView = toolBar
        
        
        begindatePickerView?.addTarget(self, action: #selector(DataLogFormViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    
    
    func showEndDatePickerView(_ sender:UITextField){
        enddatePickerView = UIDatePicker()
        
        enddatePickerView?.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = enddatePickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(DataLogFormViewController.endDatedonePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action:#selector(DataLogFormViewController.endDatecancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sender.inputAccessoryView = toolBar
        
        
        enddatePickerView?.addTarget(self, action: #selector(DataLogFormViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func showErrorMessage(){
        let alert = UIAlertController(title: "Error", message: "Please introduce a valid date interval", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      
        
    }
    

    
    // MARK Picker delegates
    
    
    func doneelectEventPicker(sender:UIBarButtonItem){
        event.resignFirstResponder()
    }
    
    func canceleventPicker(sender:UIBarButtonItem){
        event.resignFirstResponder()
        
        
    }
    func endDatedonePicker(sender:UIBarButtonItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateObj:String = dateFormatter.string(from: (enddatePickerView?.date)!)
        
        endDate.text=dateObj
        endDate.resignFirstResponder()
    }
    
    
    
    func setTodayDate(){
        let today = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj:String = dateFormatter.string(from: (today) as Date)
        
        endDate.text=dateObj
    }
    
    
    func setDateFromOneWeekToToday(){
        
        let sevenDaysAgo = NSCalendar.current.date(byAdding: .day, value: -7, to: Date())
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj:String = dateFormatter.string(from: (sevenDaysAgo)! as Date)
        
        startDate.text=dateObj
        
    }
    
    
    func formatSelectedDate(sender:UIBarButtonItem){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateObj:String = dateFormatter.string(from: (begindatePickerView?.date)!)
        
        
        startDate.text=dateObj
        startDate.resignFirstResponder()
        
        
    }
    
    func beginDatecancelPicker(sender:UIBarButtonItem){
        
        startDate.resignFirstResponder()
    }
    
    
    
    
    func endDatecancelPicker(sender:UIBarButtonItem){
        endDate.resignFirstResponder()
        
    }
    
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        
    }
    
    
    
   
    
    
    
    
    //MARK Navigation
    
    
    @IBAction func unwindToDataLogFilter(segue: UIStoryboardSegue) {}

    
    
    
    @IBAction func goToSelectTracker(_ sender: Any){
isTrackerMenuSelected = true
        
        self.performSegue(withIdentifier: "logFiltersToSelectTracker", sender: self)

}

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        
        
        if(didIFilterData==true){
        let nextScene =  segue.destination as! DataLogViewController
        
       
        let filteredData = self.params
      
        
        
        nextScene.paramsForFiltering = filteredData
        nextScene.isDataFiltered = true
        nextScene.pumpSelected1 = pumpSelected1
        nextScene.pumpSelected2 = pumpSelected2
        nextScene.pumpSelected3 = pumpSelected3
        nextScene.strDate=startDate.text!
        nextScene.endDate=endDate.text!
        }
        
        
        if(isMapSelected){
        isMapSelected = false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "DataLogFormViewController"
            
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "DataLogFormViewController"
        }

    }
    
    
}

