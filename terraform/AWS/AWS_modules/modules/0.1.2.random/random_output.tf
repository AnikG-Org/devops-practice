output "random_passwd" {
  sensitive = true
  value     = local.random_pw
}

output "random_name" {
  value = local.random_name
}

output "random_pet" {
  value = random_pet.random_pet.id
}