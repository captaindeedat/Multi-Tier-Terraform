resource "aws_key_pair" "my_key_pair" {
  key_name   = "terraform-auto" // Specify a name for your key pair
  public_key = file("~/.ssh/id_rsa.pub") // Path to your public key file
}
