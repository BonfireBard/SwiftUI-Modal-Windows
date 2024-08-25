import SwiftUI

struct ContentView: View {
  @State private var isModalPresented = false
  @State private var modalHeight: CGFloat = 100 // Initial height
  
  var body: some View {
    ZStack {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")
        Button("Show Modal") {
          isModalPresented.toggle()
        }
      }
      .padding()
      
      if isModalPresented {
        ModalWindow(height: $modalHeight, isPresented: $isModalPresented)
          .transition(.move(edge: .bottom))
          .animation(.spring(), value: isModalPresented)
      }
    }
  }
}

struct ModalWindow: View {
  @Binding var height: CGFloat
  @Binding var isPresented: Bool
  @State private var dragOffset: CGFloat = 0
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        RoundedRectangle(cornerRadius: 5)
          .fill(Color.gray)
          .frame(width: 40, height: 5)
          .padding(.top, 10)
        
        Text("Modal Content")
          .padding()
        
        Spacer()
      }
      .frame(height: height + dragOffset)
      .frame(maxWidth: .infinity)
      .background(Color.white)
      .cornerRadius(20)
      .shadow(radius: 10)
      .offset(y: geometry.size.height - height - dragOffset)
      .gesture(
        DragGesture()
          .onChanged { value in
            //let newHeight = height - value.translation.height
            //dragOffset = min(max(newHeight - height, 0), geometry.size.height - height)
            dragOffset = -value.translation.height
          }
          .onEnded { value in
            if height + dragOffset < 50 {
              withAnimation {
                isPresented = false
              }
              return
            }
            
            if height + dragOffset > 150 {
              
              withAnimation(.easeInOut(duration: 2)) {
                dragOffset = 0
                height = geometry.size.height * 0.8
              }
              return
            }
            
            height = min(max(height + dragOffset, 100), geometry.size.height)
            dragOffset = 0
            
          }
      )
      .onAppear {
        height = 100
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}
