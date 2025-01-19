from iroha import IrohaCrypto

priv = IrohaCrypto.private_key()
pub = IrohaCrypto.derive_public_key(priv)

# Save node keys
with open('iroha/keys/node0.priv', 'wb') as f:
    f.write(priv)
with open('iroha/keys/node0.pub', 'wb') as f:
    f.write(pub)