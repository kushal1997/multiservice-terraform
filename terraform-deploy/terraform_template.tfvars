# terraform.tfvars.example -> copy to terraform.tfvars (should NOT be committed)
aws_region = "us-west-2"
instance_type = "t3.micro"
key_name = ""
ami_id = "ami-03aa99ddf5498ceb9"

# optional: override images
# frontend_image = "yourrepo/fe:tag"

# sensitive (fill with real values)
atlas_user_uri    = "mongodb+srv://<user>:<pass>@cluster0.xxxxxx.mongodb.net/ecommerce_users"
atlas_product_uri = "mongodb+srv://<user>:<pass>@cluster0.xxxxxx.mongodb.net/ecommerce_products"
atlas_cart_uri    = "mongodb+srv://<user>:<pass>@cluster0.xxxxxx.mongodb.net/ecommerce_carts"
atlas_order_uri   = "mongodb+srv://<user>:<pass>@cluster0.xxxxxx.mongodb.net/ecommerce_orders"

jwt_secret = "replace-with-a-strong-secret"
