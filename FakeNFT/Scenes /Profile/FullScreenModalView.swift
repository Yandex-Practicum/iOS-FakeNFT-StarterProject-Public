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
            Button("", systemImage: "plus") {
                UserDefaults.standard.set(description, forKey: "description")
                UserDefaults.standard.set(name, forKey: "name")
                UserDefaults.standard.set(link, forKey: "link")
                presentationMode.wrappedValue.dismiss()
            }
            .rotationEffect(Angle(degrees: 45))
            .foregroundStyle(Color.blackDay)
            
        }
        VStack(spacing: 20){
            ZStack(alignment: .center){
                if let data = imageData, let uiImage = UIImage(data: data){
                    PhotosPicker(selection: $selectedItem, matching: .images)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120,height: 120)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                        }.padding()
                        
                        
                    
                }
                Text("Сменить \nфото")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .frame(width: 100, height: 100, alignment: .center)
            }
            
           
            
            
        }
        .navigationTitle("Выбор изображения")
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
            }.padding(.leading)
             .padding(.trailing)
            
            Text("Ссылка")
                .font(.bold22)
                .foregroundColor(Color.blackDay)
                .padding(.leading)
            ZStack{
                TextField(link, text: $link)
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(8)
            }.padding(.leading)
             .padding(.trailing)
            
            
    
            
            Spacer()

        }
        
       
    }
}

#Preview {
    FullScreenModalView()
}
