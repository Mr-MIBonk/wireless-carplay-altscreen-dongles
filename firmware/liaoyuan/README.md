# Liaoyuan (LY) platform

Many adapters sold under different brands are built on the same OEM software from Liaoyuan. They share the image format, the web page with HTTP upload (`/cgi-bin/index.cgi?id=upload`) and the CarPlay programs (`rcpservice`, `lylinkapp`). The changes are the same on all of them: one library, `libLyH.so`, built and checked separately for each firmware.

## Find your adapter

The brand on the case does not tell which image fits. Open the adapter's web page over its Wi-Fi and look at the firmware version. The number between the dots is the project, for example `26102410.7101.2` is ly7101.

| Version contains | Project | Folder | Image installs | CPU |
|---|---|---|---|---|
| `.5140.` | ly5140 | [Ottocast CA530](ly5140-ottocast-ca530/) | `26101218.5140.2` | RISC-V |
| `.6071.` | ly6071 | [Ottocast CA525-T2](ly6071-ottocast-ca525-t2/) | `26101215.6071.2` | RISC-V |
| `.6238.` | ly6238 | [Carlinkit Mini Ultra 3](ly6238-carlinkit-mini-ultra3/) | `26011618.6238.2` | RISC-V |
| `.7101.` | ly7101 | [No-name "smartBox"](ly7101-smartbox/) | `26102410.7101.2` | ARMv7 |

> [!WARNING]
> **Flash only the image whose project number matches your adapter.** The images decrypt the same way on every LY box, so the adapter may not stop you. The code addresses, and on ly7101 even the CPU, are different. If your project number is not in the table, there is no image for it yet.

Each image installs one exact stock version and adds the library to it. If the library finds code it does not expect, it skips that patch and the adapter works as stock. The CA525-T2, Mini Ultra 3 and ly7101 images also have a boot counter that switches the library off after 5 failed starts; the older CA530 image does not.

Other adapters on different software: [Carlinkit 4.0 (U2AW)](../carlinkit-autokit/u2aw/), [YouCast YCA01 (C12P)](../youcast/c12p/).
