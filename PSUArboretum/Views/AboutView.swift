//
//  AboutView.swift
//  PSUArboretum
//
//  Created by calvin on 12/28/23.
//

import Foundation
import SwiftUI

// no need to make this more complicated than it needs to be
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 15
            ) {
                AboutHeader(localizationKey: "about", imageName: "leaf.fill")
                
                Text("""
            **Please Note:**
            This application is **not** developed by or in association with the Pennsylvania State University (PSU) or the Arboretum _at_ PSU
            """)
                .padding([.top], 15)
                
                AboutSeparatorView()
                
                Text("""
            It exists purely as an educational tool for building a map-based application with the very latest:
            """)
                
                Text("""
              - SwiftUI MapKit
              - TheComposableArchitecture (& TCA Navigation)
              - RealmDB
            """)
                .font(.system(size: 14))
                
                AboutSeparatorView()
                
                Text("""
            The data displayed is meticulously managed by [the hard working Arboretum staff](https://arboretum.psu.edu/about/staff/) and was pulled from their own public [interactive web map](https://datacommons.maps.arcgis.com/apps/webappviewer/index.html?id=88d9267530dc48db8635703130bb084e). No work is being done by this developer to manage collections or the related data.
            """)
                
                AboutHeader(localizationKey: "acknowledgments", imageName: "trophy.fill")
                    .padding([.top], 10)
                
                Text("""
                [TheComposableArchitecture](https://github.com/pointfreeco/swift-composable-architecture)
                [RealmSwift](https://realm.io/realm-swift/)
                [CC-29 Palette](https://lospec.com/palette-list/cc-29)
                """)
            }
            
            .tint(Colors.brownOrange)
            .foregroundColor(Colors.darkGreen)
            .padding([.leading, .trailing], 28)
            .padding([.top], 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(Colors.paleGreen)
    }
}

struct AboutSeparatorView: View {
    var body: some View {
        HStack {
            Spacer()
            Rectangle()
                .fill(Colors.darkGreen)
                .padding([.leading, .trailing], 5)
                .frame(maxWidth: 50, maxHeight: 1)
            Spacer()
        }
        .padding([.top, .bottom], 10)
    }
}

struct AboutHeader: View {
    let localizationKey: String
    let imageName: String
    
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
                .fill(Colors.darkGreen)
                .padding([.leading, .trailing], 5)
                .frame(maxWidth: .infinity, maxHeight: 1.5)
        }
    }
}

struct AboutPreview: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
