# Helpful commands

### Get All Sizes:

```bash
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" "https://api.digitalocean.com/v2/sizes?page=1&per_page=10" | jq ".sizes[] | {slug: .slug, price: .price_monthly}"
```

### Get All Regions:

```bash
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" "https://api.digitalocean.com/v2/regions?page=1&per_page=1000" | jq ".regions[].slug"
```

### Get All Images:

```bash
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" "https://api.digitalocean.com/v2/images?page=1&per_page=1000" | jq ".images[].slug" | grep -i "ubuntu"
```

### Get SSH Key

```bash
sudo cp ~/.ssh/id_rsa.pub files/id_rsa.pub
```

### SSH into droplet

```bash
ssh root@<ipv4_ip>
```

### See Install logs on droplet

```bash
tail -f /var/log/cloud-init-output.log
```
