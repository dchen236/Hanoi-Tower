//
//  ViewController.swift
//  Hanoi Tower
//
//  Created by Danni on 12/24/18.
//  Copyright © 2018 Danni Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //    MARK: max number of disks can be 6
    //    MARK: All the connections between storyboard to viewController
//    The whole view to hold the game view
    @IBOutlet weak var WholeContainerView: UIView!
//   1 horizontal stackView to hold three towers
    @IBOutlet weak var horizontalStackView: UIStackView!
    
//  3 Views to hold each tower and each vertical diskHolder
    @IBOutlet weak var tower1HolderView: UIView!
    @IBOutlet weak var tower2HolderView: UIView!
    @IBOutlet weak var tower3HolderView: UIView!
//  3 towerViews (poles) staic (not much in use)
    @IBOutlet weak var tower1View: UIView!
    @IBOutlet weak var tower2View: UIView!
    @IBOutlet weak var tower3View: UIView!
    
//    vertical stackview to hold disks
    @IBOutlet weak var disksStackView1: UIStackView!
    @IBOutlet weak var disksStackView2: UIStackView!
    @IBOutlet weak var disksStackView3: UIStackView!
    
    var game = Game(with: 6)
    var diskColors = [UIColor.red,UIColor.orange,UIColor.yellow,
                      UIColor.green,UIColor.blue,UIColor.purple]
//  clear disk to create proper distruibution
    var numberOfDisksOnEach = 7
    

    private func updateView(){

//        update disks on tower1
    updateTower(disksHolder: disksStackView1, changingTower: game.tower1)
    updateTower(disksHolder: disksStackView2, changingTower: game.tower2)
    updateTower(disksHolder: disksStackView3, changingTower: game.tower3)
        
    }

    private func updateTower(disksHolder:UIStackView,changingTower:Tower){
        let disksOnTower = changingTower.disks
        let numberofDisks = disksOnTower.count
        
        for i in 0..<numberOfDisksOnEach-numberofDisks{
            disksHolder.setClearView(at: i)
        }
        
       
        for i in disksOnTower.indices{
            let disk = disksOnTower[i]
            let properIndex = numberOfDisksOnEach-numberofDisks+i
            let color = diskColors[disk.level-1]
            let view = createViewWithColor(color: color)
            disksHolder.changeSubviewWidth(at: properIndex, newView: view, newWidth: self.calculateDiskWidth(Disk: disk))
        
            
        }
    }
    
    private func moveNumberOfDisks(diskNumber:Int,from startingTower:Tower,to endingTower:Tower){
        
        if diskNumber == 0{
            return
        }
        else{
            if startingTower.getTopDisk() != nil{
                let otherTower = game.getTheOtherTower(withTower1: startingTower, withTower2: endingTower)
                moveNumberOfDisks(diskNumber: diskNumber-1, from: startingTower, to: otherTower)
                game.moveDisk(from: startingTower, to: endingTower)
                print("moveFrom \(startingTower.identifier) to \(endingTower.identifier)")
                updateView()
                moveNumberOfDisks(diskNumber: diskNumber-1, from: otherTower, to: endingTower)
            }
        }
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
        configureSolutionButton()
        
    }
    
    
    private func calculateDiskWidth(Disk:Disk)->CGFloat{
        let totalWidth = disksStackView1.frame.size.width
        return totalWidth / 6 * CGFloat((Double(Disk.level)+0.5))
    }
    

//  making three tower's corner round ship
    private func clipTowerBounds(){
        tower1View.cornerRadius = 5
        tower2View.cornerRadius = 5
        tower3View.cornerRadius = 5
    }
    
    
//  set up solution button and addtarget to solution button
    lazy private var solutionButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureSolutionButton(){
        solutionButton.setTitle("Solution", for: .normal)
        solutionButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        view.addSubview(solutionButton)
        solutionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        solutionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        solutionButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        solutionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        solutionButton.addTarget(self, action: #selector(showSolution), for: .touchUpInside)
    }
    
    @objc private func showSolution(){
        moveNumberOfDisks(diskNumber: 6, from: game.tower1, to: game.tower3)
        updateView()
        
    }
    
    
 // initialize 7 views for each diskStackView
    private func initializeGame(){
        clipTowerBounds()
//      initialize disks with different color on disksStackView1
        tower1HolderView.bringSubviewToFront(disksStackView1)
        let count = diskColors.count
        disksStackView1.addArrangedSubview(createViewWithColor(color: .clear))
        for i in 0..<count{
            let disk = Disk(level:i+1)
            let view = createViewWithColor(color: diskColors[i])
            view.cornerRadius = 15
            disksStackView1.addSubviewWithLength(add: view, with: calculateDiskWidth(Disk: disk))
        }
        print(disksStackView1)
        
//      initialize 7 UIView with clear background color on both disksStackView2 and 3
        tower2View.bringSubviewToFront(disksStackView2)
        tower3View.bringSubviewToFront(disksStackView3)
        for _ in 0...count{
            let view1 = createViewWithColor(color: .clear)
            let view2 = createViewWithColor(color: .clear)
//            view1.cornerRadius = 15
//            view2.cornerRadius = 15
            disksStackView2.addArrangedSubview(view1)
            disksStackView3.addArrangedSubview(view2)
        
        }
    }
    
    private func createViewWithColor(color:UIColor) -> UIView{
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = color
        return view
    }
    
    
    private func test(){
        print(game.tower1.count)
        print(game.tower2.count)
        print(game.tower2.count)
    }
    
    

    @IBAction func resetButtonPressed(_ sender: UIButton) {
        game = Game(with:6)
        updateView()

    }


}


extension UIView{
    var cornerRadius:CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
}



extension UIStackView{
    func addSubviewWithLength(add view:UIView, with width:CGFloat){
        //distribution = .fillEqually
        alignment = .center
        
        let viewHolder = UIView()
        viewHolder.translatesAutoresizingMaskIntoConstraints = false
        viewHolder.addSubview(view)
        view.centerXAnchor.constraint(equalTo: viewHolder.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: viewHolder.centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalTo: viewHolder.heightAnchor).isActive = true
        self.addArrangedSubview(viewHolder)
     
    }
    
    func setClearView(at index:Int){
        let view = arrangedSubviews[index]
        view.removeFromSuperview()
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = .clear
        self.insertArrangedSubview(newView, at: index)
       
    }
    
    
    func changeSubviewWidth(at index:Int, newView:UIView,newWidth:CGFloat){
        let view = arrangedSubviews[index]
        view.removeFromSuperview()
        let viewHolder = UIView()
        viewHolder.translatesAutoresizingMaskIntoConstraints = false
        newView.cornerRadius = 15
        viewHolder.addSubview(newView)
        newView.centerXAnchor.constraint(equalTo: viewHolder.centerXAnchor).isActive = true
        newView.centerYAnchor.constraint(equalTo: viewHolder.centerYAnchor).isActive = true
        newView.widthAnchor.constraint(equalToConstant: newWidth).isActive = true
        newView.heightAnchor.constraint(equalTo: viewHolder.heightAnchor).isActive = true
        self.insertArrangedSubview(viewHolder, at: index)
 
    }
    
}


