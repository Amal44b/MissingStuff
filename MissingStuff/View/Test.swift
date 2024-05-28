//
//  Test.swift
//  تفقّد
//
//  Created by Maryam Mohammad on 20/11/1445 AH.
//

import SwiftUI

import SwiftUI


struct Test: View {
    private enum Field: Int, CaseIterable {
        case username, password
    }

    @State private var username: String = ""
    @State private var password: String = ""

    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationView {
            Form {
                TextField("Username", text: $username)
                    .focused($focusedField, equals: .username)
                SecureField("Password", text: $password)
                    .focused($focusedField, equals: .password)
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
}

#Preview {
    Test()
}
