aws_region = "us-east-1"
prefix     = "terraform-demo"
env        = "dev"

# Put your SSH public key here so Terraform creates the key pair.
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrzDcDR8BCM5t0yTpat90qulovOjJkBgTUOHBhmwULQBPKCIIYpWh3h8BOMac9stbImcNo83v3j8vVVgMBq6UveVpHbi/hnFma9FaJu7UpT6dLqUUf8LMj9x1UhlX1HuzhFJLVuwLH7cuEyYiDTqFykUYaBDF5cbsyM9frXBc91YD0ut40J6pHcppoc0phmBlIXtZ6HXGoEDYP2NFSMoJH6NUlKXBZ6qNjCvfENtqYNG9V4D4oXqh68Fp7X0mQpadcrbmlaUnXUa3og5Z2+Ue2aqD8SWqPVsSGwTKB1Gz5Bh8APGKdUG3uiZs4EKSILIYT/9xOLX00Fu1ScWwfWsvsaph0L5KMWgHGmu+jKGYcAdp4psztNYN3kGPWNLDBnTVI08FF3OgvSCRXsNRaa+xRUDzJJlWKP+UI5rhB00XbFQngAsIpRIPFwUkCdblPBuaaUDOp7y67dQ4BB+ZWxWIU3BgEXgvKquueLkcZW5YoVMaHXibySxk3ZZPXTEMrKqunlXclyeyU0F4pCfpkpOOv4QMstHWbGDmZ3xrdlc4X1sI1Se1BUsSNO+zCtaJGUTscz5h8RPxhDRmiaaJ4pZz9yQ3OBEIzIaMU8xTdG2gjq8qYStHZpJXCdnR+YtKgaD/lUmSX9YYldu7iwPt+sXvBDU/7iI23dRuxR+99UsSynQ== shukumar@C18836"

# ensure tag environment matches
tags = {
  Owner       = "Shubh"
  Environment = "dev"
}
