//
//  FilterViewController.swift
//  desafioMesa
//
//  Created by Raissa Morais on 10/02/19.
//  Copyright © 2019 Raissa X Morais. All rights reserved.
//

import UIKit

protocol filterDelegate {
    func didSelectFilter(filter: [PlaceType])
}

class FilterViewController: UIViewController{

    var filterDelegate: filterDelegate!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellId = "FilterCell"
    
    private var selectedFilter: [PlaceType : Bool] = FilterOptions.selectedTypes
    
    private var filterTypes: [PlaceType] = FilterOptions.optionTypes
    
    private var selectedCells = [IndexPath: PlaceType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, type) in filterTypes.enumerated() {
            if selectedFilter[type] == true {
                let indexPath = IndexPath(row: index, section: 1)
                selectedCells[indexPath] = type
            }
        }
        
    }

  
    @IBAction func applyFilter(_ sender: UIButton) {
        
        if selectedCells.count == 0 {
            let filter: [PlaceType : Bool] = [.airport : false, .market : false, .party : false, .restaurant : false, .shopping : false]
            FilterOptions.saveFilter(selectedTypes: filter)
        } else {
            FilterOptions.saveFilter(selectedTypes: selectedFilter)
        }
        
        filterDelegate.didSelectFilter(filter: FilterOptions.selectedFilter())
        dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource   {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return selectedFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        
        let noneSelected = selectedCells.count == 0
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Todos"

            if noneSelected {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.textLabel?.text = nameForFilter(type: filterTypes[indexPath.row])
            
            if noneSelected {
                cell.accessoryType = .none
            } else {
                let selected = selectedCells[indexPath]
                if let _ = selected {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let existSelected = selectedCells.count != 0
            
            if existSelected {
                deselectAllFilter()
            }
            
        } else {
            if let type = selectedCells[indexPath] {
                
                selectedFilter[type] = false
                selectedCells.removeValue(forKey: indexPath)
            } else {
                let type = filterTypes[indexPath.row]
                selectedCells[indexPath] = type
                selectedFilter[type] = true
            }
        }
        
        tableView.reloadData()
    }

    func deselectAllFilter() {
        selectedCells = [:]
        for type in filterTypes {
//            let type = PlaceType(rawValue: filter)!
            selectedFilter[type] = false
        }
    }
    
    
    private func nameForFilter(type: PlaceType) -> String {
        switch type {
        case .airport:
            return "Aeroportos"
        case .restaurant:
            return "Restaurantes"
        case .party:
            return "Baladas"
        case .market:
            return "Supermercados"
        case .shopping:
            return "Shopping Centers"
        case .other:
            return "Other"
        }
    }

    
}
