//
//  Created by Alex.M on 28.06.2022.
//

import Foundation
import SwiftUI
import Chat

struct ChatExampleView: View {
  
  @StateObject private var viewModel: ChatExampleViewModel
  
  private let title: String
  
  init(viewModel: ChatExampleViewModel = ChatExampleViewModel(), title: String) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.title = title
  }
  
  var body: some View {
    ChatView(messages: viewModel.messages) { draft in
      viewModel.send(draft: draft)
    }
    //        messageBuilder: { message, _, _ in
    //            Text(message.text)
    //                .background(Color.green)
    //                .cornerRadius(10)
    //                .padding(10)
    //        }
  inputViewBuilder: { textBinding, attachments, state, style, actionClosure in
    Group {
      switch style {
      case .message:
        VStack {
          
          HStack(alignment: .bottom, spacing: 10) {
            HStack(alignment: .bottom, spacing: 0) {
              TextField("", text: textBinding, axis: .vertical)
                .placeholder(when: textBinding.wrappedValue.isEmpty) {
                  Text("Type a message...")
                    .foregroundColor(Color(hex: "989EAC"))
                }
                .foregroundColor(Color.black)
                .padding(10)
              
            }
            .background {
              RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "F2F3F5"))
            }
            
            Group {
              Button {
                actionClosure(.send)
              } label: {
                Image(systemName: "arrow.up")
                  .foregroundColor(.white)
                  .viewSize(44)
                  .circleBackground(.pink)
              }
            }
            .compositingGroup()
          }
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
        }
        .background(.white)
        
      case .signature:
        EmptyView()
      }
    }
  }
  .enableLoadMore(offset: 3) { message in
    viewModel.loadMoreMessage(before: message)
  }
  .messageUseMarkdown(messageUseMarkdown: true)
  .chatNavigation(
    title: viewModel.chatTitle,
    status: viewModel.chatStatus,
    cover: viewModel.chatCover
  )
  .mediaPickerTheme(
    main: .init(
      text: .white,
      albumSelectionBackground: .examplePickerBg,
      fullscreenPhotoBackground: .examplePickerBg
    ),
    selection: .init(
      emptyTint: .white,
      emptyBackground: .black.opacity(0.25),
      selectedTint: .exampleBlue,
      fullscreenTint: .white
    )
  )
  .onAppear(perform: viewModel.onStart)
  .onDisappear(perform: viewModel.onStop)
  }
}

extension Color {
  static var exampleBlue = Color(hex: "#4962FF")
  static var examplePickerBg = Color(hex: "1F1F1F")
}


extension View {
  
  func viewSize(_ size: CGFloat) -> some View {
    self.frame(width: size, height: size)
  }
  
  func circleBackground(_ color: Color) -> some View {
    self.background {
      Circle().fill(color)
    }
  }
  
  func placeholder<Content: View>(when shouldShow: Bool,
                                  alignment: Alignment = .leading,
                                  @ViewBuilder placeholder: () -> Content) -> some View {
    ZStack(alignment: alignment) {
      placeholder().opacity(shouldShow ? 1 : 0)
      self
    }
  }
}
