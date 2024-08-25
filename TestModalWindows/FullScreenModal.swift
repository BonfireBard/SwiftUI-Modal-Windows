import SwiftUI

struct FullScreenModal<ModalContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  @State private var modalHeight: CGFloat = 100 // Initial height
  @State private var dragOffset: CGFloat = 0
  let modalContent: () -> ModalContent
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      if isPresented {
        GeometryReader { geometry in
          Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
              withAnimation {
                isPresented = false
              }
            }
          
          VStack {
            RoundedRectangle(cornerRadius: 5)
              .fill(Color.gray)
              .frame(width: 40, height: 5)
              .padding(.top, 10)
            
            modalContent()
            
            Spacer()
          }
          .frame(height: modalHeight + dragOffset)
          .frame(maxWidth: .infinity)
          .background(Color.white)
          .cornerRadius(20)
          .shadow(radius: 10)
          .offset(y: UIScreen.main.bounds.height - modalHeight - dragOffset)
          .gesture(
            DragGesture()
              .onChanged { value in
                dragOffset = -value.translation.height
              }
              .onEnded { value in
                handleDragGesture(screenHeight: UIScreen.main.bounds.height)
              }
          )
          .transition(.move(edge: .bottom))
          .animation(.spring(), value: isPresented)
        }
        .ignoresSafeArea()
      }
    }
  }
  
  private func handleDragGesture(screenHeight: CGFloat) {
    if modalHeight + dragOffset < 50 {
      withAnimation {
        isPresented = false
      }
      return
    }
    
    if modalHeight + dragOffset > 150 {
      withAnimation(.easeInOut(duration: 0.3)) {
        dragOffset = 0
        modalHeight = screenHeight * 0.8
      }
      return
    }
    
    withAnimation(.easeInOut(duration: 0.3)) {
      modalHeight = min(max(modalHeight + dragOffset, 100), screenHeight)
      dragOffset = 0
    }
  }
}

extension View {
  func fullScreenModal<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(FullScreenModal(isPresented: isPresented, modalContent: content))
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
//    .fullScreenModal(isPresented: $isModalPresented) {
//      Text("Modal Content Test")
//        .padding()
//    }
//  }
//}
