//
//  MeView.swift
//  HotProspects
//
//  Created by Peter Hartnett on 5/3/22.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    //***QR code properties for creating the context and storing a qrcode filter
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        //String to data
        filter.message = Data(string.utf8)

        //check that data conversion worked, else return "xmark.circle" for the image.
        if let outputImage = filter.outputImage {
            //Try to make the QR code via the filter and return it as a UIImage
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        //should "xmark.circle" fail for some reason, just return a blank
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    //***End QR code requirements, should be able to reuse this block
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                   // .frame(width: 200, height: 200)
                    
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
            }
            .navigationTitle("Your code")
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
            
    }
}


