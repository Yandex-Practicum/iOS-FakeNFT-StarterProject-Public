//
//  FullScreenModalView.swift
//  FakeNFT
//
//  Created by Mac on 14.06.2025.
//

import SwiftUI
import PhotosUI
struct FullScreenModalView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
   
    

    @Environment(\.presentationMode) var presentationMode
    @State var description: String = ""
    @State var name: String = ""
    @State var link: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var tempImageData: Data?
   

   
    var body: some View {
        HStack{
            Spacer()
            Button("", systemImage: "xmark") {
                viewModel.save(name: name, description: description, link: link, imageData: tempImageData)
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top, 16)
            .foregroundStyle(Color.blackDay)
            .frame(width: 42,height: 42)
            .font(.system(size: 19, weight: .bold))
            
            
        }
        VStack(spacing: 20){
            ZStack(alignment: .center){
                if let data = tempImageData, let uiImage = UIImage(data: data){

                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100,height: 100)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                } else {
                    Image(.profilePhoto)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .frame(width: 70, height: 70)
                        .clipShape(.circle)
                        .overlay(
                            Circle().fill(Color.black.opacity(0.4))
                        )
                        
                    
                }
                PhotosPicker(
                    selection: $selectedItem, matching: .images,
                    photoLibrary: .shared()
                ) {
                   
                    Text("Сменить \nфото")
                                       .foregroundColor(.white)
                                       .multilineTextAlignment(.center)
                                       .font(.system(size: 10, weight: .semibold))
                                       .lineLimit(2)
                                       .minimumScaleFactor(0.5)
                                       .frame(width: 100, height: 100, alignment: .center)
                }
               
            }
            
           
            
            
        }
        .interactiveDismissDisabled(true)
        .onAppear{
            name = viewModel.name
            link = viewModel.link
            description = viewModel.description
            tempImageData = viewModel.imageData
        }
        .onChange(of: selectedItem) { newItem in
            Task{
                if let data = try? await newItem?.loadTransferable(type: Data.self){
                    tempImageData = data
                }
            }
            
        }
        
        VStack(alignment: .leading){

           
            
            Text("Имя")
                .font(.bold22)
                .foregroundColor(Color.blackDay)
                .padding(.leading)
            ZStack{
                TextField(name, text: $name)
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(8)
                     .clearButton(text: $name)
                     
            }.padding(.leading)
             .padding(.trailing)
            
            Text("Описание")
                .font(.bold22)
                .foregroundColor(Color.blackDay)
                .padding(.leading)
            ZStack{
                TextField(description, text: $description)
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(8)
                     .clearButton(text: $description)
            }.padding(.leading)
             .padding(.trailing)
            
            Text("Сайт")
                .font(.bold22)
                .foregroundColor(Color.blackDay)
                .padding(.leading)
            ZStack{
                TextField(link, text: $link)
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(8)
                     .clearButton(text: $link)
            }.padding(.leading)
             .padding(.trailing)
             
            
            
    
            
            Spacer()

        }
        
       
    }
}

struct ClearButtonModitifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View{
        content
            .overlay(
               HStack{
                   Spacer()
                   if !text.isEmpty {
                       Button(action: {
                           text = ""
                       }) {
                           Image(systemName: "xmark.circle.fill")
                               .foregroundColor(.gray)
                       }
                       .padding(.trailing, 8)
                   }
               }
               
            )
            
    }
}
extension View{
    func clearButton(text: Binding<String>) -> some View {
        self.modifier(ClearButtonModitifier(text: text))
    }
}

#Preview("FullScreenModalView MVVM") {
    let vm = ProfileViewModel()
    vm.name = "N"
    vm.description = "D"
    vm.link = "L"
    vm.imageData = UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)
    return FullScreenModalView(viewModel: vm)
}
