module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.6"

  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  enable_telemetry = false

  subnets = {
    aks = {
      name             = var.aks_subnet_name
      address_prefixes = var.aks_subnet_cidrs
      # network_security_group_id = azurerm_network_security_group.aks.id
    }

    # db = {
    #   name             = var.db_subnet_name
    #   address_prefixes = var.db_subnet_cidrs
    #   # network_security_group_id = azurerm_network_security_group.db.id
    # }

    # redis = {
    #   name             = var.redis_subnet_name
    #   address_prefixes = var.redis_subnet_cidrs
    #   # network_security_group_id = azurerm_network_security_group.redis.id 
    # }

    # shared = {
    #   name             = var.shared_subnet_name
    #   address_prefixes = var.shared_subnet_cidrs
    # }
  }

  tags = var.tags
}

# # Separate DB subnet for delegate support
# resource "azurerm_subnet" "db" {
#   name                 = var.db_subnet_name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = var.vnet_name
#   address_prefixes     = var.db_subnet_cidrs

#   delegation {
#     name = "postgres-delegation"

#     service_delegation {
#       name = "Microsoft.DBforPostgreSQL/flexibleServers"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/action"
#       ]
#     }
#   }
#   depends_on = [module.vnet] 
# }


# Network Security Groups
resource "azurerm_network_security_group" "aks" {
  name                = "${var.aks_subnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "aks_allow_vnet_inbound" {
  name                        = "allow-vnet-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks.name
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = module.vnet.subnets["aks"].resource_id 
  network_security_group_id = azurerm_network_security_group.aks.id
}

# resource "azurerm_network_security_group" "db" {
#   name                = "${var.db_subnet_name}-nsg"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.tags
# }

# resource "azurerm_network_security_rule" "db_allow_aks" {
#   name                        = "allow-aks-to-db"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"

#   source_address_prefix       = var.aks_subnet_cidrs[0]
#   destination_address_prefix  = var.db_subnet_cidrs[0]
#   destination_port_range      = var.db_port
#   source_port_range           = "*"

#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.db.name
# }

# resource "azurerm_subnet_network_security_group_association" "db" {
#   subnet_id                 = azurerm_subnet.db.id
#   network_security_group_id = azurerm_network_security_group.db.id
# }

# resource "azurerm_network_security_group" "redis" {
#   name                = "${var.redis_subnet_name}-nsg"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.tags
# }

# resource "azurerm_network_security_rule" "redis_allow_aks" {
#   name                        = "allow-aks-to-redis"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"

#   source_address_prefix       = var.aks_subnet_cidrs[0]
#   destination_address_prefix  = var.redis_subnet_cidrs[0]
#   destination_port_range      = var.redis_port
#   source_port_range           = "*"

#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.redis.name
# }

# resource "azurerm_subnet_network_security_group_association" "redis" {
#   subnet_id                 = module.vnet.subnets["redis"].resource_id
#   network_security_group_id = azurerm_network_security_group.redis.id
# }

# NAT Gateway for AKS outbound traffic
resource "azurerm_public_ip" "nat_ip" {
  name                = "${var.vnet_name}-nat-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "nat" {
  name                = "${var.vnet_name}-natgw"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "Standard"
  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "aks" {
  subnet_id      = module.vnet.subnets["aks"].resource_id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
