import SwiftUI
import CoreML
import StableDiffusion

struct ContentView: View {
    
    @State var prompt: String = "a photo of an astronaut riding a horse on mars"
    @State var image: CGImage?
    @State var progress = 0.0
    @State var generating = false
    @State var booting = true

    @State var pipeline: StableDiffusionPipeline?
    
    var body: some View {
        VStack {
            if booting {
                Text("Initializing...")
            } else {
                if let image {
                    Image(image, scale: 1.0, label: Text(""))
                }
                if generating {
                    ProgressView(value: progress)
                }
                if !generating {
                    TextField("Prompt", text: $prompt)
                    Button("Generate") {
                        progress = 0.0
                        image = nil
                        generating = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            var images: [CGImage?]?
                            do {
                                print("generate")
                                images = try pipeline?.generateImages(prompt: prompt, disableSafety: true, progressHandler: { progress in
                                    print("test")
                                    DispatchQueue.main.async {
                                        self.progress = Double(progress.step) / 50
                                        if let image = progress.currentImages.first {
                                            self.image = image
                                        }
                                    }
                                    return true
                                })
                            } catch let error {
                                print(error.localizedDescription)
                            }
                            print("finish")
                            if let image = images?.first {
                                self.image = image
                            }
                            generating = false
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let url = Bundle.main.resourceURL?.appending(path: "model")
                    print("loaded url")
                    pipeline = try StableDiffusionPipeline(resourcesAt: url!, disableSafety: true)
                } catch let error {
                    print(error.localizedDescription)
                }
                booting = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
