from jnpr.junos import Device

mydeviceslist=["172.30.108.214", "172.30.108.210"]
for item in mydeviceslist:
    dev=Device(host=item, user="tiaddemo", password="OpenConfig")
    dev.open()
    dev.close()
    print (dev.facts["hostname"]+ " is an " + dev.facts['model'] + " running " + dev.facts["version"]+"\n")
print "Done!"


