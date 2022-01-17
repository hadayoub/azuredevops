resourcename="AzureRMRessource"
location="North Europe"
storagename = "azurermtfdemostorage"

tags = ({environment = "demo"
        owner = "ayoub"
        purpose = "TP terraform"
        })

storage_container_name="tftestcontainer"
mydnsname=["avito.com","xnxx.ma","facebook.fr"]

security_rule = [{
    name                       = "test1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    },
    {
    name                       = "test2"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }]

enviornment = "prod"