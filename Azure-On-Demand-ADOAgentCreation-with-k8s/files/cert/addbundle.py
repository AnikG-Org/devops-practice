import certifi

ca_bundle_path = certifi.where()

with open("./poccert.pem", "r") as f:
    poc_bundle = f.read()

with open(ca_bundle_path, "r") as f:
    ca_bundle = f.read()
    
if poc_bundle not in ca_bundle:
    with open(ca_bundle_path, "a") as f:
        f.write(poc_bundle)    
