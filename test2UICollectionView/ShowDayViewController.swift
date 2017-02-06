//
//  ShowDayViewController.swift
//  test2UICollectionView
//
//  Created by Владимир on 24.01.16.
//  Copyright © 2016 Gorelovskiy. All rights reserved.
//

import UIKit
import CoreData

class ShowDayViewController: UIViewController,UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate{
    
  
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var deleteTraining = false // Нужно для удаления тренировки
    
    var calendarFromCoreDataMass: [Entity] = []
    var fetchResultController: NSFetchedResultsController<AnyObject>!
    var countMass = 0
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var mouthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var StartTimeLabel: UILabel!
    @IBOutlet weak var EndTimeLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var weaveSizeLabel: UILabel!
 
    
    @IBOutlet weak var imageRating: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageLocation: UIImageView!
    @IBOutlet weak var additionalLabe: UILabel!
    
    
    
    var day = 0
    var mouth = 0
    var year = 0
    var startTime = ""
    var endTime = ""
    var location = ""
    var weaveSize = ""
    var rating = ""
    var comment = ""
    var additional = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 900

        
        dayLabel.text = String(day)
        
        if(mouth==1){mouthLabel.text = "January"}
        if(mouth==2){mouthLabel.text = "February"}
        if(mouth==3){mouthLabel.text = "March"}
        if(mouth==4){mouthLabel.text = "April"}
        if(mouth==5){mouthLabel.text = "May"}
        if(mouth==6){mouthLabel.text = "June"}
        if(mouth==7){mouthLabel.text = "July"}
        if(mouth==8){mouthLabel.text = "August"}
        if(mouth==9){mouthLabel.text = "September"}
        if(mouth==10){mouthLabel.text = "October"}
        if(mouth==11){mouthLabel.text = "November"}
        if(mouth==12){mouthLabel.text = "December"}
        yearLabel.text = String(year)
        
        SearchInformationAboutTraining()
        
    }
    
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    
    
    //--------------------- Функция для поиска информации о тренеровках ------------------------------------------------------------------------------------
    func SearchInformationAboutTraining() {
        
        // Создаем запрос
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        
        // sortDescriptor - объект который будет сортировать объекты этой сущности по определенным ключам( в нашем случае сортировка по name )
        let sortDescriptorYear = NSSortDescriptor(key: "year", ascending: true)
        let sortDescriptorMouth = NSSortDescriptor(key: "mouth", ascending: true)
        let sortDescriptorDay = NSSortDescriptor(key: "day", ascending: true)
        
        // Добавляем нашу сортировку в Запрос( можно создавать несколько сортировок)
        fetchRequest.sortDescriptors = [sortDescriptorYear,sortDescriptorMouth,sortDescriptorDay]
        
        //--------------------------
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            // Связываем наш контроллер с результатом
            fetchResultController.delegate = self
            
            do { try fetchResultController.performFetch()  }
            catch { print(error) }
            
            calendarFromCoreDataMass = fetchResultController.fetchedObjects as! [Entity]
            
            var blockError = false
            
            
            countMass = 0
            let maxCount = calendarFromCoreDataMass.count // Получаем число элементов массива
            
            // Защита от того если CoreData пустой
            if(maxCount != 0 ){
                
                // Определяем какой сейчас год и находим с какого элемента в CoreData начинается год
                while(year != Int(calendarFromCoreDataMass[countMass].year!) && blockError==false){
                    
                    countMass += 1
                    if(countMass>maxCount){ blockError = true; countMass -= 1}
        
                }
           
                
                // Определяем какой сейчас месяц и находим с какого элемента в CoreData начинается месяц
                while(mouth != Int(calendarFromCoreDataMass[countMass].mouth!) && blockError==false){
                    countMass += 1
                    if(countMass>maxCount-1){ blockError = true; countMass -= 1 }
                }
                                // Определяем день
              
                
                while(day != Int(calendarFromCoreDataMass[countMass].day!)  && blockError==false){
                    countMass += 1
                    if(countMass>maxCount-1){ blockError = true; countMass -= 1 }
                }
                
                while(day == Int(calendarFromCoreDataMass[countMass].day!) && calendarFromCoreDataMass[countMass].delete == true){
                    countMass += 1
                
                }
              
                
                if(deleteTraining == false){
                
                StartTimeLabel.text = calendarFromCoreDataMass[countMass].starttraining
                EndTimeLabel.text = calendarFromCoreDataMass[countMass].endtraining
                weaveSizeLabel.text = calendarFromCoreDataMass[countMass].weave
                conditionLabel.text = calendarFromCoreDataMass[countMass].rate
                commentLabel.text = calendarFromCoreDataMass[countMass].comment
                additionalLabe.text = calendarFromCoreDataMass[countMass].additional
                LocationLabel.text = calendarFromCoreDataMass[countMass].location
                   
               
                imageLocation.image = UIImage(data: calendarFromCoreDataMass[countMass].photo!)

                    
                if(conditionLabel.text == "NO GOOD"){ imageRating.setImage(UIImage(named:  "close"), for: UIControlState.normal) }
                if(conditionLabel.text == "NOT GOOD ENOUGH"){ imageRating.setImage(UIImage(named: "dislike"), for: UIControlState.normal) }
                if(conditionLabel.text == "GOOD"){ imageRating.setImage(UIImage(named: "rating"), for: UIControlState.normal) }
                if(conditionLabel.text == "GREAT"){ imageRating.setImage(UIImage(named:  "good"), for: UIControlState.normal) }
                if(conditionLabel.text == "EXCELLENT"){ imageRating.setImage(UIImage(named:  "great"), for: UIControlState.normal) }
                }
                else{
                    
                    calendarFromCoreDataMass[countMass].delete = true
                    do { try managedObjectContext.save() } catch { return }
                    
                }
                
                
                
            }
            
        }
        
        return
    }
    //----------------------------------------------------------------------------------------------------------------
    
    @IBAction func deleteTraining(sender: AnyObject){
        
        deleteTraining = true
        SearchInformationAboutTraining()
        var indexDel = 0
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            
           
            while(indexDel < calendarFromCoreDataMass.count){
                let indexPath: NSIndexPath = NSIndexPath(forRow: indexDel, inSection: 0)
                if(calendarFromCoreDataMass[indexDel].delete == true){
                let trainingToDelete = fetchResultController.objectAtIndexPath(indexPath) as! Entity
                    managedObjectContext.deleteObject(trainingToDelete)
                  }
                indexDel += 1
            }
            
            do { try managedObjectContext.save() } catch { return }

        }
        
            
        

       performSegue(withIdentifier: "deleteTraining", sender: sender) //
    
        }

}
