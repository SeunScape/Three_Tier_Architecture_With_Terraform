variable "db_username" {
    description = "db username"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "password for the db"
    type = string
    sensitive = true
}

variable "db_instance" {
    description = "name prefix of the database"
    type = string
}