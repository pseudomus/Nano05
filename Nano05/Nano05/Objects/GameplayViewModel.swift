//
//  ObjectModel.swift
//  Nano05
//
//  Created by André Felipe Chinen on 28/02/24.
//

import Foundation

class GameplayViewModel: ObservableObject {

//    var allObjects: [String] = ["Armario", "Bicicleta", "Bone", "Cadeira", "Calculadora", "Calçados", "Cama", "Camisa", "Caneca", "Caneta", "Chave de fenda", "Chuveiro", "Clipe de papel", "Cola Bastao", "Colher", "Espatula", "Flauta", "Frigideira", "Geladeira", "Impressora", "Livro:Caderno", "Lixeira", "Martelo", "Mesa", "Mochila", "Oculos", "Papel higienico", "Parafusadeira", "Pente", "Pilha", "Porta", "Regua", "Shorts:Calca", "Sofa", "TV", "Teclado", "Tesoura", "Toalha", "Vaso sanitario", "Ventilador"]
    
    var allObjects: [String] = ["Bone", "Calçados", "Caneca", "Caneta", "Chave de fenda", "Colher", "Espatula", "Livro:Caderno", "Mochila", "Oculos", "Papel higienico", "Pente", "Teclado", "Tesoura", "Toalha"]
    
    @Published var timeRemaining = 120 //MARK: - change for 180
    @Published var toFindObject: String = ""
    @Published var numberOfObjects: Int = 0
    @Published var showPopOver: Bool = false
    @Published var defeatShow: Bool  = false
    var objectIsRigt: Bool = false
    var findedObjects: [String] = []{
        didSet{
            numberOfObjects = findedObjects.count
        }
    }
    
    func chooseObject() {
        if numberOfObjects < 10 {
            let actualObject = toFindObject
            while(actualObject == toFindObject){
                toFindObject = allObjects.filter{!findedObjects.contains($0)}.randomElement()!
            }
//            allObjects.removeAll(where: {$0 == toFindObject})
        } else {
            toFindObject = "Nenhum"
        }
    }
    
    func findedObject() {
        findedObjects.append(toFindObject)
        chooseObject()
    }
}
