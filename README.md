# Installing Debian on a late model 2016 Lenovo X1 Carbon (4th Generation)

## Resources Used

https://wiki.debian.org/InstallingDebianOn/Thinkpad/X1%20Carbon%204thGen%20PCIe_SSD/jessie


## Resulting System

**Debian Version:**  
Stretch (9.0)
XFCE Desktop

Initially, I started working with Jessie (8.7) with backports based on information from the referenced link above. While this did work initially, I found that there were miscellaneous things that I wanted to upgrade from 'stable' and to hopefully resolve issues with the EFI boot loader not properly saving the boot order changes.

Details on these travails will be covered a little further below.


## Hardware Information

The label on the bottom indicates this is a **Type 20FB, X1 Carbon**. This is an Intel, Skylake quad-core system.

```
$ lspci
00:00.0 Host bridge: Intel Corporation Skylake Host Bridge/DRAM Registers (rev 08)
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 520 (rev 07)
00:08.0 System peripheral: Intel Corporation Skylake Gaussian Mixture Model
00:13.0 Non-VGA unclassified device: Intel Corporation Device 9d35 (rev 21)
00:14.0 USB controller: Intel Corporation Sunrise Point-LP USB 3.0 xHCI Controller (rev 21)
00:14.2 Signal processing controller: Intel Corporation Sunrise Point-LP Thermal subsystem (rev 21)
00:16.0 Communication controller: Intel Corporation Sunrise Point-LP CSME HECI #1 (rev 21)
00:1c.0 PCI bridge: Intel Corporation Device 9d10 (rev f1)
00:1c.2 PCI bridge: Intel Corporation Device 9d12 (rev f1)
00:1c.4 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Port #5 (rev f1)
00:1f.0 ISA bridge: Intel Corporation Sunrise Point-LP LPC Controller (rev 21)
00:1f.2 Memory controller: Intel Corporation Sunrise Point-LP PMC (rev 21)
00:1f.3 Audio device: Intel Corporation Sunrise Point-LP HD Audio (rev 21)
00:1f.4 SMBus: Intel Corporation Sunrise Point-LP SMBus (rev 21)
00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection I219-LM (rev 21)
02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A PCI Express Card Reader (rev 01)
04:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
05:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller (rev 01)
```


```
$ sudo lsusb -v | grep -E '\<(Bus|iProduct|bDeviceClass|bDeviceProtocol)' 2>/dev/null
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
  bDeviceClass            9 Hub
  bDeviceProtocol         3 
  iProduct                2 xHCI Host Controller
Bus 001 Device 004: ID 138a:0090 Validity Sensors, Inc. 
  bDeviceClass          255 Vendor Specific Class
  bDeviceProtocol       255 
  iProduct                0 
      (Bus Powered)
  (Bus Powered)
Bus 001 Device 003: ID 13d3:5248 IMC Networks 
  bDeviceClass          239 Miscellaneous Device
  bDeviceProtocol         1 Interface Association
  iProduct                1 Integrated Camera
      (Bus Powered)
  bDeviceClass          239 Miscellaneous Device
  bDeviceProtocol         1 Interface Association
  (Bus Powered)
Bus 001 Device 002: ID 8087:0a2b Intel Corp. 
  bDeviceClass          224 Wireless
  bDeviceProtocol         1 Bluetooth
  iProduct                0 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
  bDeviceClass            9 Hub
  bDeviceProtocol         1 Single TT
  iProduct                2 xHCI Host Controller

```

Only one of four cores copied here; same for all cores.
```
$ cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 78
model name	: Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz
stepping	: 3
microcode	: 0xa2
cpu MHz		: 800.018
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 22
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 xsaves dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
bugs		:
bogomips	: 4992.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:
```

## Issues Encountered

**Network Connectivity**

The kernel provided with the Jessie installer doesn't play nice with the wifi card, so you will need to secure either a USB to RJ45 dongle, or another dongle that uses the proprietary connection on the left side of the laptop, for network installation and updates.

**Resizing Windows Pro 64 bit**

In efforts to keep a bootable Windows partition for those rare instances where I need it, resizing took several repeat steps. Windows permitted me to shrink the partition only a certain amount, then with a reboot, I was able to shrink it further. This permitted me to reduce the Windows partition to about 80 GB.

**BIOS & EFI**

Based on information from the reference link, I knew that there would be issues with stock Jessie kernel installed, so I updated sources.list and applied the backported kernel and ```grub-efi-amd64```, but on reboot grub was not found and Windows started automatically. After repeated attempts to write the EFI boot menu with the ```efibootmgr``` command, I would experience the same thing. Finally, Initially, I resorted to booting off a USB thumb drive which made using encryption challenging. 

Eventually, I installed CentOS which ultimately succeeded in writing a proper boot loader menu and grub was finally loaded on the next reboot. Of course, because I didn't update the kernel for that install, the boot ultimately failed, but it proved that the Debian ```efibootmgr``` is insufficient to change the EFI boot manager list permanently.

After cleaning up from the temporary install and cleaning up the boot order list, Debian went back on and a hack was created and installed. It's ugly, but it works:

```
#!/bin/bash

# Because the X1 Carbon (4th Gen) has a broken UEFI, some serious
# hacks are required to be able to dual boot back into this Linux
# instance. Here we attempt to make this possible by using the
# BootNext flag with efibootmgr as changing BootOrder doesn't work.

PATH=/sbin:/usr/sbin:/bin:/usr/bin

NEXT=`efibootmgr | grep BootNext | cut -c11-14`
DEB=`efibootmgr | grep debian | cut -c5-8`
ORDER=`efibootmgr | grep BootOrder | cut -c12-`

# Check to see if the last time we set BootOrder stuck:

echo $ORDER | grep -q $DEB
TEST=`echo $?`

if [ "$TEST" = "0" ];
then
	exit
else

	# Check if BootNext is set and bail, or set it

	if [ "$NEXT" != "$DEB" ];
	then
		efibootmgr -n $DEB
	else
		exit
	fi

	# Here we'll reset the boot order

	efibootmgr -O
	efibootmgr -o $DEB,$ORDER
fi
```

To make this run every reboot, I opted to dump a line in ```/etc/rc.local``` to run this script on boot to reset the boot menu to load Debian on the next boot. The caveat to this is that if/when Windows is started, it will be necessary to boot off a USB thumb drive to reset the boot menu to Debian once again.

The alternative to using ```/etc/rc.local``` would be to make an entry in the root crontab to execute the script on reboot with the time of ```@reboot```. The choice is yours.

Ultimately, it would be nice to have ```efibootmgr``` for Debian be updated so that it works with this hardware, but I haven't had the time or patience to chase it down and file an appropriate bug report.

## Suspend and Hibernate

With stock install, closing the lid firmly enables suspend sleep state S3. No configurations were done for this.

Hibernation, when selected from the "Log Out" options panel sends system into sleep state S4 without special configuration required.


