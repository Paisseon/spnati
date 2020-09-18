# Strip Poker Night at the Inventory
SPNatI brought to iOS

**Require:**

• iOS 11-13.5 jailbroken iDevice

• Package manager, eg Sileo

• Filza from https://mainrepo.org

• NewTerm 2 from https://repo.chariz.com

• Python 3.8 from https://apt.procurs.us

• Bottle ('python3 -m ensurepip' then 'python3 -m pip install bottle')

• debugserver from https://apt.procurs.us

• Character files from from https://b.link/spnati

**Installation:**

• Download the latest release and copy to Filza

• Move SPNatI.zip to /var/mobile

• Decompress SPNatI.zip

• Go to /var/mobile/.zshrc and copypaste the following:

alias spnati="cd /var/mobile/SPNatI; python3 offline_host.py"

alias localhost="debugserver localhost:8080"

• Add at least 8 characters by moving their folders into /var/mobile/SPNatI/opponents

• In NewTerm type 'spnati'

• Open a new tab in NewTerm and type 'localhost'

• Open Safari and go to localhost:8080. If it fails to connect try localhost:8080/index.html

![Kanna calling you hentai](https://i.ytimg.com/vi/Tcf7GO9nphw/maxresdefault.jpg)
