``` bash
# first terminal

# build
make docker/all lotus_branch='feat/nv18-fevm'

# run
cd docker/devnet
docker compose up

# when done, to reset local devnet
rm -rf data
```

``` bash
# second terminal when logs look ok


# test FEVM RPCs work
curl --location --request POST http://localhost:1234/rpc/v0 \
        -w %{time_connect}:%{time_starttransfer}:%{time_total} \
        --header 'Content-Type: application/json' \
        --data-raw '{
                "jsonrpc":"2.0",
                "method":"eth_getBlockByNumber",
                "params":["0x01", true],
                "id":67
        }'

# send FIL to an eth address 
## add local network to metamask 
## RPC URL http://localhost:1234/rpc/v0 
## Chain ID 31415926
## Symbol tFIL or FIL
# add an account on metamask and convert address from eth to f4 on https://explorer.glif.io/ethereum/
docker exec -it lotus lotus send f4... 100  

# list accounts
docker exec -it lotus lotus wallet list
```

