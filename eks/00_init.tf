

## 00_init.tf ##


terraform{
  required_version = ">=1.1.6"
}

provider "aws" {
  region = "ap-northeast-2"
#  version = ">= 4.2.0"
}


