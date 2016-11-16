from jnpr.junos import Device

mydeviceslist=["172.30.54.235", "172.30.54.146", "172.30.54.107", "172.30.54.108", "172.30.54.109", "172.30.54.110", "172.30.52.65", "172.30.52.66", "172.30.52.63", "172.30.52.64", "172.30.54.23"]

for item in mydeviceslist:
    dev=Device(host=item, user="lab", password="m0naco")
    dev.open()
    dev.close()
    print (dev.facts["hostname"]+ " is an " + dev.facts['model'] + " running " + dev.facts["version"]+"\n")
print "Done!"


