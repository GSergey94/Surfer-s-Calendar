//
//  ViewController.swift
//  test2UICollectionView
//
//  Created by Владимир on 17.01.16.
//  Copyright © 2016 Gorelovskiy. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate{
   
    
    

    var sizeCell: CGFloat = 0.0
    
    //-----------Стартовая дата от которой ведется отсчет
    let startYear = 2000
    let startMouth = 1
    let startWeekDay = 6
    let massDayYear = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    //-----------------------------------------------------

    var countTrainingInCoreData = 0
    
    var calendarFromCoreDataMass: [Entity] = []
    // Создаем объект - результат запроса
    var fetchResultController: NSFetchedResultsController<AnyObject>!
    var countMass = 0 // Массив для перебора элементов CoreData
    var ArrayMouth = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
    var ArrayMouthRating = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
    var thisYear = 0
    var thisMouth = 0
    var todayMouth = 0 // Хранит текущий меняц и не меняет его
    var thisDay = 0

    var indexP = 0
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // меняем фон CollectionView
        //collectionView.backgroundView = View(UIImage(named: "close"))
        //----------Блок получения текущего месяца и года
        let now = Date()
        let flags = NSCalendar.Unit(rawValue: UInt.max)
        let components = (Foundation.Calendar.current as NSCalendar).components(flags,from: now)
        thisYear = components.year!
        thisMouth = components.month!
        todayMouth = components.month!
        thisDay = components.day!
        //----------------------------------------
        
        
        
        colculateMouth()
        loadCoreData()  // Загружаем информацию из CoreData
        SearchInformationAboutTraining()
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArrayMouth.count
    }
    
    //-----------Редактируем размеры и зазоры между ячейками в зависимости от экрана
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            sizeCell = self.view.frame.size.width / 8.0
        
            return CGSize(width: sizeCell, height: sizeCell)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let leftRightInset =  self.view.frame.size.width / 100.0
        
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    //---------------------------------------------
    
    
   
    //----------------------------------------------------------------------------------------------------
    // --------------------Функция Для наполнения Содержимым ячеек
    //----------------------------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        
         indexP = (indexPath as NSIndexPath).row
        
        // Создаем элемент внутри ячейки - Label и приравнивает ему значение индекса из массива равного Дате
        let DayButton = cell.dayButton
        
        DayButton?.tag = indexP
        DayButton?.setTitle(ArrayMouth[indexP], for: UIControlState())
       
        
        // Создаем объект кнопка
        let conditionButton = cell.conditionButton
        conditionButton?.tag = indexP // Строчка нужная что бы при нажатии на кнопку передавался индек
       
        if(ArrayMouth[indexP] == ""){ cell.isHidden = true  }
        if(ArrayMouth[indexP] != ""){ cell.isHidden = false  }
        
        
        if(ArrayMouthRating[indexP] == ""){ conditionButton?.isHidden = true
                                            DayButton?.isHidden = false      }  // Если у кнопка нету рейтинка тогда невидимая
        if(ArrayMouthRating[indexP] != ""){  conditionButton?.isHidden = false
                                            DayButton?.isHidden = true} // Если рейтинг этого дня не равен 0  то Кнопка появляется

        
        if(ArrayMouthRating[indexP] == "NO GOOD"){ conditionButton?.setImage(UIImage(named: "close"), for: UIControlState()) }
        if(ArrayMouthRating[indexP] == "NOT GOOD ENOUGH"){ conditionButton?.setImage(UIImage(named:"dislike"), for: UIControlState()) }
        if(ArrayMouthRating[indexP] == "GOOD"){ conditionButton?.setImage(UIImage(named: "rating"), for: UIControlState()) }
        if(ArrayMouthRating[indexP] == "GREAT"){ conditionButton?.setImage(UIImage(named: "good"), for: UIControlState()) }
        if(ArrayMouthRating[indexP] == "EXCELLENT"){ conditionButton?.setImage(UIImage(named: "great"), for: UIControlState())}
        
            
        //-----Cоздаем закругления
        cell.layer.cornerRadius = sizeCell/2
                
        return cell
    }


    override func collectionView(_ collectionView: UICollectionView,canMoveItemAt indexPath: IndexPath) -> Bool {
        
            return true
    }
    
    
    //--------------------------------------------------------------------------------
    //--------------------- Функция для поиска информации о тренеровках 
    //--------------------------------------------------------------------------------
    func SearchInformationAboutTraining() {
      
        ArrayMouthRating = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
        
            var blockError = false
            var countInMouth = 0
            var countInMouthChange = 0
            
            var useMouth: NSNumber // Используемый месяц(нужно для того что бы следить когда закончиться месяц - для перебора дней в месяце
            
             countMass = 0
            let maxCount = calendarFromCoreDataMass.count // Получаем число элементов массива
      
            // Защита от того если CoreData пустой
          if(maxCount != 0 ){
            
            
                
                // Определяем какой сейчас год и находим с какого элемента в CoreData начинается год
                while(thisYear != calendarFromCoreDataMass[countMass].year! && blockError==false){
                countMass += 1
                    if(countMass>maxCount-1 ){ blockError = true ; countMass -= 1}
                }
   
            
                // Определяем какой сейчас месяц и находим с какого элемента в CoreData начинается месяц
                while(thisMouth != calendarFromCoreDataMass[countMass].mouth! && blockError==false){
                    countMass += 1
                    if(countMass>maxCount-1){
                        blockError = true
                        countMass -= 1 // Нужно для того что бы не выходило за пределы существующей CoreData
                    }
                }
            
                useMouth = calendarFromCoreDataMass[countMass].mouth! // Используемый месяц
                while(ArrayMouth[countInMouth] != "1"){countInMouth += 1 ; countInMouthChange += 1} // Определяем с какого элемента массива надо начинать укомплектовывать фотографии
            
            
            
                while(calendarFromCoreDataMass[countMass].mouth! == useMouth && blockError == false){
                
                
                    
                    if( calendarFromCoreDataMass[countMass].delete != true){
                  
                        
                if(calendarFromCoreDataMass[countMass].rate == "NO GOOD"){
                    countInMouth=countInMouthChange + Int(calendarFromCoreDataMass[countMass].day!) - 1
                    ArrayMouthRating[countInMouth]="NO GOOD"
                    }
                if(calendarFromCoreDataMass[countMass].rate == "NOT GOOD ENOUGH"){
                    countInMouth=countInMouthChange + Int(calendarFromCoreDataMass[countMass].day!) - 1
                    ArrayMouthRating[countInMouth]="NOT GOOD ENOUGH"
                    }
                if(calendarFromCoreDataMass[countMass].rate == "GOOD"){
                    countInMouth=countInMouthChange + Int(calendarFromCoreDataMass[countMass].day!) - 1
                    ArrayMouthRating[countInMouth]="GOOD"
                    }
                if(calendarFromCoreDataMass[countMass].rate == "GREAT"){
                    countInMouth=countInMouthChange + Int(calendarFromCoreDataMass[countMass].day!) - 1
                    ArrayMouthRating[countInMouth]="GREAT"
                    }
                if(calendarFromCoreDataMass[countMass].rate == "EXCELLENT"){
                    countInMouth=countInMouthChange + Int(calendarFromCoreDataMass[countMass].day!) - 1
                    ArrayMouthRating[countInMouth]="EXCELLENT"
                    }
                    }
                    countMass += 1
                    if(countMass>=maxCount){ blockError = true ; countMass -= 1 }
                
                    
            }
            
            
            
            }
         
        
        

    return
    }


    
    
    
    
    
    
    
    //--------------------------------------------------------------------------------
    // -------------------------- Функция для отображения заголовка 
    //--------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReusableCell", for: indexPath) as! CollectionReusableView
               
                
                
                headerView.yearLabel.text = String(thisYear)
                //headerView.b = UIColor(red: 111.0/255.0, green: 108.0/255.0, blue: 108.0/255.0, alpha: 1.0)

                if(thisMouth==1){headerView.mouthLabel.text = "January"}
                if(thisMouth==2){headerView.mouthLabel.text = "February"}
                if(thisMouth==3){headerView.mouthLabel.text = "March"}
                if(thisMouth==4){headerView.mouthLabel.text = "April"}
                if(thisMouth==5){headerView.mouthLabel.text = "May"}
                if(thisMouth==6){headerView.mouthLabel.text = "June"}
                if(thisMouth==7){headerView.mouthLabel.text = "July"}
                if(thisMouth==8){headerView.mouthLabel.text = "August"}
                if(thisMouth==9){headerView.mouthLabel.text = "September"}
                if(thisMouth==10){headerView.mouthLabel.text = "October"}
                if(thisMouth==11){headerView.mouthLabel.text = "November"}
                if(thisMouth==12){headerView.mouthLabel.text = "December"}
                
                return headerView
            default:
                //4
                fatalError( "Unexpected element kind")
            }
    }
    
    
    

    
    
    //--------------------------------------------------------------------------------
    //-------------- Отправка информания в контроллер
    //--------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "createEvent" {
            
            let destinationController = segue.destination as! ContentDayViewController
            indexP = (sender! as AnyObject).tag
    
            destinationController.day = Int(ArrayMouth[indexP])!
            destinationController.year = thisYear
            destinationController.mouth = thisMouth
          
        }
        if segue.identifier  == "showEvent" {
            
            let destinationController = segue.destination as! ShowDayViewController
            
            indexP = (sender! as AnyObject).tag
            
            destinationController.day = Int(ArrayMouth[indexP])!
            destinationController.year = thisYear
            destinationController.mouth = thisMouth
        }
    }
    
    // При нажатии На ячейку записывает номер нажатой ячейки
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexP = Int(ArrayMouth[(indexPath as NSIndexPath).row])!
        countTrainingInCoreData = Int((indexPath as NSIndexPath).row)
     
        
        
    }
    
    //--------------------------------------------------------------------------------
    //--------------------Показать предыдущий месяц
    //--------------------------------------------------------------------------------
    @IBAction func previousMouth(_ segue: UIStoryboardSegue) {
        if thisMouth == 1 {
            thisYear -= 1
            thisMouth = 12 
        }
        else { thisMouth -= 1 }
     
        colculateMouth()
        SearchInformationAboutTraining()
        collectionView?.reloadData()
        
    }
    
    
    //__________Показать следующий месяц
    @IBAction func nextMouth(_ sender: AnyObject) {

        if thisMouth == 12 {
            thisYear += 1
            thisMouth = 1
        }
        else { thisMouth += 1 }
        colculateMouth()
        SearchInformationAboutTraining()
        collectionView?.reloadData()
        
    }
    
   
    
    //--------------------------------------------------------------------------------
    //------------------- Функция для пересчета отображаемого месяца
    //--------------------------------------------------------------------------------
    func colculateMouth() {
        
        ArrayMouth = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
        // Начнем отсчет ячеек с 10
        var weekDay = 0
        var Count = 0
        var numberOfDay = 0
        
        if(thisYear > 2004){numberOfDay = (thisYear-startYear)*365+(thisYear-startYear)/4}
        else{numberOfDay = (thisYear-startYear)*365+(thisYear-startYear)/4 + 1 }
        
        while(Count < thisMouth - 1 ){
            if(Count == 1 ){
                if(thisYear%4 != 0 ){ numberOfDay = numberOfDay + massDayYear[Count]  } // Если Год не весокосный
                else{ numberOfDay = numberOfDay + massDayYear[Count] + 1 } } // Если весокосный
            else { numberOfDay = numberOfDay + massDayYear[Count] }
            Count += 1
        }
        
        numberOfDay %= 7 // Вычисляем остаток дней когда вычтим все целые недели
        
        
        // Если год не весокосный
        if(thisYear%4 != 0 ){
            if(numberOfDay==0){weekDay = startWeekDay + 1 } // Если остаток от деления = 0 значит мы вернулись в тот же день недели
            else{weekDay = startWeekDay + numberOfDay + 1
                if(weekDay>7){ weekDay = weekDay - 7 }
                
            }}
            // Если год Весокосный
        else{
            if(numberOfDay==0){weekDay = startWeekDay } // Если остаток от деления = 0 значит мы вернулись в тот же день недели
            else{ weekDay = startWeekDay + numberOfDay
                if(weekDay>7){ weekDay = weekDay - 7 }
            }}
        
        var countDay = weekDay
        var a = 1
        if(thisYear%4 != 0 ){ while(a<=massDayYear[thisMouth-1]){ ArrayMouth[countDay-1]=String(a); a += 1;countDay += 1 }}//Если год не весокосный
        else{
            if(thisMouth == 2){while(a<=massDayYear[thisMouth-1] + 1){ ArrayMouth[countDay-1]=String(a); a += 1;countDay += 1 }}
            else{while(a<=massDayYear[thisMouth-1]){ ArrayMouth[countDay-1]=String(a); a += 1;countDay += 1 }}
        }
       
        return
    }
    
    //--------------------------------------------------------------------------------
    //-----------------------ФУНКЦИЯ КОТОРАЯ ВЫЗЫВАЕТСЯ ПРИ ВОЗВРАТЕ ИЗ КОНТРОЛЛЕРА
    //--------------------------------------------------------------------------------
     @IBAction  func close(_ segue: UIStoryboardSegue) {
        if segue.identifier == "saveTraining"{
        
        loadCoreData()
           
        SearchInformationAboutTraining()
        
        collectionView?.reloadData()
        }
        if segue.identifier == "deleteTraining"{
            loadCoreData()
            SearchInformationAboutTraining()
        
            collectionView?.reloadData()
        }
    }
    
    
    //--------------------------------------------------------------------------------
    //-----------------------ФУНКЦИЯ ОБНОВЛЕНИЯ(считывания) БАЗЫ ДАННЫХ
    //--------------------------------------------------------------------------------
    func loadCoreData(){
        
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
            
            
            
        }
        
        return
    }

  
    
}

