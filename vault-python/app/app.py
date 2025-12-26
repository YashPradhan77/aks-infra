import os
import hvac
import psycopg2

VAULT_ADDR = os.getenv("VAULT_ADDR")
VAULT_ROLE = os.getenv("VAULT_ROLE")

# Kubernetes service account JWT
with open("/var/run/secrets/kubernetes.io/serviceaccount/token", "r") as f:
    jwt = f.read()

client = hvac.Client(url=VAULT_ADDR)

# Authenticate to Vault
client.auth.kubernetes.login(
    role=VAULT_ROLE,
    jwt=jwt
)

if not client.is_authenticated():
    raise Exception("Vault authentication failed")

# Fetch secrets
pg_secret = client.secrets.kv.v2.read_secret_version(
    path="app/postgres"
)

username = pg_secret["data"]["data"]["username"]
password = pg_secret["data"]["data"]["password"]

# Use secrets (this is the actual validation)
conn = psycopg2.connect(
    host="postgres.app.svc.cluster.local",
    user=username,
    password=password,
    dbname="appdb"
)

print("Connected to Postgres successfully")
