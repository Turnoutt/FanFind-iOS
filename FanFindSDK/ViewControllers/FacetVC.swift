//
//  FacetVC.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 12/28/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class FacetVC: UIViewController {
    
    @IBOutlet var facetsTable: UITableView!
    
    var facets: [FacetResponse] = []
    var selectedFacets: [String: [String]] = [:]
    
    var delegate: FacetManager?
    
    var bundle = Bundle(for: FacetVC.self)
    
    public init(
        facets: [FacetResponse],
        selectedFacets: [String: [String]]
    ){
        self.facets = facets
        self.selectedFacets = selectedFacets
        
        super.init(nibName: "FacetVC", bundle: Bundle(for: FacetVC.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "FacetVC", bundle: Bundle(for: FacetVC.self))
    }
    
    override func viewDidLoad() {
        self.facetsTable.dataSource = self
        self.facetsTable.delegate = self
        self.facetsTable.frame = self.view.bounds
        
        self.title = "Filter"
        
        let facetCell = UINib(nibName: "FacetTableViewCell", bundle: self.bundle)
        
        self.facetsTable.register(facetCell, forCellReuseIdentifier: "facetCell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Close",style: .plain, target: self, action: #selector(closeModal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(applyFacets(_:)))
        
        self.facetsTable.translatesAutoresizingMaskIntoConstraints = false
        self.facetsTable.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        self.facetsTable.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        self.facetsTable.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        self.facetsTable.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true

        self.facetsTable.reloadData()
    }
    
    @objc func closeModal(_ sender : UIBarButtonItem!){        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func applyFacets(_ sender : UIBarButtonItem!){
        self.delegate?.selectFacets(facets: self.selectedFacets)
        self.dismiss(animated: true, completion: nil)
    }
}

extension FacetVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = facets[section]
        return key.values.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = facets[section]
        return key.displayName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return facets.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            
        }
    }
}

extension FacetVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "facetCell", for: indexPath) as! FacetTableViewCell
        cell.delegate = self
        
        let facet = facets[indexPath.section]
        
        cell.setFacetData(facets: facets, selectedFacets: selectedFacets)
        cell.setValues(facetName: facet.fieldName, facetValue: facet.values[indexPath.row].value, count: facet.values[indexPath.row].count ?? 0)
        
        return cell
    }
}

extension FacetVC: FacetChangeHandler {
    func updateSelectedFacets(selectedFacets: [String: [String]]){
        self.selectedFacets = selectedFacets
    }
}

protocol FacetChangeHandler {
    func updateSelectedFacets(selectedFacets: [String: [String]])
}

