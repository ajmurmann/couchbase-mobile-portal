---
id: configuring-ssl
title: Configuring SSL
permalink: guides/sync-gateway/configuring-ssl/index.html
---

Sync Gateway supports serving SSL. To enable SSL, you need to add two properties to the config file:

- `"SSLCert"`: A path to a PEM-format file containing an X.509 certificate or a certificate chain.
- `"SSLKey"`: A path to a PEM-format file containing the certificate's matching private key.

If both properties are present, the server will respond to SSL (and only SSL) over both the public and admin ports.

## How to create an SSL certificate

Certificates are a complex topic. There are basically two routes you can go: request a certificate from a Certificate Authority (CA), or create your own "self-signed" certificate.

### Requesting a certificate from a CA

You can obtain a certificate from a trusted [Certificate Authority](https://en.wikipedia.org/wiki/Certificate_authority) (CA). Examples of trusted CAs include [Let's Encrypt](https://letsencrypt.org/), Thawte or GoDaddy. What this means is that their own root certificates are known and trusted by operating systems, so any certificate that they sign will also be trusted.

Hence, the benefit of a certificate obtained from a trusted CA is that it will be trusted by any SSL client.

### Creating your own self-signed certificate

Unlike a CA-signed cert, a self-signed cert isn't intrinsically trustworthy: a client can't tell who you are by examining the cert, because no recognized authority has vouched for it. But a self-signed cert is still unique (only you, as the holder of the private key, can operate a server using that cert), and it still allows the connection to be encrypted.

It's easy to create a self-signed certificate using the openssl command-line tool and these directions. In a nutshell, you just need to run these commands:

```bash
$ openssl genrsa -out privkey.pem 2048
$ openssl req -new -x509 -sha256 -key privkey.pem -out cert.pem -days 1095
```

The second command is interactive and will ask you for information like country and city name that goes into the X.509 certificate. You can put whatever you want there; the only important part is the field `Common Name (e.g. server FQDN or YOUR name)` which needs to be the exact _hostname_ that clients will reach your server at. The client will verify that this name matches the hostname in the URL it's trying to access, and will reject the connection if it doesn't.

The tool will then create two files: `privkey.pem` (the private key) and `cert.pem` (the public certificate.)

To create a copy of the cert in binary DER format (often stored in a ".cer" file), do this:

```bash
$ openssl x509 -inform PEM -in cert.pem -outform DER -out cert.cer
```

## Installing the certificate

Whichever way you obtained the certificate, you will now have a private key and an X.509 certificate. Ensure that they're in separate files and in PEM format, and put them in a directory that's readable by the Sync Gateway process. The private key is very sensitive (it's not encrypted) so make sure the file isn't readable by unauthorized processes.

Then just add the `"SSLCert"` and `"SSLKey"` properties to your Sync Gateway configuration file.

```javascript
{
  "SSLCert": "cert.pem",
  "SSLKey": "privkey.pem",
  "databases": {
    "todo": {
      "server": "walrus:",
      "users": {"GUEST": {"disabled": false, "admin_channels": ["*"]}}
    }
  }
}
```

Start Sync Gateway and access the public port over `https` on [https://localhost:4984](https://localhost:4984).