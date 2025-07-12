//
//  PhotoPickerViewModel.swift
//  CuidApp
//
//  Created by Paul Flores on 10/07/25.
//

import SwiftUI
import PhotosUI

class PhotoPickerViewModel: ObservableObject {
    
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var image: UIImage?
    @Published var selectedImageData: Data?
    @Published var errorMessage: String?
    
    
    
    func loadSelectedPhoto() {
        Task {
            await withTaskGroup(of: (UIImage?, Error?).self) { taskGroup in
                taskGroup.addTask {
                    do {
                        if
                            let imageData = try await self.selectedPhoto?.loadTransferable(type: Data.self),
                            let image = UIImage(data: imageData) {
                            return (image, nil)
                        }
                        return (nil, nil)
                    } catch {
                        return (nil, nil)
                    }
                }
                for await result in taskGroup {
                    if result.1 != nil {
                        errorMessage = "Failed to lead image"
                        break
                    } else if let image = result.0 {
                        self.image = image
                    }
                    
                }
            }
        }
    }
}
