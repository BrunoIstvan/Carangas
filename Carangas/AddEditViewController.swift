//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var car: Car!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // se carro existir
        if car != nil {
            // preencher campos da tela
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            title = "Edição"
            btAddEdit.setTitle("Alterar Carro", for: .normal)
        }
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        
        sender.isEnabled = false
        sender.alpha = 0.5
        sender.backgroundColor = .gray
        // se carro não existe... criar uma nova instancia
        if car == nil {
            car = Car()
        }
        // preenche os campos do objeto
        car.brand = tfBrand.text!
        car.name = tfName.text!
        car.price = Double(tfPrice.text!) ?? 0.0
        car.gasType = scGasType.selectedSegmentIndex
        // inicializa a animação...
        loading.startAnimating()
        // prepara a operação a ser executada ...
        let operation: RESTOperation = car._id == nil ? .save : .update
        // faz a requisição ...
        REST.request(car: car, operation: operation) { (success) in
            
            DispatchQueue.main.async {
                // se ocorreu com sucesso ...
                if success {
                    // volta para a tela anterior
                    self.navigationController?.popViewController(animated: true)
                } else {
                    // senão reabilita o botão para nova tentativa
                    sender.isEnabled = true
                    sender.alpha = 1.0
                    sender.backgroundColor = UIColor(named: "main")
                    // para a animação ...
                    self.loading.stopAnimating()
                }
            }
            
        }
        
    }

}
