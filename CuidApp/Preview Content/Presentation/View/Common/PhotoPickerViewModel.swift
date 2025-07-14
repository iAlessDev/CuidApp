//
//  PhotoPickerViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 10/07/25.
//

import SwiftUI
import PhotosUI

class PhotoPickerViewModel: ObservableObject {
    
    @Published var selectedPhoto: PhotosPickerItem? {
        didSet { loadSelectedPhoto() }
    }
    @Published var image: UIImage?
    @Published var selectedImageData: Data?
    @Published var errorMessage: String?
    @Published var showPhotoPicker: Bool = false
    
    
    
    func loadSelectedPhoto() {
        Task {
            guard let item = selectedPhoto,
                  let data = try? await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data)
            else { return }

            await MainActor.run {
                self.image = uiImage
                self.selectedImageData = data
            }
        }
    }

    
    func requestGalleryAccess() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            showPhotoPicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    self.showPhotoPicker = newStatus == .authorized || newStatus == .limited
                }
            }
        default:
            showPhotoPicker = false
        }
    }
}
