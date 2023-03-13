//
//  ImagePicker.swift
//  Wevent V.1
//
//  Created by Palm on 4/5/2564 BE.
//

import SwiftUI
import Mantis

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

struct ImagePicker2: UIViewControllerRepresentable {

    
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker2>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker2>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker2
        init(_ parent: ImagePicker2) {
           
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}


struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage
    @Binding var cropShapeType: Mantis.CropShapeType
    @Binding var presetFixedRatioType: Mantis.PresetFixedRatioType
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: CropViewControllerDelegate {
        var parent: ImageCropper
        
        init(_ parent: ImageCropper) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            parent.image = cropped
            print("transformation is \(transformation)")
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        }
        
        func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CropViewController {
        var config = Mantis.Config()
        config.cropShapeType = cropShapeType
        config.presetFixedRatioType = presetFixedRatioType
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
        
    }
}
