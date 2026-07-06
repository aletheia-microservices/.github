import qrcode

url_github = "https://github.com/aletheia-microservices"
img_github = qrcode.make(url_github)
img_github.save("qrcode-github.png")

url_usenix = "https://www.usenix.org/conference/osdi26/presentation/ferreira"
img_usenix = qrcode.make(url_usenix)
img_usenix.save("qrcode-usenix.png")
