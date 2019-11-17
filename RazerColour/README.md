# RazerColor - A basic scripting language for chroma interfacing.

Simply call the lightpack you wish to use by running `RazerColour.exe [lightpack location or name]`.
For some examples of how to use, see `/ExampleLightpacks/`.
Scripts must be placed into `C:\ProgramData\ZRazer\Lightpacks`, or lightpack location specified during application call.

General structure is 
```
rgb [rgb value] ; The below keys are changed to [rgb value] (Comments denoted by ";")

key1
key2
key3 ; etc...

rgb [second rgb value] ; Now all below keys will be second value

key4
key5
key6 ; etc...
```