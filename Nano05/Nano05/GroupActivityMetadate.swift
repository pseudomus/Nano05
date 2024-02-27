//
//  GroupActivityMetadate.swift
//  Nano05
//
//  Created by Gustavo Horestee Santos Barros on 27/02/24.
//

import GroupActivities
import UIKit

//MARK: - Metadate da sessao de compartilhamento
struct SharePlayActivityMetadata: GroupActivity{
    var date = Date()
    
    var metadata: GroupActivityMetadata{
        var meta = GroupActivityMetadata()
        meta.title = "Vem para batalha"
        meta.subtitle = "Criado em \(date)"
        meta.previewImage = UIImage(resource: .imageSharePLay).cgImage
        meta.type = .generic
        return meta
    }
}
