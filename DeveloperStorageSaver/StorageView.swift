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
    @State private var buttonDisabled = true

    var body: some View {
        VStack {
            StorageDetailView(viewModel: viewModel, selection: $selection, buttonDisabled: $buttonDisabled)
            HStack {
                if selection?.directory == .coreSimulatorDevices {
                    Button {
                        viewModel.removeSimulators(option: .unavailable, directory: selection?.directory)
                    } label: {
                        Label("Delete Unavailable", systemImage: "trash.circle")
                            .contentShape(Rectangle())
                            .foregroundColor(.white)
                    }
                }
                Button {
                    viewModel.removeSimulators(option: .all, directory: selection?.directory)
                } label: {
                    Label(selection?.directory == .coreSimulatorDevices ? "Delete All" : "Delete", systemImage: "trash.circle")
                        .contentShape(Rectangle())
                        .foregroundColor(.white)
                }
            }
            .disabled(buttonDisabled)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .tint(buttonDisabled ? .gray : .red)
            .shadow(radius: 2)
            Spacer()
        }
        .onReceive(viewModel.$buttonDisabled) { buttonEnabled in
            guard let buttonEnabled = buttonEnabled else { return }
            self.buttonDisabled = buttonEnabled
        }
        .padding(.top, 10)
        .background(Gradient(colors: [.purple, .pink]))
    }
}

struct StorageDetailView: View {

    @ObservedObject var viewModel: ViewModel

    @Binding var selection: StorageSize?
    @Binding var buttonDisabled: Bool

    @State private var loadingPercentage: Double = 0.0

    @State private var textAnimation: Double = 0

    var body: some View {
        ForEach(viewModel.storageSizes, id: \.self) { storageSize in
            if storageSize.directory == viewModel.directoryToDelete {
                LoadingBarView(loadingPercentage: loadingPercentage, textAnimation: textAnimation)
                    .padding(.horizontal, 5)
            } else {
                ButtonView(selection: $selection, buttonDisabled: $buttonDisabled, storageSize: storageSize)
            }
            Rectangle()
                .frame(height: 1)
        }
        .onReceive(viewModel.$loadingTime) { loadingTime in
            withAnimation(.linear(duration: 2)) {
                loadingPercentage = loadingTime
            }
        }
    }
}

struct ButtonView: View {

    @Binding var selection: StorageSize?
    @Binding var buttonDisabled: Bool

    var storageSize: StorageSize

    var body: some View {
        Button {
            if selection == storageSize {
                selection = nil
                buttonDisabled = true
            } else {
                selection = storageSize
                buttonDisabled = false
            }
        } label: {
            HStack {
                Image(systemName: "hammer.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                    .overlay {
                        Circle()
                            .stroke(Color.green, lineWidth: 2)
                    }
                    .padding(.horizontal, 2)
                Text(storageSize.directory.rawValue + ": ")
                    .bold()
                Spacer()
                Text(storageSize.size)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(selection == storageSize ? .red : .white)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderedProminent)
        .tint(.purple)
        .cornerRadius(10)
        .padding(.horizontal, 5)
        .controlSize(.large)
    }
}

struct LoadingBarView: View {

    var loadingPercentage: Double
    @State var textAnimation: Double

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ZStack {
                    Rectangle()
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }.loadingAnimation(width: proxy.size.width, loadingPercentage: loadingPercentage)
            }

            Text("\(Int(textAnimation))")
                .foregroundColor(.white).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .textAnimation(loadingPercentage: textAnimation)
        }
        .frame(maxWidth: .infinity)
    }

    func startTime() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            textAnimation += 2
            print(textAnimation)
            if textAnimation >= 100 {
                timer.invalidate()
                textAnimation = 0
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
