//
//  WidgetViewSmall.swift
//  GuestData
//
//  Created by Justin Oakes on 8/22/21.
//

import SwiftUI

struct WidgetViewSmall: View {
    @Binding var guestsCount:Int
    var body: some View {
        ZStack {
            Color(red: 0.918, green: 0.871, blue: 1.0)
            VStack {
                Text("Guests")
                    .fontWeight(.bold)
                    .padding(.top)
                Text("\(guestsCount)")
                    .font(.system(size: 72.0))
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }
}

struct WidgetViewSmall_Previews: PreviewProvider {
    static var previews: some View {
        WidgetViewSmall(guestsCount: .constant(4))
            .previewLayout(.fixed(width: 175, height: 175))
    }
}
