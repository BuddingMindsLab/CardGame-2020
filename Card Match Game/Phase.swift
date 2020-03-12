//
//  Phase.swift
//  CardMatchGame-Kids
//
//  Created by Budding Minds Admin on 2020-01-03.
//  Copyright © 2020 Budding Minds Admin. All rights reserved.
//

import Foundation

enum PhaseType {
    case CardPhase
    case InstructionPhase
    case VideoPhase
    case PausePhase
    case FinishedPhase
    case None
}

protocol Phase {
    var type : PhaseType { get set }
    
}
