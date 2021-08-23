//
//  WidgetViewMedium.swift
//  GuestData
//
//  Created by Justin Oakes on 8/22/21.
//

import SwiftUI
import GuestData

struct WidgetViewMedium: View {
    @Binding var guestData: GuestData
    var body: some View {
        ZStack {
            Color(red: 0.918, green: 0.871, blue: 1.0)
            VStack {
                HStack {
                    Text("Guests")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding()
                    Spacer()
                }
                HStack {
                    Text("RSVP yes: \(guestData.numberOfConfirmedYes)")
                        .foregroundColor(Color.black)
                    Spacer()
                    Text("RSVP no: \(guestData.numberOfConfirmedNo)")
                        .foregroundColor(Color.black)
                }
                .padding(.horizontal)
                HStack {
                    Text("Replies: \(guestData.numberOfReplies)")
                        .foregroundColor(Color.black)
                    Spacer()
                    Text("Guest count: \(guestData.totalGuests)")
                        .foregroundColor(Color.black)
                }
                .padding()
            }
        }
    }
}

struct WidgetViewMedium_Previews: PreviewProvider {
    static var previews: some View {
        let guestData = GuestData(numberOfReplies: 2,
                                  numberOfConfirmedYes: 2,
                                  numberOfConfirmedNo: 2,
                                  totalGuests: 2)
        WidgetViewMedium(guestData: .constant(guestData))
            .previewLayout(.fixed(width: 320.0, height: 200.0))
    }
}
