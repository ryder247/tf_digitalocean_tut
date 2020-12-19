provider "digitalocean" {

}



# Create a new Web Droplet in a specified region
resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "tftesting"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
}


# Get options from digital ocean api

#GetAllSizes:       
# curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" "https://api.digitalocean.com/v2/sizes?page=1&per_page=10" | jq ".sizes[] | {slug: .slug, price: .price_monthly}"

#GetAllRegions:     
# curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" "https://api.digitalocean.com/v2/regions?page=1&per_page=1000" | jq ".regions[].slug"

#GetAllImages:      
# curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" "https://api.digitalocean.com/v2/images?page=1&per_page=1000" | jq ".images[].slug" | grep -i "ubuntu"

