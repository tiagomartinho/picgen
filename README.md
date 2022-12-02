# picgen
Picture Generator SwiftUI App using Core ML Stable Diffusion

To run the app you need to add a folder called "model" to the Xcode Project using [Apple Core ML Stable Diffusion](https://github.com/apple/ml-stable-diffusion).

This folder must contain the following files (which I didn't include because of the model size):
  * merges.txt
  * SafetyChecker.mlmodelc
  * TextEncoder.mlmodelc
  * Unet.mlmodelc
  * UnetChunk1.mlmodelc
  * UnetChunk2.mlmodelc
  * VAEDecoder.mlmodelc
  * vocab.json

The command (after following these [instructions](https://github.com/apple/ml-stable-diffusion#readme)) I used was:
```shell
python -m python_coreml_stable_diffusion.torch2coreml --convert-unet --convert-text-encoder --convert-vae-decoder --convert-safety-checker --bundle-resources-for-swift-cli --chunk-unet -o output
```
