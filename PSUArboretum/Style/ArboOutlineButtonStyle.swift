//
//  ArboOutlineButtonStyle.swift
//  PSUArboretum
//
//  Created by calvin on 12/26/23.
//

import Foundation
import SwiftUI

struct ArboOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if configuration.isPressed {
            configuration.label.foregroundColor(Colors.paleOrange)
        } else {
            configuration.label.foregroundColor(Colors.paleYellow)
        }
    }
}
