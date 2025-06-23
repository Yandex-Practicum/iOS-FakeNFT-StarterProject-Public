//
//  FullScreenModalView.swift
//  FakeNFT
//
//  Created by Mac on 14.06.2025.
//

import SwiftUI
import PhotosUI
struct FullScreenModalView: View {
   

    @Environment(\.presentationMode) var presentationMode
    @State var description: String = ""
    @State var name: String = ""
    @State var link: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @AppStorage("savedImage") private var imageData: Data?
   
    var body: some View {
        HStack{
            Spacer()
            Button("", systemImage: "xmark") {
                UserDefaults.standard.set(description, forKey: "description")
                UserDefaults.standard.set(name, forKey: "name")
                UserDefaults.standard.set(link, forKey: "link")
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top, 16)
            .foregroundStyle(Color.blackDay)
            .frame(width: 42,height: 42)
            .font(.system(size: 19, weight: .bold))
            
            
        }
        VStack(spacing: 20){
            ZStack(alignment: .center){
                if let data = imageData, let uiImage = UIImage(data: data){

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
        .onChange(of: selectedItem) { newItem in
            Task{
                if let data = try? await newItem?.loadTransferable(type: Data.self){
                    imageData = data
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

#Preview {
    FullScreenModalView()
}
