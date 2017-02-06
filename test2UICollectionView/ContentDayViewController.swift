//
//  ContentDayViewController.swift
//  test2UICollectionView
//
//  Created by Владимир on 20.01.16.
//  Copyright © 2016 Gorelovskiy. All rights reserved.
//

import UIKit
import CoreData

//UIImagePickerControllerDelegate, UINavigationControllerDelegate - Подключили для сохранения фотографии
// UITextFieldDelegate - нужно для взаимодейсвия с клавиатурой
class ContentDayViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fonImage: UIImageView!
    @IBOutlet weak var buttonImage: UIButton!
    
    
    //--------Цветовая палитра приложения
    
    let pickerViewTextColor = UIColor.black
    
    
    //------------
    var opener: CollectionViewController! //  Для передачи данных из корневого контроллера
    
    var saveTraining: Entity!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mouthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var startTimeTrainingPicker: UITextField!
    @IBOutlet weak var endTimeTrainingPicker: UITextField!
    @IBOutlet weak var locationSurf: UITextField!
    @IBOutlet weak var weaveSizePickerText: UITextField!
    @IBOutlet weak var conditionPickerText: UITextField!
    @IBOutlet weak var imageCondition: UIButton!
  
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var additionalText: UITextField!
    
    @IBOutlet weak var stackConditon: UIStackView!
    
    //------------ Для PickerView
    var hours = ["0","1", "2", "3","4", "5", "6","7", "8", "9","10",
                    "11", "12", "13","14", "15", "16","17", "18", "19","20","21", "22", "23"]
    var minutes = ["0","1","2","3","4","5","6","7","8","9","10",
                    "11","12","13","14","15","16","17","18","19","20",
                    "21","22","23","24","25","26","27","28","29","30",
                    "31","32","33","34","35","36","37","38","39","40",
                    "41","42","43","44","45","46","47","48","49","50",
                    "51","52","53","54","55","56","57","58","59"]
    
    var weave = ["Under 0.5feet  -  KNEE","0.5feet-1feet  -  HIP","1feet-1.5feet  -  BREAST","1.5feet-2feet  -  HEAD","Over 2feet  -  OVER HEAD "]
    var condition = ["NO GOOD","NOT GOOD ENOUGH","GOOD","GREAT","EXCELLENT"]
    var time = "" // Объявляет Время тренеровки
    var time1 = "" // Записывает часы и прибавляет минуты
    var time2 = "" // Записывает минуты и прибавляет час
    var time3 = "" // Записывает часы и прибавляет минуты
    var time4 = "" // Записывает минуты и прибавляет час
    var pickerDate1 = UIPickerView()
    var pickerDate2 = UIPickerView()
    var pickerWeave = UIPickerView()
    var pickerCondition = UIPickerView()
  
    
    //--------------------------------------------------------------------
    
    //------------ Для Заголовка
    var day = 0
    var mouth = 0
    var year = 0
    //------------------------------------
    
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.contentSize.height = 1200
    
    
    //------------Объявляет тап по экрану и вызов функции скрывания клавиатуры
    let tapScreen  = UITapGestureRecognizer(target: self, action: #selector(ContentDayViewController.dismisKeyboard(_:)))
    tapScreen.cancelsTouchesInView = false
    view.addGestureRecognizer(tapScreen)
    
    
  
    //------------Объявляет PickerView
    pickerDate1.delegate = self
    pickerDate1.dataSource = self
    pickerDate2.delegate = self
    pickerDate2.dataSource = self
    pickerWeave.delegate = self
    pickerWeave.dataSource = self
    pickerCondition.delegate = self
    pickerCondition.dataSource = self
    // Задаем фон
    pickerDate1.backgroundColor = scrollView.backgroundColor
    pickerDate2.backgroundColor = scrollView.backgroundColor
    pickerWeave.backgroundColor = scrollView.backgroundColor
    pickerCondition.backgroundColor = scrollView.backgroundColor
    // selectRow - выбираем на каком элементе будет отображаться
    pickerDate1.selectRow(12, inComponent: 0, animated: true)
    pickerDate1.selectRow(30, inComponent: 1, animated: true)
    pickerDate2.selectRow(12, inComponent: 0, animated: true)
    pickerDate2.selectRow(30, inComponent: 1, animated: true)
    
    // Присваеваем textField пикеры
    startTimeTrainingPicker.inputView = pickerDate1
    endTimeTrainingPicker.inputView = pickerDate2
    weaveSizePickerText.inputView = pickerWeave
    conditionPickerText.inputView = pickerCondition
    
    
    //------------------------------------------------
    
    //------------Прописываем запку
    dateLabel.text = String(day)
    yearLabel.text = String(year)
    if(mouth==1){mouthLabel.text = "January"}
    if(mouth==2){mouthLabel.text = "February"}
    if(mouth==3){mouthLabel.text = "March"}
    if(mouth==4){mouthLabel.text  = "April"}
    if(mouth==5){mouthLabel.text = "May"}
    if(mouth==6){mouthLabel.text = "June"}
    if(mouth==7){mouthLabel.text  = "July"}
    if(mouth==8){mouthLabel.text  = "August"}
    if(mouth==9){mouthLabel.text  = "September"}
    if(mouth==10){mouthLabel.text  = "October"}
    if(mouth==11){mouthLabel.text = "November"}
    if(mouth==12){mouthLabel.text = "December"}
    //------------------------------------------------
   
    
     //------------ ОБЪЯВЛЯЕМ ТЕКСТОВЫЕ ПОЛЯ ДЛЯ СОЗДАНИЯ СОБЫТИЯ ЗАКРЫТИЯ КЛАВИАТУРЫ
    locationSurf.delegate = self
    commentText.delegate = self
    additionalText.delegate = self
     //------------------------------------------------
}
    
    
    
    
    

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
    
    
    //-------------------------Блок сохранения события -------------
    @IBAction func saveTraining(_ sender: AnyObject) {
        let training = true
        let startraining = startTimeTrainingPicker.text
        let endtraining = endTimeTrainingPicker.text
        let rate = conditionPickerText.text
        let weave = weaveSizePickerText.text
        let comment = commentText.text
        let additional = additionalText.text
        let location = locationSurf.text
        let delete = false
        
        
        // Проверка на валидность введенных строк
        if startraining == "" || endtraining == "" || rate == "" || weave == "" {
            // Создаем Алерт говорящий что не все поля заполнены
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        else
        {
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            saveTraining = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: managedObjectContext) as! Entity
            
            saveTraining.year = year as NSNumber?
            saveTraining.mouth = mouth as NSNumber?
            saveTraining.day = day as NSNumber?
            saveTraining.training = training as NSNumber?
            saveTraining.starttraining = startraining!
            saveTraining.endtraining = endtraining!
            saveTraining.rate = rate!
            saveTraining.weave = weave!
            saveTraining.comment = comment
            saveTraining.additional = additional
            saveTraining.location = location
            saveTraining.delete = delete as NSNumber?
            
            if let trainingImage = photo.image {
                saveTraining.photo = UIImageJPEGRepresentation(trainingImage,1)
            }
            
            do { try managedObjectContext.save() } catch { return }
            
           
         
            
             do { try managedObjectContext.save() } catch { return }
            
            
            self.navigationController!.popToRootViewController(animated: true) // Програмный Возврат в корневой контроллер 
        }
        }
        //unwindToDetail - идентификатор кнопки close для програмного возврата в окнои вызова функции close
        performSegue(withIdentifier: "saveTraining", sender: sender) //
       
    }
    
    
    //--------------------------------------------------------------
    
    
    // ------------------------ Блок открытия и сохранения фотографии ------------------------
    
    @IBAction func getPhotoButton(_ sender: AnyObject) {
        // Создание всплывающего снизу окошка
        let optionMenu = UIAlertController(title: nil, message: "Photo: ", preferredStyle: .actionSheet)
        let cencelAction = UIAlertAction(title: "Calcel", style: .cancel, handler: nil)
        // Создаем кнопку Выбрать фото из галереи
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: {
        (action: UIAlertAction!)->Void in
           
            // Проверяет есть ли у приложения доступ к фотографиям
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        })
        // Открыть Фотокамеру
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (action: UIAlertAction!)->Void in
            
            var imagePicker: UIImagePickerController!
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
            
            })
        
        // Подключение кнопки Закрытия всплывающего снизу окна
        optionMenu.addAction(cencelAction)
        optionMenu.addAction(photoLibrary)
        optionMenu.addAction(takePhoto)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        photo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photo.contentMode = UIViewContentMode.scaleAspectFill
        photo.clipsToBounds = true

        
        dismiss(animated: true, completion: nil)
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    // ------------ Блок Picker View -------------
    //tintColor = UIColor(red: 76.0/255.0, green: 118.0/255.0, blue: 181.0/255.0, alpha: 1.0)
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "Error", attributes: [NSForegroundColorAttributeName : pickerViewTextColor])
        
    
            
        
        if(pickerView == pickerDate1 || pickerView == pickerDate2 ){
            
            if(component == 0){
                let attributedString = NSAttributedString(string: hours[row], attributes: [NSForegroundColorAttributeName : pickerViewTextColor ])
            return attributedString
            }
            if(component == 1){
                let attributedString = NSAttributedString(string: minutes[row], attributes: [NSForegroundColorAttributeName : pickerViewTextColor])
            return attributedString
            }
            
            
        }
        if(pickerView == pickerWeave ){
            let attributedString = NSAttributedString(string: weave[row], attributes: [NSForegroundColorAttributeName : pickerViewTextColor])
        
            return attributedString
            
        }
        if(pickerView == pickerCondition ){
            let attributedString = NSAttributedString(string: condition[row], attributes: [NSForegroundColorAttributeName : pickerViewTextColor])
            
            return attributedString
            
        }
        
        return attributedString
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView==pickerDate1 || pickerView==pickerDate2)
        {
            return 2
        }
        if(pickerView==pickerWeave || pickerView==pickerCondition){
            return 1
        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView==pickerDate1 || pickerView==pickerDate2){
            if (component==0){ return hours.count  }
            else
                if(component==1){ return minutes.count }
        }
        if(pickerView==pickerWeave){ return weave.count }
        if(pickerView==pickerCondition){ return condition.count }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView==pickerDate1 || pickerView==pickerDate2)
        {
            if (component==0){
                return hours[row]
            }
            else if(component==1){
                return minutes[row]
            }
        }
        if(pickerView==pickerWeave){
            return weave[row]
        }
        if(pickerView==pickerCondition){
            return condition[row]
        }
        return ""
    }
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Два таймера
        if(pickerView==pickerDate1 || pickerView==pickerDate2 ){
            if(pickerView==pickerDate1){
                    if (component==0){ time1 = hours[row]   }
                    if (component==1){ time2 = minutes[row] }
            }
            
            if(pickerView==pickerDate2){
                
               
                    if (component==0){ time3 = hours[row]   }
                    if (component==1){ time4 = minutes[row] }
            }
            
            if(pickerView==pickerDate1) {
                startTimeTrainingPicker.text = time1 + " : " + time2
                
                if(time1 != ""){pickerDate2.selectRow(Int(time1)!, inComponent: 0, animated: true)} // Переопределяет с какого элемента начнется Время конца тренировки
                if(time2 != ""){pickerDate2.selectRow(Int(time2)!, inComponent: 1, animated: true)}
            }
            if(pickerView==pickerDate2) {
                endTimeTrainingPicker.text = time3 + " : " + time4
                
            }
            
                    
        }
        // Два пикера Волны и Кондиция
        if(pickerView==pickerWeave){ weaveSizePickerText.text = weave[row] }
        if(pickerView==pickerCondition){
            conditionPickerText.text = condition[row]
            
            if(row==0) { imageCondition.setImage(UIImage(named: "close"), for: UIControlState()) }
            if(row==1) { imageCondition.setImage( UIImage(named: "dislike"), for: UIControlState()) }
            if(row==2) { imageCondition.setImage(UIImage(named: "rating"), for: UIControlState()) }
            if(row==3) { imageCondition.setImage(UIImage(named: "good"), for: UIControlState())  }
            if(row==4) { imageCondition.setImage(UIImage(named: "great"), for: UIControlState())  }
    
            }
        
    
    
    //------------------------------------------------------------------------
    
   
    }
        //------------Объявляет функцию скрытия клавиатуры
        func dismisKeyboard(_ sender: UITapGestureRecognizer){
            view.endEditing(true)
        }
        
        //------------Нажатие кнопки Return на клавиатуре
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
