//
//  CameraModel.swift
//  fruitDetector
//
//  Created by Luca Lacerda on 22/02/24.
//
import SwiftUI
import AVFoundation
import CoreImage
import CoreML
import Foundation

class CameraModel:NSObject, ObservableObject {
    
    @Published var frama:UIImage?
    private var captureSession:AVCaptureSession = AVCaptureSession()
    private var videoOutput:AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private var context = CIContext()
    private var backCamera:AVCaptureDevice?
    private var backInput:AVCaptureDeviceInput?
    private var imageClassifier: HomeObjects?
    
    override init() {
        super.init()
        checkPermission()
        setupCaptureSession()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (autorized) in
                if !autorized{
                    fatalError()
                }
            }
        default:
            fatalError()
        }
    }
    
    func setupCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputs()
            
            self.setupOutputs()
            
            self.captureSession.commitConfiguration()
            
            self.captureSession.startRunning()
        }
    }
    
    func setupOutputs() {
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInitiated)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError()
        }
        
        videoOutput.connections.first?.videoRotationAngle = 90
    }
    
    func setupInputs() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back){
            self.backCamera = device
        } else {
            fatalError()
        }
        guard let bInput = try? AVCaptureDeviceInput(device: self.backCamera!) else {fatalError()}
        backInput = bInput
        if !captureSession.canAddInput(backInput!) {
            fatalError()
        }
        captureSession.addInput(backInput!)
    }
    
    func classifyImage() {
        do {
            let model = try HomeObjects(configuration: MLModelConfiguration())
            guard let pixelBuffer = frama?.toCVPixelBuffer() else { return }
            let prediction = try model.prediction(image: pixelBuffer)
            
            print("\(prediction.target)")
            print("rodou")
        } catch {
            // Lide com o erro aqui, por exemplo, imprimindo a mensagem de erro
            print("Erro ao classificar a imagem: \(error)")
        }
    }

}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        DispatchQueue.main.async { [unowned self] in
            self.frama = cgImage
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
}

extension UIImage {
    // https://www.hackingwithswift.com/whats-new-in-ios-11
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}
