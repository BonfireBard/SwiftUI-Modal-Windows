import SwiftUI

struct PopUpModal<ModalContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  let modalContent: () -> ModalContent
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      if isPresented {
        Color.black.opacity(0.4)
          .ignoresSafeArea()
          .overlay {
            modalView()
          }
          .transition(.opacity)
      }
    }
    .animation(.easeInOut, value: isPresented)
  }
  
  @ViewBuilder
  private func modalView() -> some View {
    VStack {
      modalContent()
    }
    .padding()
    .background(Color.white)
    .cornerRadius(20)
    .shadow(radius: 10)
    .padding(40)
    .transition(.scale)
    .zIndex(1)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .contentShape(Rectangle())
    .onTapGesture {
      // Do nothing, preventing taps from dismissing the modal
    }
    .overlay(
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          isPresented = false
        }
    )
  }
}

extension View {
  func popUpModal<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(PopUpModal(isPresented: isPresented, modalContent: content))
  }
}

//struct ContentView: View {
//  @State private var isModalPresented = false
//  
//  var body: some View {
//    VStack {
//      Image(systemName: "globe")
//        .imageScale(.large)
//        .foregroundStyle(.tint)
//      Text("Hello, world!")
//      Button("Show Modal") {
//        isModalPresented.toggle()
//      }
//    }
//    .padding()
//    .popUpModal(isPresented: $isModalPresented) {
//      VStack(spacing: 20) {
//        Text("Modal Content")
//          .font(.headline)
//        Text("This pop-up modal adjusts to content size without using GeometryReader.")
//        Text("This pop-up modal adjusts to content size without using GeometryReader.")
//        Text("This pop-up modal adjusts to content size without using GeometryReader.")
//          .multilineTextAlignment(.center)
//        Button("Close") {
//          isModalPresented = false
//        }
//      }
//      .padding(30)
//    }
//  }
//}
