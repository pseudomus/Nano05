//
//  SharePlayModel.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 27/02/24.
//

import Foundation

//MARK: - Modelo que sera enviado pelo shareplay ou recebudo
struct SharePlayModelData: Codable{
    //Quantidade de acertos
    var hitsCount: UInt = 0
    //Termino de jogo
    var isFinishGame: Bool = false
    //Verifica se ja comecou a partida
}
