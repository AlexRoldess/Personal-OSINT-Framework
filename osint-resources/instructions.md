The "osint-tools-installation.sh" script installs a variety of OSINT tools on Debian-based machines, such as Kali Linux.

In this way, there are three options:

1. If you have a Debian-based machine and want to conduct OSINT investigations from it, you can simply run the script on your machine.

2. If you don't have a Debian-based machine and want to set one up from scratch, you can download a VM with a Debian-based OS from official sources, such as Kali Linux. You can download it from here: [Kali for Virtual Machine](https://www.kali.org/get-kali/#kali-virtual-machines). After setting up the VM, you can proceed to run the script.

3. If you don't have a Debian-based machine and you want one specifically optimized for OSINT tasks, you can download the TraceLabs VM. It's a Kali VM that is incredibly optimized in resources and storage for OSINT. You can download it from its repository: [TraceLabs VM Releases](https://github.com/tracelabs/tlosint-vm/releases). After downloading the VM, you can run the script.

This way, you will have a Debian-based machine with multiple tools installed for conducting personal OSINT investigations.

---

The tools that will be installed when you run the script are:

_tool name_ -> Instructions on execution

1. spiderfoot -> Run in /usr/share/spiderfoot: "./sfcli.py"
2. sherlock -> Run: "sherlock \[PARAMETERS]"
3. maltego -> Run via GUI
4. python3-shodan -> Run: "shodan \[PARAMETERS]" 
5. theharvester -> Run: "theHarvester \[PARAMETERS]" 
6. webhttrack -> Run via GUI
7. outguess -> Run: "outguess \[PARAMETERS]"
8. stegosuite -> Run via GUI
9. wireshark -> Run via GUI
10. metagoofil -> Run in /usr/share/metagoofil: "./metagoofil.py \[PARAMETERS]"
11. eyewitness -> Run in /usr/share/eyewitness: "./Eyewitness.py \[PARAMETERS]"
12. exifprobe -> Run: "exifprobe \[PARAMETERS]"
13. ruby-bundler -> Run: "ruby \[PARAMETERS]"
14. recon-ng -> Run via GUI (it opens a shell)
15. cherrytree -> Run via GUI
16. instaloader -> Run: "instaloader \[PARAMETERS]"
17. photon -> Run in /usr/share/photon: "./photon.py \[PARAMETERS]"
18. sublist3r -> Run: "sublist3r \[PARAMETERS]"
19. osrframework -> Run: "osrf \[PARAMETERS]"
20. joplin -> Run via GUI
21. drawing -> Run via GUI
22. finalrecon -> Run: "finalrecon \[PARAMETERS]"
23. cargo -> Run: "cargo \[PARAMETERS]"
24. pkg-config -> Run: "pkgconf \[PARAMETERS]"
25. curl -> Run: "curl \[PARAMETERS]"
26. python3-pip -> Run: "pip \[PARAMETERS]"
27. pipx -> Run: "pipx \[PARAMETERS]"
28. python3-exifread -> It's a library to use in Python
29. python3-fake-useragent -> It's a library to use in Python
30. yt-dlp -> Run: "yt-dlp \[PARAMETERS]"
31. keepassxc -> Run via GUI
32. exiftool -> Run: "exiftool \[PARAMETERS]"
33. tor -> Run via GUI
34. phoneinfoga -> Run: "phoneinfoga \[PARAMETERS]"
35. youtube-dl -> Run: "youtube-dl \[PARAMETERS]"
36. dnsdumpster -> It's a library to use in Python
37. h8mail -> Run: "h8mail \[PARAMETERS]"
38. tweepy -> It's a library to use in Python
39. onionsearch -> Run: "onionsearch \[PARAMETERS]"
40. sn0int -> Run in ~/tools/sn0int: "./target/release/sn0int"
41. genymotion -> Run via GUI
42. infoga -> Run in ~/tools/Infoga: "python3 infoga.py \[PARAMETERS]"
43. anonymouth -> You need to install eclipse (we've downloaded the installer), import the anonymouth project and run it from there (edu.drexel.psal.anonymouth.gooie.ThePresident.java)
44. ghunt -> Run: "ghunt login". Choose an authentication method ([See documentation](https://github.com/mxrch/GHunt))
45. xeuledoc -> Run: "xeuledoc \[PARAMETERS]"
46. littlebrother -> Run in ~/tools/LittleBrother: "python3 littlebrother.py"
47. OSINT-search -> You need to submit your API fields ([See documentation](https://github.com/am0nt31r0/OSINT-Search))
48. numspy -> You need to create an account on way2sms ([See documentation](https://bhattsameer.github.io/numspy/))
49. waybackpack -> Run: "waybackpack \[PARAMETERS]"
50. onioff -> Run in ~/tools/onioff: "python3 onioff.py \[PARAMETERS]"
51. autOSINT -> Run in ~/tools/AutOSINT: "source autosint_env/bin/activate"; "./AutOSINT.py \[PARAMETERS]"; "deactivate"

---

The tools installed in this script come from Kali Linux repositories, Github repositories, Python packages or specific installations.

It's recommended to run the script from the "Desktop" directory.
