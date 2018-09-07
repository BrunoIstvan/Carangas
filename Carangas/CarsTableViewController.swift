//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {

    var cars: [Car] = []
    
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Sem carros cadastrados"
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // quando o refresh for disparado...
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        // GEITO PORKO
        //URLSession.shared.dataTask(with: URL(string: "https://carangas.herokuapp.com/cars")!) { (data, _ , _) in
        //   self.cars = try! JSONDecoder().decode([Car].self, from: data!)
        //    DispatchQueue.main.async { self.tableView.reloadData() }
        //}
    }
    
   @objc func handleRefresh() {
        // modo de executar passando um método como parâmetro...
        REST.loadCars(onComplete: showCars)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // modo de executar passando um método como parâmetro...
        REST.loadCars(onComplete: showCars)
        // modo de executar usando uma closure
        //REST.loadCars { (cars) in
        //    // TODO: FAÇA O QUE ESTÁ DENTRO DO MÉTODO showCars
        //}
    }
    
    // função disparada ao clicar na celula
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepara a view controller a ser exibida
        let vc = segue.destination as? CarViewController
        // preenche a variavel carro
        vc?.car = cars[tableView.indexPathForSelectedRow!.row]
    }
    
    
    // função que será passada para dentro do método loadCars do REST
    func showCars(cars: [Car]) -> Void {
        print("Minha API retorno \(cars.count) carros")
        self.cars = cars
        // força a atualização da tabela na thread main
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        tableView.backgroundView = cars.count == 0 ? label : nil
        return cars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        return cell
    }
    
    // Excluir ou Editar um registro
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // recuperar o carro que deseja excluir
            let car = cars[indexPath.row]
            // faz a requisição para excluir o carro
            REST.request(car: car, operation: .delete) { (success) in
                // se retorno for sucesso...
                if success {
                    // remove o elemento da lista de carros
                    self.cars.remove(at: indexPath.row)
                    // remove o elemento da tableview
                    DispatchQueue.main.async {
                        // Delete the row from the data source
                        tableView.deleteRows(at: [indexPath], with: .right)
                        
                    }
                }
                
            }
            
        }
    }
  
}
