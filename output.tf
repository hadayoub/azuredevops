output "show_storage" {
    value = azurerm_storage_account.storagename.name
}
output "show_container" {
    value = azurerm_storage_container.storagecontainer[0].container_access_type
}
output "mydnsname" {
    value = [for i in var.mydnsname: upper(i)] 
}