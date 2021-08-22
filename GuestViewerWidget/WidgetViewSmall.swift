//
//  WidgetViewSmall.swift
//  GuestData
//
//  Created by Justin Oakes on 8/22/21.
//

import SwiftUI

struct WidgetViewSmall: View {
    var body: some View {
        VStack {
            Text("Guests")
                .fontWeight(.bold)
            Text("0")
                .font(.system(size: 72.0))
                .fontWeight(.semibold)
                .padding()
            Spacer()
        }
    }
}

struct WidgetViewSmall_Previews: PreviewProvider {
    static var previews: some View {
        WidgetViewSmall()
            .padding()
            .previewLayout(.fixed(width: 175, height: 175))
    }
}
