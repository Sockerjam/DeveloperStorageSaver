//
//  ContentView.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 15/03/2023.
//

import SwiftUI

struct StorageView: View {

    @StateObject var viewModel = ViewModel()

    @State private var selection: StorageSize?
    @State private var deleteIsPressed = false
    
    var body: some View {
        VStack {
            ForEach(viewModel.storageSizes, id: \.self) { storageSize in
                Button {
                    selection = storageSize
                } label: {
                    HStack {
                        Image(systemName: "hammer.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                            .overlay {
                                Circle()
                                    .stroke(Color.green, lineWidth: 2)
                            }
                            .padding(.horizontal, 2)
                        Text(storageSize.directory + ": ")
                            .bold()
                        Spacer()
                        Text(storageSize.size)
                    }
                    .padding(.horizontal, 8)
                    .foregroundColor(selection == storageSize ? .blue : .white)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 5)
                .controlSize(.large)
                Rectangle()
                    .frame(height: 1)
            }

            Button {
                print(selection)
                deleteIsPressed.toggle()
                withAnimation(.easeOut(duration: 0.3)) {
                    deleteIsPressed.toggle()
                }
            } label: {
                Label("Delete", systemImage: "trash.circle")
                    .contentShape(Rectangle())
                    .foregroundColor(.white)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .scaleEffect(deleteIsPressed ? 1.3 : 1)


            Spacer()
        }
        .padding(.top, 10)
        .frame(width: 300)
        .background(Gradient(colors: [.purple, .pink]))
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(.blue)
            .foregroundColor(.white)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
