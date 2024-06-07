// Created for BookingSense on 07.06.24 by kenny
// Using Swift 5.0

import SwiftUI

struct LockedView: View {

    @EnvironmentObject var securityController: SecurityController

    var body: some View {
        Button("Unlock") {
            securityController.authenticate()
        }.padding()
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }

}

struct LockedView_Previews: PreviewProvider {
    static var previews: some View {
        LockedView()
    }
}
