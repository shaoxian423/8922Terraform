package main

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "local_file"
  resource.change.after.filename == "example.txt"
  not resource.change.after.content == "Bad, Guys!"
  msg := "Content of local_file.example must be 'Hello, Terraform!'"
}