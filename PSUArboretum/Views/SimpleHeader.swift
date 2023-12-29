//
//  SimpleHeader.swift
//  PSUArboretum
//
//  Created by calvin on 12/29/23.
//

import Foundation
import SwiftUI

struct SimpleHeader: View {
    let localizationKey: String
    let imageName: String
    let separatorColor: Color
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            HStack {
                Image(systemName: imageName)
                Text(LocalizedStringKey(stringLiteral: localizationKey))
                    .font(.system(size: 30))
                    .fontWeight(.bold)
            }
            Rectangle()
                .fill(separatorColor)
                .padding([.leading, .trailing], 5)
                .frame(maxWidth: .infinity, maxHeight: 1.5)
        }
    }
}
